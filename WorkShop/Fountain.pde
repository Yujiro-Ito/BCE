class Fountain extends BaseCharacter{
  private MyGame _parent;
  final String MY_UP = "自分の資産が増えました";
  final String MY_DOWN = "自分の資産が減りました";
  final String ENEMY_DOWN = "敵の資産が減りました";
  final int MONEY = 1000;
  private String _appearText;
  static final int WIDTH_MAX = 140;
  static final int HEIGHT_MAX = 110;
  
  //------gambling------
  private int _randomNumber;
  final int MONEY_UP = 0;
  final int MONEY_DOWN = 1;
  final int ENEMY_MONEY_DOWN = 2;
  private boolean _oneHit, _twoHit;
  private boolean _onePressed, _twoPressed;
  
  final int HIT_RANGE = 80;
  
  //------text number-------
  private float _currentAlpha;
  final float MINAS_ALPHA = 3;
  final float MAX_ALPHA = 255;
  
  final int ANIMATION = 0;
  
  
  
  public Fountain(Game parent){
    super(parent, "fountain.png", 3, 4);
    _parent = (MyGame)parent;
    _oneHit = false;
    _twoHit = false;
    _onePressed = false;
    _twoPressed = false;
    initTextNum();
    changeAnimation(ANIMATION);
    _appearText = "";
  }
  
  public void update(double deltaTime){
    playerHitTest();
    textAppear();
    if(_oneHit && _onePressed){
      boolean yes = true;
      for(int i = 0; i < _parent._playerOne.CARD_MAX; i++){
        if(_parent._playerOne._pointArray[i] >= 500){
          //-----success----
          gambling(_parent._offeceOne, _parent._offeceTwo, _parent._playerOne);
        }
        if(yes == true && _parent._playerOne._pointArray[i] <= 0 || _parent._playerOne._pointArray[i] >= 500){
          yes = false;
        }
      }
      if(yes == true){
        gambling(_parent._offeceOne, _parent._offeceTwo, _parent._playerOne);
      }
      
    }
    
    
    if(_twoHit && _twoPressed){
      boolean yes = true;
      for(int i = 0; i < _parent._playerTwo.CARD_MAX; i++){
        if(_parent._playerTwo._pointArray[i] >= 500){
          //-----success----
          gambling(_parent._offeceTwo, _parent._offeceOne, _parent._playerTwo);
        }
        if(yes == true && _parent._playerTwo._pointArray[i] <= 0 || _parent._playerTwo._pointArray[i] >= 500){
          yes = false;
        }
      }
      if(yes == true){
        gambling(_parent._offeceTwo, _parent._offeceOne, _parent._playerTwo);
      }
    }
        
    super.update(deltaTime);
  }
  
  public void textAppear(){
    _currentAlpha -= MINAS_ALPHA;
    if(_currentAlpha <= 0){
      _currentAlpha = 0;
    }
    fill(0, 0, 0, _currentAlpha);
    textAlign(CENTER);
    textSize(20);
    text(_appearText, (float)this.position.x, (float)this.position.y - 70);
  }
    
    
  
  public void initTextNum(){
    _currentAlpha = MAX_ALPHA;
  }
  
  public void gambling(Offece me, Offece enemy, Player player){
    _randomNumber = (int)random(3);
    switch(_randomNumber){
      case MONEY_UP:
        me.add_funds(MONEY);
        _appearText = MY_UP;
        break;
      case MONEY_DOWN:
        me.add_funds(-MONEY);
        _appearText = MY_DOWN;
        break;
      case ENEMY_MONEY_DOWN:
        enemy.add_funds(-MONEY);
        _appearText = ENEMY_DOWN;
        break;
    }
    initTextNum();
    player.initializeArray();
  }
    
        
        
    
    
  
  public void playerHitTest(){
    if(hitTest(_parent._playerOne, HIT_RANGE)){
      _oneHit = true;
    } else {
      _oneHit = false;
    }
    if(hitTest(_parent._playerTwo, HIT_RANGE)){
      _twoHit = true;
    } else {
      _twoHit = false;
    }
  }
  
  public void turnOnePressed(){
    _onePressed = true;
  }
  
  public void turnOneReleased(){
    _onePressed = false;
  }
  
  public void turnTwoPressed(){
    _twoPressed = true;
  }
  
  public void turnTwoReleased(){
    _twoPressed = false;
  }
  
  public boolean hitPlayerFountain(double posX, double posY){
    boolean result = false;
    if (this.position.x - WIDTH_MAX / 2 <= posX && this.position.x + WIDTH_MAX / 2 >= posX) {
      if (this.position.y - HEIGHT_MAX / 2 <= posY && this.position.y + HEIGHT_MAX / 2 + 15 >= posY) {
        result = true;
      }
    }
    return result;
  }
}
