class Offece extends BaseCharacter {

  static final int FUNDS = 3000;
  static final int WIDTH_MAX = 120;
  static final int HEIGHT_MAX = 180;

  static final int OVER_RANGE = 10;


  public int player_funds;
  public int offece_number;

  public MyGame _theParent;
  private PFont font;

  public Offece( Game parent, String name) {

    super( parent, name, 1, 1 );
    player_funds = FUNDS;
    _theParent = (MyGame)parent;
    font = createFont("Hiragana", 40);
    textFont(font);
  }

  public void update(double deltaTime) {

    if (offece_number == 1) {
      if (this.position.x - WIDTH_MAX / 2 - OVER_RANGE <= _theParent._playerOne.position.x && this.position.x + WIDTH_MAX / 2 + OVER_RANGE >= _theParent._playerOne.position.x) {
        if (this.position.y - HEIGHT_MAX / 2 - OVER_RANGE <= _theParent._playerOne.position.y && this.position.y + HEIGHT_MAX / 2 + OVER_RANGE>= _theParent._playerOne.position.y) {
          int memory = player_funds;
          player_funds += _theParent._playerOne.hitBusiness();
          if(memory != player_funds){
          playMusic_se("MoneyUp.mp3");
          }
        }
      }
    } else {
      if (this.position.x - WIDTH_MAX / 2 - OVER_RANGE <= _theParent._playerTwo.position.x && this.position.x + WIDTH_MAX / 2 + OVER_RANGE >= _theParent._playerTwo.position.x) {
        if (this.position.y - HEIGHT_MAX / 2 - OVER_RANGE <= _theParent._playerTwo.position.y && this.position.y + HEIGHT_MAX / 2 + OVER_RANGE >= _theParent._playerTwo.position.y) {
          int memory = player_funds;
          player_funds += _theParent._playerTwo.hitBusiness();
          if(memory != player_funds){
          playMusic_se("MoneyUp.mp3");
          }
        }
      }
    }

    rectMode(CENTER);
    fill(230, 230, 230, 230);
    rect((float)this.position.x, (float)this.position.y - HEIGHT_MAX / 2 - 50, 100, 30);
    fill(0);
    textSize(20);
    textAlign(CENTER);
    text(player_funds + " " + "万円", (float)this.position.x, (float)this.position.y - HEIGHT_MAX / 2 - 40);
    super.update(deltaTime);
  }

  public void offece_number(int num) {
    offece_number = num;
  }

  public void add_funds(int add) {
    player_funds += add;
  }

  public boolean playerHitOffice(double posX, double posY) {
    boolean result = false;
    if (this.position.x - WIDTH_MAX / 2 <= posX && this.position.x + WIDTH_MAX / 2 >= posX) {
      if (this.position.y - HEIGHT_MAX / 2 <= posY && this.position.y + HEIGHT_MAX / 2 - 20 >= posY) {
        result = true;
      }
    }
    return result;
  }
}

