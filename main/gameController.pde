import java.security.*;

class GameController{
    Tile[][] placedTilesArray;
    TileData[] tileDataList;

    // handlers
    GraphicsHandler graphicsHandler;
    UIHandler uiHandler;

    // sprites
    PImage[] sprites;
    int spriteSize = 24;

    // input
    private boolean isPreviewingPlacement = false;
    private boolean hasConfirmedPlacement = false;
    private Tile previewTile;

    // preview tile properties
    private int         previewTileSpriteID;
    private VectorInt   previewTileGridPosition;
    private int         previewTileRotation;
    private IntList     previewCorrectTileRotations = new IntList();
    private int         previewCorrectTileRotationsIndex = 0;

    // finals
    final int[][] theFourHorsemen = {{0,-1}, {1,0}, {0,1}, {-1,0}};






    // CONSTRUCTOR
    public GameController(){
        // load all sprites and their data files
        sprites = new PImage[spriteSize];
        tileDataList = new TileData[spriteSize];
        tileDataList = this.LoadTilesFromJSON();

        // create array for placed tiles
        placedTilesArray = new Tile[PLAY_AREA_SIZE.x][PLAY_AREA_SIZE.y];

        // init handlers
        graphicsHandler = new GraphicsHandler(this);
        uiHandler = new UIHandler(this);

        // init all sprites
        for(int i = 0; i < spriteSize; i++){
            String s = str(i);
            while( s.length() < 2)
                s = "0" + s;
            sprites[i] = loadImage("resources/sprites/sprite_" + s + ".png");
        }
        this.SelectNewRandomSprite();

        // add starter tile
        Tile starterTile = new Tile(new VectorInt(6,6), 14);
        placedTilesArray[6][6] = starterTile;
    }









    // MAIN METHODS

    void Update(){
        // place a tile if we have confirmed our placed
        if(this.isPreviewingPlacement && this.hasConfirmedPlacement){
            PlaceTile();
            ClearPlacementFlags();
            SelectNewRandomSprite();
        }
    }

    public void Render(){
        graphicsHandler.Render();
        uiHandler.Render();
    }





    // FUNCTIONALITY

    // changes the next sprite to a random sprite
    void SelectNewRandomSprite(){
        previewTileSpriteID = int(random(0, spriteSize));
    }

    // places a tile at the current preview position
    void PlaceTile(){
        println(previewTileGridPosition); 
        Tile newTile = new Tile(previewTileGridPosition, previewTileSpriteID, previewTileRotation);
        this.placedTilesArray[previewTileGridPosition.x][previewTileGridPosition.y] = newTile;
    }

    // clear preview and confirm placement flags
    void ClearPlacementFlags(){
        this.hasConfirmedPlacement = false;
        this.isPreviewingPlacement = false;
        previewCorrectTileRotations.clear();
    }

    // HELLO ROZA   ! ! ! ! ! ! <3
    //
    //     |\__/,|   (`\
    //   _.|o o  |_   ) )
    // -(((---(((--------
    //
    
    // returns the cell position of where the mouse is hovering
    VectorInt MouseToGridPosition(){
        PVector offsetMousePos = new PVector(mouseX-targetMargin, mouseY-targetMargin);
        if( offsetMousePos.x < 0 || offsetMousePos.y < 0 || offsetMousePos.x >= (PLAY_AREA_SIZE.x*TILE_SIZE) || offsetMousePos.y >= (PLAY_AREA_SIZE.y*TILE_SIZE) )
            return null;
        
        return new VectorInt( int(offsetMousePos.x / TILE_SIZE), int(offsetMousePos.y / TILE_SIZE) );
    }

