/*
    Author: SolidSoups
    Date: 1/25/2024
 */


// FINALS
public final int GRASS      = 0; // default int value is 0
public final int ROAD       = 1;
public final int CITY       = 2;
public final String[] typeNames = {
    "grass", 
    "road",
    "city",
};

public final int NORTH = 0;
public final int EAST  = 1;
public final int SOUTH = 2;
public final int WEST  = 3;
public final String[] directionNames = {
    "north ^",
    "east >",
    "south V",
    "west <"
};

// SPRITES
PImage[] tileSprites;
int tileSpritesSize = 24;

// TILE OBJECTS
ArrayList<Tile> tiles;

// COUNTERS
int spriteIndex = 0;
int currentDirection = NORTH;

// COLORS
color spriteIndexColorUnlocked   = color(0,255,0);
color spriteIndexColorLocked   = color(255,0,0);
color portTypeColor = color(0, 0, 255);
color portDirColor  = color(120, 255, 120);
color selDirColor   = color(200, 200, 200);

// POSITIONS TO DISPLAY PORT INFORMATION
PVector[] positions = {
    new PVector(300, 50),
    new PVector(500, 250),
    new PVector(300, 350),
    new PVector(100, 250)
}; 





// SETUP--
void setup(){
    size(600, 600);

    // Initialize arrays
    tiles = new ArrayList<Tile>();
    tileSprites = new PImage[tileSpritesSize];

    // create array of our loaded tiles
    ArrayList<Tile> loadedTiles = new ArrayList<Tile>();
    loadedTiles = loadTilesFromJSON();

    // here we create a list of the loaded tiles id's, so we know which sprites have been saved
    IntList loadedIDs = new IntList();
    for(Tile t : loadedTiles)
        loadedIDs.append(t.getID());
    loadedIDs.sort();

    // loop through count of tile sprites, load sprites into PImage array, add a loaded tile if the id exists in 'loadedIDs', otherwise load a generic tile
    for(int i = 0; i < tileSpritesSize; i++){
        // format index as "01" or "10", load image into sprite array
        String s = str(i);
        while( s.length() < 2)
            s = "0" + s;
        tileSprites[i] = loadImage("resources/sprites/sprite_" + s + ".png");

        // load tiles if we have saved them and reset the loop if so
        if( loadedIDs.size() >= 1 )
            if( i == loadedIDs.get(0) ){
                loadedIDs.remove(0);
                spriteIndex = i;
                tiles.add(loadedTiles.get(i));
                continue;
            }
        
        // add a generic tile since we have not loaded it
        tiles.add(new Tile(i));
    }
}






// DRAW--
void draw(){
    background(0);

    // change ID Text color depending on lock state
    if( !tiles.get(spriteIndex).getLock() )
        fill(spriteIndexColorUnlocked);
    else
        fill(spriteIndexColorLocked);
    
    // display ID Text in upper left corner
    textSize(50);
    textAlign(TOP, TOP);
    text("ID: " + str(spriteIndex), 30, 10);

    // display tile count
    fill(255);
    text("C: " + tiles.get(spriteIndex).getCount(), width-100, 10);

    // display current sprite in the middle
    image(tileSprites[spriteIndex], 100, 100, 400, 400);

    // set some styles
    textSize(30);
    textAlign(CENTER, TOP);

    // get all port types
    int[] portTypes = tiles.get(spriteIndex).getPortTypes();
    // loop through all four ports from North to West clockwise
    for(int i=0; i<4; i++){
        // if we are editing the current port, display a rect as a marker
        if(i == currentDirection){
            pushMatrix();
            translate(width/2, height/2);
            fill(selDirColor);
            rotate(currentDirection * HALF_PI);
            rectMode(CENTER);
            rect(0, -260, 100, 50);
            popMatrix();
        }

        // display the port at that direction
        String currentPortTypeName = typeNames[portTypes[i]];
        fill(255);
        text(currentPortTypeName, positions[i].x + 1, positions[i].y + 0.7f);
        fill(portTypeColor);
        text(currentPortTypeName, positions[i].x, positions[i].y);

        // loop through all connections for current port, create a list of their string representations
        boolean[] connections = tiles.get(spriteIndex).getPortConnections(i);
        String s = "";
        for(int n=0; n<4; n++){
            if( connections[n] )
                s += directionNames[n] + "\n";
        }

        // display list of connections for current port under the portType, with a slight stroke
        fill(0);
        text(s, positions[i].x + 1, positions[i].y + 30.7f);
        fill(portDirColor);
        text(s, positions[i].x, positions[i].y + 30f);
    }
}





