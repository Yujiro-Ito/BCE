import sprites.utils.*;
import sprites.maths.*;
import sprites.*;

class BaseCharacter {
  // ---- field( Start ) ----
  protected Game _parent;      // 
  private Sprite _sprite;    // Character image
  public Vector2D position;  // Character position
  private int _cols;
  public int state;          // Current state
  protected boolean _dead; 
  // ---- field( End ) ----
  
  
  static final int ANIM_FRONT = 0;
  static final int ANIM_LEFT = 1;
  static final int ANIM_RIGHT = 2;
  static final int ANIM_BACK = 3;
  
  // ---- method( Start ) ----
  // ---- constructor( Start ) ----
  BaseCharacter ( Game parent, String spriteName, int cols, int rows ) {
    // Initialize each parameter 
    _parent = parent;
    position = new Vector2D( 0, 0 );
    _sprite = new Sprite( _parent.applet, spriteName, cols, rows, 0 );
    _cols = cols;
    state = 0;
    _dead=false;
  }
  // ---- constructor( End ) ----
  
  /* Collision detection method
     true : Hit   false : Not hit */
  public boolean hitTest ( BaseCharacter target, double distance ) {
    // distance method : Calculate the distance between two points
    if( position.distance( target.position ) < distance &&!target.isDead()){
      return true;    // Hit
    }
    return false;     // Not hit
  }
  
  // Update : Override when extends
  public void update ( double deltaTime ){
    if(!_dead){
      _sprite.setPos( position );
      _sprite.update( deltaTime );
      _sprite.draw();
    }
  }
  
  
  // Change animation
  public void changeAnimation( int pattern ) {
    if( pattern < _cols && pattern >= 0) {
      _sprite.setFrameSequence( _cols * pattern, _cols * pattern + _cols - 1, 0.1 );
    } else {
      _sprite.setFrameSequence( _cols * pattern, _cols * pattern + _cols - 1, 0.1 );
    }
  }
  
  public void dead(){
    _dead=true;  
  }
  
  public void alive(){
    _dead=false;  
  }
  
  public boolean isDead(){
    return _dead;  
  }
  
  // ---- method( End ) ----
}
