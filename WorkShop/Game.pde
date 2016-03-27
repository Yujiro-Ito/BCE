class Game {
  // ---- field( Start ) ----
  private boolean _firstTime;
  public PApplet applet;
  private StopWatch _timer;
  public double delta;
  // ---- field( End ) ----
  
  
  // ---- method( Start ) ----
  
  // ---- constructor( Start ) ----
  Game ( PApplet applet) {
    this.applet = applet;
    _firstTime = true;
    _timer = new StopWatch();
  }
  // ---- constructor( End ) ----
  
  // Initialize : override when extends
  protected void initialize () {
    _firstTime = false;
  }
  
  // Game :  Override when extends
  protected void update(){
  }
  
  // Update : Override when extends
  protected void run() {
    if( _firstTime ) {
      initialize();
    } else {
      update();
    }
    delta = _timer.getElapsedTime();
  }
  // ---- method( End ) ----
}