    void GenerateCorrectRotations(VectorInt _gridPosition){
        previewCorrectTileRotationsIndex = 0;
        previewCorrectTileRotations.clear();

        boolean[] correctRotations = IsConnectionPossible(_gridPosition, previewTileSpriteID);
        
        String printString = "[ " + correctRotations[0];
        for(int i=1; i<4; i++){
            printString += ", " + correctRotations[i];
        }
        println("Boolean rotations: " + printString + "]");

        for(int i=0; i<4; i++){
            if(correctRotations[i])
                previewCorrectTileRotations.append(i);
        }
        previewTileRotation = previewCorrectTileRotations.get(0);
    }




    // INPUT CONTROL

    public void LeftMousePressed(){
        // check for UI click
        if( uiHandler.isInsideUI() ){
            int buttonPressed = uiHandler.LeftMousePressed();
            if( buttonPressed == uiHandler.CANCEL){
                ClearPlacementFlags();
            }
            else if( buttonPressed == uiHandler.CONFIRM){
                this.hasConfirmedPlacement = true;
            }
            return;
        }

        // are we within bounds
        if( !MouseWithinBounds() )
            return;

        // else create tile click
        VectorInt mouseGridPos = MouseToGridPosition();
        if( mouseGridPos == null ) return;

        if( !ValidTilePlacement(mouseGridPos) )
            return;
        
        // generate correct rotations
        GenerateCorrectRotations(mouseGridPos);

        previewTileGridPosition = mouseGridPos;
        this.isPreviewingPlacement = true;
    }

    public void RightMousePressed(){
        if( isPreviewingPlacement ){
            previewCorrectTileRotationsIndex++;
            if(previewCorrectTileRotationsIndex > (previewCorrectTileRotations.size()-1))
                previewCorrectTileRotationsIndex = 0;
            previewTileRotation = previewCorrectTileRotations.get(previewCorrectTileRotationsIndex);
        }
    }

    public int[] RetrieveSurroundingFaces(VectorInt _gridPosition){
        int[] facesList = new int[4];
        for(int i=0; i<4; i++){
            // check a certain position around _gridLocation
            VectorInt checkPosition = new VectorInt(
                _gridPosition.x + theFourHorsemen[i][0],
                _gridPosition.y + theFourHorsemen[i][1]
            );
            // get the tile or null at that location
            Tile checkTile = this.placedTilesArray[checkPosition.x][checkPosition.y];
            
            // set facetype depending on if there is a tile or not
            int faceType;
            if(checkTile == null)
                faceType = EMPTY;
            else{
                int checkSpriteID =  checkTile.getSpriteID();
                int[] dataTilePortList = tileDataList[checkSpriteID].getPortTypes();
                int[] rotatedDataList = RotateList(dataTilePortList, checkTile.getRotation());
                faceType = rotatedDataList[BoundDirection(i+2)];
            }

            // add that type to the facesList
            facesList[i] = faceType;
        }
        return facesList;
    }







    // JSON METHODS

    TileData[] LoadTilesFromJSON(){
        String filename = "tileConnections.json";
        JSONArray tilePieces = loadJSONArray(filename);
        TileData[] loadedTiles = new TileData[tilePieces.size()];

        // loop through available loaded Tile objects
        for (int i=0; i < tilePieces.size(); i++){
            // variables for each tile object
            int tileID;
            int[] portTypes = new int[4];
            boolean[][] portConnections = new boolean[4][4];
            
            // load tile object at index
            JSONObject tile = tilePieces.getJSONObject(i);

            // retrieve tile id
            tileID = tile.getInt("id");

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
            TileData newTileData = new TileData(tileID, portTypes, portConnections);
            loadedTiles[i] = newTileData;
        }

        println("\nLoaded " + loadedTiles.length + " tiles from JSON file!");
        return loadedTiles;
    }





    // BOOLEAN METHODS

