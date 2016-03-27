import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

MyGame _game;

final char ONE_LEFT = 'a';
final char ONE_RIGHT = 'd';
final char ONE_UP = 'w';
final char ONE_DOWN = 's';
final int ONE_UP_NUM = 0;
final int ONE_DOWN_NUM = 1;
final int ONE_LEFT_NUM = 2;
final int ONE_RIGHT_NUM = 3;
final char ONE_ACTION = 'e';
private boolean _oneLeft, _oneRight, _oneUp, _oneDown;
private int _oneState;
private boolean _oneShot;

final char TWO_LEFT = 'j';
final char TWO_RIGHT = 'l';
final char TWO_UP = 'i';
final char TWO_DOWN = 'k';
final int TWO_UP_NUM = 0;
final int TWO_DOWN_NUM = 1;
final int TWO_LEFT_NUM = 2;
final int TWO_RIGHT_NUM = 3;
final char TWO_ACTION = 'u';
private boolean _twoLeft, _twoRight, _twoUp, _twoDown;
private int _twoState;
private boolean _twoShot;
public boolean _once;

public Minim _minim;
public AudioPlayer _bgm;
public AudioPlayer _se;

static final int STATE_EXCHANGE = 1;

void setup(){
  size(640, 480);
  _game = new MyGame(this);
  _oneLeft = false; _oneRight = false;
  _oneUp = false; _oneDown = false;
  
  _twoLeft = false; _twoRight = false;
  _twoUp = false; _twoDown = false;
  _oneShot = false; _twoShot = false;
  _minim = new Minim(this);
  _once = false;
}

void playMusic_bgm(String name){
  //_minim.stop();
  if(_bgm != null) _bgm.close();
  _bgm = _minim.loadFile(name);
  _bgm.loop();
}

void playMusic_se(String name){
  //_minim.stop();
  if(_se != null) _se.close();
  _se = _minim.loadFile(name);
  _se.play();
}



void draw(){
  _game.run();
  switch(_oneState){
    case ONE_UP_NUM:
      _game._playerOne.turnOnUp();
      break;
    case ONE_DOWN_NUM:
      _game._playerOne.turnOnDown();
      break;
    case ONE_RIGHT_NUM:
      _game._playerOne.turnOnRight();
      break;
    case ONE_LEFT_NUM:
      _game._playerOne.turnOnLeft();
      break;
  }
  if(_oneUp == false && _oneDown == false && _oneRight == false && _oneLeft == false){
    _game._playerOne.turnOnNon();
  }
  
  switch(_twoState){
    case TWO_UP_NUM:
      _game._playerTwo.turnOnUp();
      break;
    case TWO_DOWN_NUM:
      _game._playerTwo.turnOnDown();
      break;
    case TWO_RIGHT_NUM:
      _game._playerTwo.turnOnRight();
      break;
    case TWO_LEFT_NUM:
      _game._playerTwo.turnOnLeft();
      break;
  }
  if(_twoUp == false && _twoDown == false && _twoRight == false && _twoLeft == false){
    _game._playerTwo.turnOnNon();
  }
}

void keyPressed() {
  switch(key) {
  case ONE_UP:
    _oneState = ONE_UP_NUM;
    _oneUp = true;
    break;
  case ONE_DOWN:
    _oneState = ONE_DOWN_NUM;
    _oneDown = true;
    break;
  case ONE_RIGHT:
    _oneState = ONE_RIGHT_NUM;
    _oneRight = true;
    break;
  case ONE_LEFT:
    _oneState = ONE_LEFT_NUM;
    _oneLeft = true;
    break;
  case TWO_UP:
    _twoState = TWO_UP_NUM;
    _twoUp = true;
    break;
  case TWO_DOWN:
    _twoState = TWO_DOWN_NUM;
    _twoDown = true;
    break;
  case TWO_RIGHT:
    _twoState = TWO_RIGHT_NUM;
    _twoRight = true;
    break;
  case TWO_LEFT:
    _twoState = TWO_LEFT_NUM;
    _twoLeft = true;
    break;
  case ONE_ACTION:
    for(int i = 0; i < _game._managePres.length; i++){
      _game._managePres[i]._playerOne_hitTest();
    }
    if(_oneShot == false){
      _game._playerOne.assignChar(ONE_ACTION);
      _game._fount.turnOnePressed();
    }
    _oneShot = true;
    break;
  case TWO_ACTION:
    for(int i = 0; i < _game._managePres.length; i++){
      _game._managePres[i]._playerTwo_hitTest();
    }
    if(_twoShot == false){
      _game._playerTwo.assignChar(TWO_ACTION);
      _game._fount.turnTwoPressed();
    }
    _twoShot = true;
    break;
    
  case ENTER:
    if(_once == false){
      _once = true;
      _game._push = true;
    }
    break;
  }
}

void keyReleased(){
  switch(key) {
  case ONE_UP:
    _oneUp = false;
    break;
  case ONE_DOWN:
    _oneDown = false;
    break;
  case ONE_RIGHT:
    _oneRight = false;
    break;
  case ONE_LEFT:
    _oneLeft = false;
    break;
  case TWO_UP:
    _twoUp = false;
    break;
  case TWO_DOWN:
    _twoDown = false;
    break;
  case TWO_RIGHT:
    _twoRight = false;
    break;
  case TWO_LEFT:
    _twoLeft = false;
    break;
  case ONE_ACTION:
    _oneShot = false;
    _game._fount.turnOneReleased();
    break;
  case TWO_ACTION:
    _twoShot = false;
    _game._fount.turnTwoReleased();
    break;
    
  case ENTER:
    if(_once){
      _once = false;
      _game._push = false;
    }
    break;
  }
}


