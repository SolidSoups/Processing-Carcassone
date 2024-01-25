
// types
public final int GRASS      = 0; // default int value is 0
public final int ROAD       = 1;
public final int CITY       = 2;
// string for types
public final String[] typeNames = {
    "grass", 
    "road",
    "city",
};

// directions
public final int NORTH = 0;
public final int EAST  = 1;
public final int SOUTH = 2;
public final int WEST  = 3;
// strings for directions
public final String[] directionNames = {
    "north",
    "east",
    "south",
    "west"
};

// Error code
public final int ERROR = 100;



// sprites
PImage[] tileSprites;
int tileSpritesSize = 24;

int spriteIndex = 0;
int currentDirection = NORTH;

// tile objects
ArrayList<Tile> tiles;

// colors
color spriteColor   = color(255,0,0);
color portTypeColor = color(0, 0, 255);
color portDirColor  = color(0, 255, 0);
color selDirColor   = color(200, 200, 200);


void setup(){
    size(600, 600);

    // init tile array
    tiles = new ArrayList<Tile>();

    // load sprites
    tileSprites = new PImage[tileSpritesSize];
    for(int i = 0; i < tileSpritesSize; i++){
        String s = str(i);
        while( s.length() < 2)
            s = "0" + s;
        tileSprites[i] = loadImage("resources/sprites/sprite_" + s + ".png");

        // init tile object for i
        tiles.add(new Tile(i));
    }
}




void draw(){
    background(0);

    // draw current sprite index
    fill(spriteColor);
    
    textSize(50);
    textAlign(TOP, TOP);
    text("ID: " + str(spriteIndex), 30, 10);

    // draw current sprite
    image(tileSprites[spriteIndex], 100, 100, 400, 400);

    // draw all connections on current sprite
    pushStyle();
    textSize(30);
    textAlign(CENTER, TOP);

    PVector[] positions = {
        new PVector(300, 50),
        new PVector(500, 250),
        new PVector(300, 350),
        new PVector(100, 250)
    }; 
    int[] portTypes = tiles.get(spriteIndex).getPortTypes();
    
    for(int i=0; i<4; i++){
        if(i == currentDirection){
            pushMatrix();
            translate(width/2, height/2);
            fill(selDirColor);
            rotate(currentDirection * HALF_PI);
            rectMode(CENTER);
            rect(0, -260, 100, 50);
            popMatrix();
        }

        String directionName = typeNames[portTypes[i]];
        fill(255);
        text(directionName, positions[i].x + 1, positions[i].y + 0.7f);
        fill(portTypeColor);
        text(directionName, positions[i].x, positions[i].y);

        boolean[] connections = tiles.get(spriteIndex).getPortConnections(i);
        String s = "";
        for(int n=0; n<4; n++){
            if( connections[n] )
                s += directionNames[n] + "\n";
        }
        fill(0);
        text(s, positions[i].x + 1, positions[i].y + 30.7f);
        fill(portDirColor);
        text(s, positions[i].x, positions[i].y + 30f);
    }
}




void keyPressed(){
    // switch sprite
    if(key == 'e'){
        spriteIndex++;
        if( spriteIndex >= tileSpritesSize )
            spriteIndex = 0;
    }
    if(key == 'q'){
        spriteIndex--;
        if( spriteIndex < 0)
            spriteIndex = tileSpritesSize - 1;
    }

    // switch current port directions
    if(key == 'w'){
        tiles.get(spriteIndex).flipPortConnection(currentDirection, NORTH);
    }
    if(key == 'd'){
        tiles.get(spriteIndex).flipPortConnection(currentDirection, EAST);
    }
    if(key == 's'){
        tiles.get(spriteIndex).flipPortConnection(currentDirection, SOUTH);
    }
    if(key == 'a'){
        tiles.get(spriteIndex).flipPortConnection(currentDirection, WEST);
    }


    // switch port
    if(keyCode == RIGHT){
        currentDirection++;
        if( currentDirection >= 4 )
            currentDirection = 0;
    }
    if(keyCode == LEFT){
        currentDirection--;
        if( currentDirection < 0)
            currentDirection = 3;
    }

    // cycle the port type
    if(keyCode == UP){
        int i = tiles.get(spriteIndex).getPortType(currentDirection);
        i++;
        if( i >= 3 )
            i = 0;
        tiles.get(spriteIndex).setPortType(currentDirection, i);
    }
}
