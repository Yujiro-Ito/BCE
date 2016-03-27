class MyGame extends Game {

  //-----screen state num--------
  static final int SCREEN_TITLE = 0;
  static final int SCREEN_GAME = 1;
  static final int SCREEN_RESULT = 2;
  private int _screenState;

  static final int HIGHSALARYMAN_MAX = 1;
  static final int LOWSALARYMAN_MAX = 2;
  static final int OBACHAN_MAX = 2;
  static final int PRESIDENT_MAX = 1;

  //-----transition number-------
  private boolean _transitionFinish;
  private int _currentAlpha;
  static final boolean BLACK_SCREEN = true;
  static final boolean WHITE_SCREEN = false;
  static final int MAX_ALPHA = 255;
  static final int MIN_ALPHA = 0;
  static final int PLUS_ALPHA = 3;
  private boolean _gameTransition;
  static final int TIME_MAX = 10;
  private boolean _push;

  //-------game number------
  public AI[] _managePres;
  public int character_max;
  public int _time;
  public int frame_count;
  private boolean _transitionPlease;
  private boolean _whiteTransition;
  private boolean _initGameCheck;
  
  public Player _playerOne;
  public Player _playerTwo;

  public Offece _offeceOne;
  public Offece _offeceTwo;
  
  private PImage _back;
  private int _currentTime;
  private int _secondCount;
  private float _changeMomentTime;
  final int FIRST_TIME = 9;
  final int TIME_COUNT = 8;
  
  //----------------------
  
  //-----image-------
  private PImage _exchange_card;
  private PImage _titleOne;
  private PImage _titleTwo;
  private PImage _result;

  public Fountain _fount;

  public MyGame(PApplet appleat) {
    super(appleat);
  }

  void initialize() {
    _screenState = SCREEN_TITLE;
    _transitionPlease = false;
    _whiteTransition = false;
    initializeGame();
    _initGameCheck = false;
    playMusic_bgm("title.mp3");
    _bgm.loop();
    _transitionFinish = true;
    _push = false;
    super.initialize();
    strokeWeight(3);
    strokeJoin(BEVEL);
    _exchange_card = loadImage("exchange.png");
    _titleOne = loadImage("TitleText.png");
    _titleTwo = loadImage("TitleText2.png");
    _result = loadImage("exchangeWhite.png");
  }



  void update() {
    switch(_screenState) {
    case SCREEN_TITLE:
      if (_initGameCheck == false) {
        initializeGame();
        _initGameCheck = true;
      }
      playTitle();
      break;
    case SCREEN_GAME:
      playGame();
      break;
    case SCREEN_RESULT:
      playResult();
      _initGameCheck = false;
      break;
    }
  }

  private void playTitle() {
    background(255);
    fill(0);
    imageMode(CORNER);
    image(_exchange_card, 0, 0, width, height);
    image(_titleOne, 0, 100, width, 200);
    image(_titleTwo, 0, height / 2 + 100, width, 200);
    if(_push == true){
      if (keyPressed && key == ENTER) {
        _screenState = SCREEN_GAME;
        playMusic_bgm("game_bgm.mp3");
        
      }
      _push = false;
    }
    
  }

  private void spawnCharacters() {
    character_max = HIGHSALARYMAN_MAX + LOWSALARYMAN_MAX + OBACHAN_MAX + PRESIDENT_MAX;
    _managePres = new AI[character_max];
    int number = 0;
    for (int i = 0; i < HIGHSALARYMAN_MAX; i++) {
      _managePres[number] = new HighSalaryman(this);
      number++;
    }
    for (int i = 0; i < LOWSALARYMAN_MAX; i++) {
      _managePres[number] = new LowSalaryman(this);
      number++;
    }
    for (int i = 0; i < OBACHAN_MAX; i++) {
      _managePres[number] = new Obachan(this);
      number++;
    }
    for (int i = 0; i < PRESIDENT_MAX; i++) {
      _managePres[number] = new President(this);
      number++;
    }

    for (int i = (_managePres.length - 1); i > 0; --i) {
      int j = (int)random(i + 1);
      AI tmp = _managePres[i];
      _managePres[i] = _managePres[j];
      _managePres[j] = tmp;
    }

    number = 0;
    float intervalPosX = (float)(width / ((character_max / 2) + 1));
    for (int i = 0; i < character_max / 2; i++) {
      for (int j = 0; j < 2; j++) {
        _managePres[number].position.set(intervalPosX + intervalPosX * i, 100 + 300 * j);
        number++;
      }
    }
  }

  private void initializeGame() {
    _time = TIME_MAX;
    frame_count = 0;
    _currentTime = FIRST_TIME;
    _changeMomentTime = (float)TIME_MAX / TIME_COUNT;


    spawnCharacters();
    _offeceOne = new Offece(this, "Company1.png");
    _offeceTwo = new Offece(this, "Company2.png");
    _offeceOne.offece_number(1);
    _offeceTwo.offece_number(2);
    _offeceOne.position.set(50, height / 2);
    _offeceTwo.position.set(590, height / 2);
    _fount = new Fountain(this);
    _fount.position.set(width / 2, height / 2);
    _whiteTransition = false;
    _back = loadImage("Background.png");
    
    _playerOne = new Player(this, "worker.png");
    _playerTwo = new Player(this, "worker4.png");
    _playerOne.position.set(50, height / 2 + _offeceOne.HEIGHT_MAX / 2);
    _playerTwo.position.set(width - 50, height / 2 + _offeceTwo.HEIGHT_MAX / 2);
    
  }

  private void playGame() {
    background(255);
    image(_back, width / 2, height / 2, width, height);
    textSize(20);
    fill(255, 255, 255, 230);
    rectMode(CENTER);
    rect(width / 2, 45, 110, 40);
    fill(0);
    text("只今  " + _currentTime + ":00", width / 2, 50);
    frame_count++;
    if (frame_count >= 60) {
      frame_count = 0;
      _secondCount++;
    }
    if(_secondCount >= _changeMomentTime){
      _secondCount = 0;
      _currentTime++;
    }
    if (_currentTime > FIRST_TIME + TIME_COUNT) {
      _screenState = SCREEN_RESULT;
      _bgm.close();
      playMusic_se("result.mp3");
    }

    for (int i = 0; i < _managePres.length; i++) {
      if (_managePres[i] != null) {
        _managePres[i].update(delta);
      }
    }
    _offeceOne.update(delta);
    _offeceTwo.update(delta);
    _fount.update(delta);
    _playerOne.assignEnemy(_playerTwo);
    _playerTwo.assignEnemy(_playerOne);
    _playerOne.drawFrame(20, 30);
    _playerTwo.drawFrame(width - 20 - (40 * 3), 30);
    _playerOne.update(delta);
    _playerTwo.update(delta);
  }

  private void playResult() {
    background(0);
    fill(255);
    imageMode(CORNER);
    image(_result, 100, 200, width - 200, height - 200);
    textAlign(CENTER);
    textSize(40);
    text(_offeceOne.player_funds + "万円", width / 4, height / 3 - 30);
    text(_offeceTwo.player_funds + "万円", width / 4 * 3, height / 3 - 30);
    if (_offeceOne.player_funds < _offeceTwo.player_funds) {
      text("プレイヤー2の勝利", width / 2, height / 2 - 50);
    } else if (_offeceOne.player_funds == _offeceTwo.player_funds) {
      text("同点", width / 2, height / 2 - 50);
    } else {
      text("プレイヤー1の勝利", width / 2, height / 2 - 50);
    }
    if(_push = true){
      if (key == ENTER&& keyPressed) {
        _transitionPlease = true;
        _screenState = SCREEN_TITLE;
        playMusic_se("InputKey.mp3");
      }
      _push = false;
    }

  }

}