// KEY PRESS EVENTS
void keyPressed(){
    // Next tile 
    if(key == 'e'){
        spriteIndex++;
        if( spriteIndex >= tileSpritesSize )
            spriteIndex = 0;
    }
    // Previous tile
    if(key == 'q'){
        spriteIndex--;
        if( spriteIndex < 0)
            spriteIndex = tileSpritesSize - 1;
    }

    // Lock editing for current tile
    if(keyCode == DOWN){
        tiles.get(spriteIndex).flipLock();
    }

    // Save all locked tiles
    if(key == 'b'){
        saveTilesAsJSON();
    }

    // enable north connection
    if(key == 'w'){
        tiles.get(spriteIndex).flipPortConnection(currentDirection, NORTH);
    }
    // enable east connection
    if(key == 'd'){
        tiles.get(spriteIndex).flipPortConnection(currentDirection, EAST);
    }
    // enable south connection
    if(key == 's'){
        tiles.get(spriteIndex).flipPortConnection(currentDirection, SOUTH);
    }
    // enable west connection
    if(key == 'a'){
        tiles.get(spriteIndex).flipPortConnection(currentDirection, WEST);
    }

    // increase count
    if(key == 'c'){
        Tile t = tiles.get(spriteIndex);
        int count = t.getCount();
        count++;
        t.setCount(count);
    }

    // decrease count
    if(key == 'x'){
        Tile t = tiles.get(spriteIndex);
        int count = t.getCount();
        count--;
        t.setCount(count);
    }


    // cycle current port clockswise
    if(keyCode == RIGHT){
        currentDirection++;
        if( currentDirection >= 4 )
            currentDirection = 0;
    }
    // cycle current port counter-clockwise
    if(keyCode == LEFT){
        currentDirection--;
        if( currentDirection < 0)
            currentDirection = 3;
    }

    // cycle portTypes
    if(keyCode == UP){
        int i = tiles.get(spriteIndex).getPortType(currentDirection);
        i++;
        if( i >= 3 )
            i = 0;
        tiles.get(spriteIndex).setPortType(currentDirection, i);
    }
}






// Save all locked Tile objects as a JSON file
void saveTilesAsJSON(){
    println("\nSaving locked tiles as JSON file!");
    JSONArray tilePieces = new JSONArray();
    
    for(Tile t : tiles){
        // return if Tile object t is not locked
        if( !t.getLock() ) continue;

        println("---Looping through tile ID: " + t.getID());

        // Create a Tile JSONObject
        JSONObject tile    = new JSONObject();

        // Set the ID
        tile.setInt("id", t.getID());
        println("Set tile ID...");

        // Set count
        tile.setInt("count", t.getCount());

        // set portTypes as an array such as ex. {GRASS, ROAD, CITY, ROAD}
        JSONArray  portTypes = new JSONArray();
        for(int i=0; i<4; i++){ 
            portTypes.append(t.getPortType(i));
        }
        tile.setJSONArray("portTypes", portTypes);
        println("Set tile portTypes...");

        // set a portConnections as a 2D boolean array, x being the origin port and y being if it connects to that port
        JSONArray portsConnectionsX = new JSONArray();
        for(int x=0; x<4; x++){
            boolean[] portConnections = t.getPortConnections(x);
            JSONArray portsConnectionsY = new JSONArray();
            for(int y = 0; y<4; y++){
                portsConnectionsY.append(portConnections[y]);
            }
            portsConnectionsX.append(portsConnectionsY);
        }
        tile.setJSONArray("portConnections", portsConnectionsX);
        println("Set tile portConnections...");

        // append tile to json tile array
        tilePieces.append(tile);
    }

    // Save array
    saveJSONArray(tilePieces, "data/tileConnections.json");
    println("Data saved");
}






// Load all saved Tile objects and return an ArrayList<Tile> object
ArrayList<Tile> loadTilesFromJSON(){
    JSONArray tilePieces = loadJSONArray("data/tileConnections.json");
    ArrayList<Tile> loadedTiles = new ArrayList<Tile>();

    // loop through available loaded Tile objects
    for (int i=0; i < tilePieces.size(); i++){
        // variables for each tile object
        int tileID;
        int tileCount = 0;
        int[] portTypes = new int[4];
        boolean[][] portConnections = new boolean[4][4];
        
        // load tile object at index
        JSONObject tile = tilePieces.getJSONObject(i);

        // retrieve tile id
        tileID = tile.getInt("id");

        // retrieve count
        tileCount = tile.getInt("count");

        // retrieve tile portTypes
        JSONArray portTypesArray   = tile.getJSONArray("portTypes");
        portTypes = portTypesArray.toIntArray();

        // retrieve boolean portsConnections
        JSONArray portsConnectionsX = tile.getJSONArray("portConnections");
        for(int x=0; x<4; x++){
            JSONArray portsConnectionsY = portsConnectionsX.getJSONArray(x);
            for(int y=0; y<4; y++){
                portConnections[x][y] = portsConnectionsY.getBoolean(y);
            }
        }

        // add a tile with this information
        Tile newTile = new Tile(tileID, tileCount, portTypes, portConnections);
        loadedTiles.add(newTile);
    }
    
    println("\nLoaded " + loadedTiles.size() + " tiles from JSON file!");
    return loadedTiles;
}