    // is a location valid for a placement?
    public boolean ValidTilePlacement(VectorInt gridPosition){
        if( this.placedTilesArray[gridPosition.x][gridPosition.y] != null )
            return false;
        if( !HasNeighbours(gridPosition) )
            return false;

        boolean[] gridPositionCorrectRotations = IsConnectionPossible(gridPosition, previewTileSpriteID);
        boolean noRotations = false;
        for(int i=0; i<4; i++)
            noRotations = noRotations || gridPositionCorrectRotations[i];
        if(!noRotations)
            return false;

        return true;
    }

    // does a location have neighbours?
    boolean HasNeighbours(VectorInt gridPosition){
        for(int i = 0; i < 4; i++){
            VectorInt checkLocation = new VectorInt(
                gridPosition.x + theFourHorsemen[i][0],
                gridPosition.y + theFourHorsemen[i][1]
            );
            if( checkLocation.x < 0 || checkLocation.x >= PLAY_AREA_SIZE.x ||
            checkLocation.y < 0 || checkLocation.y >= PLAY_AREA_SIZE.y )
                continue;
            if(this.placedTilesArray[checkLocation.x][checkLocation.y] != null)
                return true;
        }
        return false;
    }

    // is the mouse within playarea bounds?
    boolean MouseWithinBounds(){
        if( mouseX <= targetMargin || mouseY <= targetMargin ||
        mouseX >= (targetMargin + PLAY_AREA_SIZE.x*TILE_SIZE) ||
        mouseY >= (targetMargin + PLAY_AREA_SIZE.y*TILE_SIZE))
            return false;
        return true;
    }

    // can a connection be made between neighbouring tiles at a location?
    boolean[] IsConnectionPossible(VectorInt _gridPosition, int _spriteID){
        // get a list of connections at point
        int[] connectionsList = RetrieveSurroundingFaces(_gridPosition);

        // retrieve _spriteID connection list
        int[] tileConnections = tileDataList[_spriteID].getPortTypes();

        // loop through and make a list 
        boolean[] answer = new boolean[4];
        for(int i=0; i<4; i++){
            int[] rotatedList = RotateList(tileConnections, i);
            answer[i] = IsTypeListsMatchable(rotatedList, connectionsList);
        }
        return answer;
    }

    // rotates a list by a certain number of rotations
    private int[] RotateList(int[] _list, int _rotation){
        // rotate list
        int[] rotatedList = _list;
        for(int i=0; i<_rotation; i++){
            int[] newList = {
                rotatedList[3],
                rotatedList[0],
                rotatedList[1],
                rotatedList[2]
            };
            rotatedList = newList;
        }
        return rotatedList;
    }

    // assumes lists are already rotated
    private boolean IsTypeListsMatchable(int[] _tileTypeList, int[] _surrTypeList){
        // check if lists don't match
        for(int i=0; i<4; i++){
            if(_surrTypeList[i] == EMPTY)
                continue;
            if(_surrTypeList[i] != _tileTypeList[i])
                return false;
        }

        // return true if otherwise
        return true;
    }





    // GET METHODS

    public PImage getTileSprite(int spriteID){
        return this.sprites[spriteID];
    }
    public TileData getTileData(int tileID){
        for(TileData td : tileDataList){
            if( td.getSpriteID() == tileID )
                return td;
        }
        return null;
    }

    public Tile[][] GetPlacedTilesArray(){
        return this.placedTilesArray;
    }

    public int GetPreviewTileSpriteID(){
        return this.previewTileSpriteID;
    }
    public VectorInt GetPreviewTileGridPosition(){
        return this.previewTileGridPosition;
    }
    public int GetPreviewTileRotation(){
        return this.previewTileRotation;
    }
    public IntList GetPreviewTileCorrectTileRotations(){
        return this.previewCorrectTileRotations;
    }
    public int GetPreviewTileCorrectTileRotationsIndex(){
        return this.previewCorrectTileRotationsIndex;
    }

    public boolean isPreviewingPlacement(){
        return this.isPreviewingPlacement;
    }

    public PImage getNextSprite(){
        return this.sprites[previewTileSpriteID];
    }
}