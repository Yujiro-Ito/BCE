class AI extends BaseCharacter {



  static final int AI_BACK = 0;
  static final int AI_FRONT = 1;
  static final int AI_LEFT = 2;
  static final int AI_RIGHT = 3;
  static final int AI_STOP = 4;

  static final int STATE_MOVE = 0;
  static final int STATE_STOP = 1;
  static final int STATE_ESCAPE = 2;

  static final int HIT_MOVE_SECOND = 30;

  public int _direction;
  public int temporarily_direction;
  public int stop_state;
  public int escape_ai_frame_count;
  public int ai_frame_count;
  public boolean second_state;
  public int ai_speed;
  public int _random;
  private int _gaugeRange;

  final int HIT_RANGE = 60;

  public MyGame _theParent;

  private PImage _face;
  private int _score;

  public boolean _obachan;

  public AI( Game parent, String name, int celluloid, int col, String face, int myScore, int g_range) {
    super( parent, name, celluloid, col);
    changeAnimation(ANIM_FRONT);
    _theParent = (MyGame)parent;
    ai_speed = 1;
    ai_frame_count = 0;
    second_state = false;
    _direction = (int)random(5);
    stop_state = STATE_MOVE;
    _random = (int)random(60);
    _face = loadImage(face);
    _score = myScore;
    _obachan = false;
    _gaugeRange = g_range;
  }

  public void update(double deltaTime) {
    ai_frame_count++;
    state_ai();
    super.update(deltaTime);
  }

  public void _playerOne_hitTest() {
    if (hitTest(_theParent._playerOne, 30)) {
      stop_state = STATE_STOP;
      _theParent._playerOne.desideExchangeStateNum(this);
      if (_theParent._playerOne._animation == ANIM_BACK) {
        this.changeAnimation(ANIM_FRONT);
      } else if (_theParent._playerOne._animation == ANIM_FRONT) {
        this.changeAnimation(ANIM_BACK);
      } else if (_theParent._playerOne._animation == ANIM_LEFT) {
        this.changeAnimation(ANIM_RIGHT);
      } else if (_theParent._playerOne._animation == ANIM_RIGHT) {
        this.changeAnimation(ANIM_LEFT);
      }
    }
  }

  public void _playerTwo_hitTest() {
    if (hitTest(_theParent._playerTwo, 30)) {
      stop_state = STATE_STOP;
      _theParent._playerTwo.desideExchangeStateNum(this);
      if (_theParent._playerTwo._animation == ANIM_BACK) {
        this.changeAnimation(ANIM_FRONT);
      } else if (_theParent._playerTwo._animation == ANIM_FRONT) {
        this.changeAnimation(ANIM_BACK);
      } else if (_theParent._playerTwo._animation == ANIM_LEFT) {
        this.changeAnimation(ANIM_RIGHT);
      } else if (_theParent._playerTwo._animation == ANIM_RIGHT) {
        this.changeAnimation(ANIM_LEFT);
      }
    }
  }


  public void changeStateToEscape() {
    stop_state = STATE_ESCAPE;
  }



  public void move_ai() {

    switch(_direction) {
    case AI_BACK:
      if (this.position.y < 100) {
        this.position.y = 100;
        ai_frame_count = 0;
        _random = (int)random(60);
        _direction = (int)random(5);
      } else {
        this.changeAnimation(ANIM_BACK);
        this.position.y -= ai_speed;
        if (_random <= ai_frame_count) {
          _random = (int)random(60);
          _direction = (int)random(5);
          ai_frame_count = 0;
        }
        if (hitbuild()) {
          changeDirection();
        }
      }
      break;
    case AI_FRONT:
      if (this.position.y > height) {
        this.position.y = height;
        ai_frame_count = 0;
        _random = (int)random(60);
        _direction = (int)random(5);
      } else {
        this.changeAnimation(ANIM_FRONT);
        this.position.y += ai_speed;
        if (_random <= ai_frame_count) {
          _random = (int)random(60);
          _direction = (int)random(5);
          ai_frame_count = 0;
        }
        if (hitbuild()) {
          changeDirection();
        }
      }
      break;
    case AI_LEFT:
      if (this.position.x <= 0) {
        this.position.x = width;
        ai_frame_count = 0;
      } else {
        this.changeAnimation(ANIM_LEFT);
        this.position.x -= ai_speed;
        if (_random <= ai_frame_count) {
          _random = (int)random(60);
          _direction = (int)random(5);
          ai_frame_count = 0;
        }
        if (hitbuild()) {
          changeDirection();
        }
      }
      break;
    case AI_RIGHT:
      if (this.position.x >= width) {
        this.position.x = 0;
        ai_frame_count = 0;
      } else {
        this.changeAnimation(ANIM_RIGHT);
        this.position.x += ai_speed;
        if (_random <= ai_frame_count) {
          _random = (int)random(60);
          _direction = (int)random(5);
          ai_frame_count = 0;
        }
        if (hitbuild()) {
          changeDirection();
        }
      }
      break;
    case AI_STOP:
      if (_random <= ai_frame_count) {
        _random = (int)random(60);
        _direction = (int)random(5);
        ai_frame_count = 0;
      }
      break;
    case 5:
      hitmove();
      break;
    }
  }


  public void state_ai() {
    switch(stop_state) {
    case STATE_MOVE:
      move_ai();
      break;

    case STATE_STOP:
      //stop_state = STATE_ESCAPE;
      break;

    case STATE_ESCAPE:
      escape_ai();
      break;
    }
  }

  public void escape_ai() {
    if (this.position.y <= height / 2) {
      this.changeAnimation(ANIM_BACK);
      this.position.y -= ai_speed * 4;
      if (240 <= escape_ai_frame_count) {
        escape_ai_frame_count = 0;
      }
      if (this.position.y <= 100) {
        this.position.set(random(width), height);
        stop_state = STATE_MOVE;
      }
    } else if (this.position.y >= height / 2) {
      this.changeAnimation(ANIM_FRONT);
      this.position.y += ai_speed * 4;
      if (240 <= escape_ai_frame_count) {
        escape_ai_frame_count = 0;
      }
      if (this.position.y >= height) {
        this.position.set(random(width), 100);
        stop_state = STATE_MOVE;
      }
    }
  }

  public int getRange() {
    return _gaugeRange;
  }

  public void playerHit(Player player) {
    player.assignBusinessCard(_score, _face);
  }

  public void changeDirection() {
    if (_direction == AI_BACK) {
      temporarily_direction = AI_FRONT;
    } else if (_direction == AI_FRONT) {
      temporarily_direction = AI_BACK;
    } else if (_direction == AI_RIGHT) {
      temporarily_direction = AI_LEFT;
    } else if (_direction == AI_LEFT) {
      temporarily_direction = AI_RIGHT;
    }
    _direction = 5;
    ai_frame_count = 0;
  }

  public boolean hitbuild() {
    boolean result = false; 
    if (_theParent._offeceOne.position.x - _theParent._offeceOne.WIDTH_MAX / 2 - 30 < this.position.x && _theParent._offeceOne.position.x + _theParent._offeceOne.WIDTH_MAX / 2 + 30 > this.position.x) {
      if (_theParent._offeceOne.position.y - _theParent._offeceOne.HEIGHT_MAX / 2 - 30 < this.position.y && _theParent._offeceOne.position.y + _theParent._offeceOne.HEIGHT_MAX / 2 + 30 > this.position.y) {
        result = true;
      }
    }
    if (_theParent._offeceTwo.position.x - _theParent._offeceTwo.WIDTH_MAX / 2 - 30 < this.position.x && _theParent._offeceTwo.position.x + _theParent._offeceOne.WIDTH_MAX / 2 + 30 > this.position.x) {
      if (_theParent._offeceTwo.position.y - _theParent._offeceTwo.HEIGHT_MAX / 2 - 30 < this.position.y && _theParent._offeceTwo.position.y + _theParent._offeceOne.HEIGHT_MAX / 2 + 30 > this.position.y) {
        result =true;
      }
    }

    if (hitTest(_theParent._fount, 70)) {
      result =true;
    }
    return result;
  }

  public void hitmove() {
    switch(temporarily_direction) {
    case AI_BACK:
      if (this.position.y < 100) {
        this.position.y = 100;
        ai_frame_count = 0;
        _random = (int)random(60);
        _direction = (int)random(5);
      } else {
        this.changeAnimation(ANIM_BACK);
        this.position.y -= ai_speed;
        if (HIT_MOVE_SECOND <= ai_frame_count) {
          _random = (int)random(60);
          _direction = (int)random(5);
          ai_frame_count = 0;
        }
      }
      break;
    case AI_FRONT:
      if (this.position.y > height) {
        this.position.y = height;
        ai_frame_count = 0;
        _random = (int)random(60);
        _direction = (int)random(5);
      } else {
        this.changeAnimation(ANIM_FRONT);
        this.position.y += ai_speed;
        if (HIT_MOVE_SECOND <= ai_frame_count) {
          _random = (int)random(60);
          _direction = (int)random(5);
          ai_frame_count = 0;
        }
      }
      break;
    case AI_LEFT:
      if (this.position.x <= 0) {
        this.position.x = width;
        ai_frame_count = 0;
      } else {
        this.changeAnimation(ANIM_LEFT);
        this.position.x -= ai_speed;
        if (HIT_MOVE_SECOND <= ai_frame_count) {
          _random = (int)random(60);
          _direction = (int)random(5);
          ai_frame_count = 0;
        }
      }
      break;
    case AI_RIGHT:
      if (this.position.x >= width) {
        this.position.x = 0;
        ai_frame_count = 0;
      } else {
        this.changeAnimation(ANIM_RIGHT);
        this.position.x += ai_speed;
        if (HIT_MOVE_SECOND <= ai_frame_count) {
          _random = (int)random(60);
          _direction = (int)random(5);
          ai_frame_count = 0;
        }
      }
      break;
    case AI_STOP:
      if (_random <= ai_frame_count) {
        _random = (int)random(60);
        _direction = (int)random(5);
        ai_frame_count = 0;
      }
      break;
    }
  }
}

