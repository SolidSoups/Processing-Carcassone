GameController gc_ref;

// variables
final float     targetMargin = 100;
final int       boundsLength = 20;
      int       TILE_SIZE;
      VectorInt PLAY_AREA_SIZE;

public final int NULL  = 100;

void setup(){
    size(1500, 1000);
    println("---Program start.");

    TILE_SIZE = int((width - targetMargin*2) / boundsLength);
    PLAY_AREA_SIZE = new VectorInt(
        boundsLength,
        int((height - targetMargin*2) / TILE_SIZE)
    );
    println("TILE_SIZE: \t\t" + TILE_SIZE);
    println("PLAY_AREA_SIZE: \t" + PLAY_AREA_SIZE);

    gc_ref = new GameController();
}

void draw(){
    background(0);

    gc_ref.Update();
    gc_ref.Render();
}


void mousePressed(){
    if(mouseButton == LEFT){
        gc_ref.LeftMousePressed();
    }
    if( mouseButton == RIGHT){
        gc_ref.RightMousePressed();
    }
}

void keyPressed(){
    if(key == 'r'){
        gc_ref.ResetGame();
    }
}

// bound a direction between 0, 1, 2, 3
int BoundOrientation(int direction){
    int x = direction;
    if( x < 0 ){
        x += 4;
        x = BoundOrientation(x);
    }
    else if( x > 3){
        x -= 4;
        x = BoundOrientation(x);
    }
    return x;
}