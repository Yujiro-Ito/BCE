class Player extends BaseCharacter {
  static final int SPEED = 4;
  private boolean _leftKey, _rightKey, _upKey, _downKey;
  //-------move number-------
  static final int MOVE_STATE_UP = 0;
  static final int MOVE_STATE_DOWN = 1;
  static final int MOVE_STATE_RIGHT = 2;
  static final int MOVE_STATE_LEFT = 3;
  static final int MOVE_STATE_NON = 4;
  private int _moveState;
  private Player _enemy;
  
  //------playerState number-----
  static final int STATE_MOVE = 0;
  static final int STATE_EXCHANGE = 1;
  public int _state;
  
  //-----businesscard exchange state number-----
  static final int MAX_RANGE = 100;
  static final int ORIGIN_POS_X = 80;
  static final int GAUGE_WIDTH = 40;
  static final float GAUGE_SPEED = 5;
  private int _gaugeRange;
  private float _gaugeSpeed;
  private float _gaugeHitRange;
  private float _gaugeHitPos;
  private boolean _gaugeStop;
  private AI _memoryAI;
  private char _gaugeStopChar;
  private int _frameCount;
  static final int FRAME_MAX = 20;
  private double _nextPos;
  
  //-----business card array-----
  private int CARD_MAX = 3;
  private int[] _pointArray;
  private PImage[] _imageArray;
  private int _cardState;
  
  public int _playerNumber;
  final int FRAME_SIZE = 40;
  final int ADJUST_Y = 30;
  
  private MyGame _parent;
  
  public int _animation;


  public Player(Game parent, String name) {
    super(parent, name, 3, 4);
    _leftKey = false;
    _rightKey = false;
    _upKey = false;
    _downKey = false;
    _moveState = MOVE_STATE_NON;
    changeAnimation(ANIM_FRONT);
    _animation = ANIM_FRONT;
    _state = STATE_MOVE;
    _gaugeRange = 0;
    _gaugeSpeed = GAUGE_SPEED;
    _gaugeHitRange = 0;
    _gaugeHitPos = 0;
    _frameCount = 0;
    _cardState = 0;
    _nextPos = 0;
    _pointArray = new int[CARD_MAX];
    _imageArray = new PImage[CARD_MAX];
    _playerNumber = 0;
    _parent = (MyGame)parent;
  }

  public void update(double deltaTime) {
    
    switch(_state){
      case STATE_MOVE:
        moveManage();
        break;
      case STATE_EXCHANGE:
        exchangeState();
        break;
    }
    super.update(deltaTime);
  }
  
  public void assignBusinessCard(int point, PImage image){
    if(_cardState < CARD_MAX){
      _pointArray[_cardState] = point;
      _imageArray[_cardState] = image;
      _cardState++;
    }
  }
  
  public int hitBusiness(){
    int result = 0;
    for(int i = 0; i < CARD_MAX; i++){
      result += _pointArray[i];
    }
    _pointArray = new int[CARD_MAX];
    _imageArray = new PImage[CARD_MAX];
    for(int i = 0; i < CARD_MAX; i++){
      _pointArray[i] = 0;
    }
    _cardState = 0;
    return result;
  }
  
  public void desideExchangeStateNum(AI ai){
    if(_state == STATE_MOVE){
      _gaugeHitRange = ai.getRange();
      _gaugeHitPos = (int)random(10 + _gaugeHitRange / 2, MAX_RANGE - _gaugeHitRange / 2);
      _state = STATE_EXCHANGE;
      _frameCount = 0;
      _memoryAI = ai;
      _gaugeRange = 0;
    }
  }
  
  public void assignChar(char s){
    _gaugeStopChar = s;
  }

  private void exchangeState(){
    _frameCount++;
    float drawPosX = 0;
    if(this.position.x >= _memoryAI.position.x){
      drawPosX = (float)this.position.x + ORIGIN_POS_X;
    }
    if(this.position.x <= _memoryAI.position.x){
      drawPosX = (float)this.position.x - ORIGIN_POS_X;
    }
    if(drawPosX <= 0) drawPosX = (float)this.position.x + ORIGIN_POS_X;
    if(drawPosX >= width) drawPosX = (float)this.position.x - ORIGIN_POS_X;
    
    float adjustPosY = 0;
    if(this.position.y + MAX_RANGE / 2 + 20 >= height){
      adjustPosY -= ADJUST_Y;
    }
    if(this.position.y - MAX_RANGE / 2 - 20 <= 0){
      adjustPosY += ADJUST_Y;
    }
    
    strokeWeight(3);
    strokeJoin(BEVEL);
    fill(0, 255, 0, 200);
    rectMode(CENTER);
    rect(drawPosX, (float)this.position.y + adjustPosY, GAUGE_WIDTH, MAX_RANGE);
    fill(255, 0, 0, 200);
    rectMode(CENTER);
    rect(drawPosX, (float)this.position.y + (MAX_RANGE / 2) - _gaugeHitPos + adjustPosY, GAUGE_WIDTH, _gaugeHitRange);_gaugeRange -= _gaugeSpeed;
    stroke(0);
    fill(255, 255, 255, 0);
    rectMode(CORNER);
    rect(drawPosX - (GAUGE_WIDTH / 2), (float) this.position.y + MAX_RANGE / 2 + adjustPosY, GAUGE_WIDTH, _gaugeRange);
    if(_gaugeRange >= 0 || _gaugeRange <= -MAX_RANGE){
      _gaugeSpeed *= -1;
    }
    if(keyPressed && key == _gaugeStopChar){
      if(_frameCount >= FRAME_MAX){
        float memo = (float)this.position.y - MAX_RANGE / 2;
        if((_gaugeRange * -1) + memo <= memo + _gaugeHitPos + _gaugeHitRange / 2 &&
        (_gaugeRange * -1) + memo >= memo + _gaugeHitPos - _gaugeHitRange / 2){
          //success exchanged busines card
          if(_memoryAI._obachan == false){
            _memoryAI.playerHit(this);
          } else {
            _memoryAI.playerHit(_enemy);
          }
          _gaugeRange = 0;
          _gaugeSpeed = GAUGE_SPEED;
        } else {
          if(_memoryAI._obachan == true){
            _memoryAI.playerHit(this);
          }
          _gaugeRange = 0;
          _gaugeSpeed = GAUGE_SPEED;
          //failed
        }
        _memoryAI.changeStateToEscape();
        _state = STATE_MOVE;
      }
    }
  } 
  
  public void initializeArray(){
    _pointArray = new int[CARD_MAX];
    _imageArray = new PImage[CARD_MAX];
    for(int i = 0; i < CARD_MAX; i++){
      _pointArray[i] = 0;
    }
    _cardState = 0;
  }
  
  
  
  private void moveManage() {
    switch(_moveState) {
    case MOVE_STATE_UP:
      _nextPos = this.position.y - SPEED;
      if(_parent._offeceOne.playerHitOffice(this.position.x, _nextPos)){
        _nextPos = this.position.y;
      }
      if(_parent._offeceTwo.playerHitOffice(this.position.x, _nextPos)){
        _nextPos = this.position.y;
      }
      if(_parent._fount.hitPlayerFountain(this.position.x, _nextPos)){
        _nextPos = this.position.y;
      }
      this.position.y = _nextPos;
      changeAnimation(ANIM_BACK);
      _animation = ANIM_BACK;
      break;

    case MOVE_STATE_DOWN:
      _nextPos = this.position.y + SPEED;
      if(_parent._offeceOne.playerHitOffice(this.position.x, _nextPos)){
        _nextPos = this.position.y;
      }
      if(_parent._offeceTwo.playerHitOffice(this.position.x, _nextPos)){
        _nextPos = this.position.y;
      }
      if(_parent._fount.hitPlayerFountain(this.position.x, _nextPos)){
        _nextPos = this.position.y;
      }
      this.position.y = _nextPos;
      changeAnimation(ANIM_FRONT);
      _animation = ANIM_FRONT;
      break;

    case MOVE_STATE_LEFT:
      _nextPos = this.position.x - SPEED;
      if(_parent._offeceOne.playerHitOffice(_nextPos, this.position.y)){
        _nextPos = this.position.x;
      }
      if(_parent._offeceTwo.playerHitOffice(_nextPos, this.position.y)){
        _nextPos = this.position.x;
      }
      if(_parent._fount.hitPlayerFountain(_nextPos, this.position.y)){
        _nextPos = this.position.x;
      }
      this.position.x = _nextPos;
      changeAnimation(ANIM_LEFT);
      _animation = ANIM_LEFT;
      break;

    case MOVE_STATE_RIGHT:
      _nextPos = this.position.x + SPEED;
      if(_parent._offeceOne.playerHitOffice(_nextPos, this.position.y)){
        _nextPos = this.position.x;
      }
      if(_parent._offeceTwo.playerHitOffice(_nextPos, this.position.y)){
        _nextPos = this.position.x;
      }
      if(_parent._fount.hitPlayerFountain(_nextPos, this.position.y)){
        _nextPos = this.position.x;
      }
      this.position.x = _nextPos;
      changeAnimation(ANIM_RIGHT);
      _animation = ANIM_RIGHT;
      break;
    }

    if (this.position.x <= 0) {
      this.position.x = 0;
    } else  if (this.position.x >= width) {
      this.position.x = width;
    }
    if(this.position.y <= 100){
      this.position.y = 100;
    } else if(this.position.y >= height){
      this.position.y = height;
    }
  }



  public void turnOnRight() {
    _moveState = MOVE_STATE_RIGHT;
  }

  public void turnOnLeft() {
    _moveState = MOVE_STATE_LEFT;
  }

  public void turnOnUp() {
    _moveState = MOVE_STATE_UP;
  }

  public void turnOnDown() {
    _moveState = MOVE_STATE_DOWN;
  }
  
  public void turnOnNon(){
    _moveState = MOVE_STATE_NON;
  }
  
  public void drawFrame(float x, float y){
    rectMode(CORNER);
    for(int i = 0; i < CARD_MAX; i++){
      fill(255, 255, 255, 230);
      rect(x + i * FRAME_SIZE, y, FRAME_SIZE, FRAME_SIZE);
      if(_imageArray[i] != null){
        image(_imageArray[i], x + i * FRAME_SIZE + (FRAME_SIZE / 2), y + (FRAME_SIZE / 2), FRAME_SIZE, FRAME_SIZE);
      }
    }
  }
  
  public void assignEnemy(Player enemy){
    _enemy = enemy;
  }
}

