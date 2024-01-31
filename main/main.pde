GameController gc;

// variables
final float     targetMargin = 100;
final int       boundsLength = 20;
      int       TILE_SIZE;
      VectorInt PLAY_AREA_SIZE;

// directions
public final int GRASS = 0;
public final int ROAD  = 1;
public final int CITY  = 2;
public final int EMPTY = 3;
public final String[] TYPE_NAMES = {"Grass", "Road", "City", "Empty"};

public final int NORTH = 0;
public final int EAST  = 1;
public final int SOUTH = 2;
public final int WEST  = 3;
public final String[] DIRECTION_NAMES = {"North", "East", "South", "West"};

// use this maybe???
enum FaceType{
    GRASS   (0, "Grass"),
    ROAD    (1, "Road"),
    CITY    (2, "City"),
    EMPTY   (3, "Empty");

    private final int       index;
    private final String    label;
    FaceType(int index, String label){
        this.index = index;
        this.label = label;
    }

    @Override
    public String toString(){
        return this.label;
    }
}

public final int NULL  = 100;

public final boolean DEBUG_MODE = true;

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

    gc = new GameController();
}

void draw(){
    background(0);

    gc.Update();
    gc.Render();
}


void mousePressed(){
    if(mouseButton == LEFT){
        gc.LeftMousePressed();
    }
    if( mouseButton == RIGHT){
        gc.RightMousePressed();
    }
}

// bound a direction between 0, 1, 2, 3
int BoundDirection(int direction){
    int x = direction;
    if( x < 0 ){
        x += 4;
        x = BoundDirection(x);
    }
    else if( x > 3){
        x -= 4;
        x = BoundDirection(x);
    }
    return x;
}