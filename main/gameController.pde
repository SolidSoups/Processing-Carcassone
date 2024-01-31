import java.security.*;

class GameController{
    Tile[][] placedTilesArray;
    TileData[] tileDataList;

    IntDict tileDistribution_dict;
    int discardCount = 0;

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
    private IntList     previewCorrectTileRotations         = new IntList();
    private int         previewCorrectTileRotationsIndex    = 0;

    // possible placements
    ArrayList<VectorInt>    possiblePlacements             = new ArrayList<VectorInt>();
    IntList                 possiblePlacementsRotations    = new IntList();

    // finals
    final int[][] theFourHorsemen = {{0,-1}, {1,0}, {0,1}, {-1,0}};





    // CONSTRUCTOR
    public GameController(){
        // load all sprites and their data files
        sprites = new PImage[spriteSize];
        tileDataList = new TileData[spriteSize];
        tileDataList = this.LoadTilesFromJSON();
        tileDistribution_dict = new IntDict();

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

        // add starter tile
        Tile starterTile = new Tile(new VectorInt(6,6), 14);
        placedTilesArray[6][6] = starterTile;

        FillTilePile();
        tileDistribution_dict.sub("14", 1);

        DrawNextTile();
    }









    // MAIN METHODS

    void Update(){
        // place a tile if we have confirmed our placed
        if(this.isPreviewingPlacement && this.hasConfirmedPlacement){
            PlaceTile();
            ClearPlacementFlags();
            DrawNextTile();
        }
    }

    public void Render(){
        graphicsHandler.Render();
        uiHandler.Render();
    }





    // FUNCTIONALITY

    // changes the next sprite to a random sprite
    void DrawNextTile(){
        if( tileDistribution_dict.size() == 0) return;

        int randomIndex = int(random(0, tileDistribution_dict.size()));

        String spriteID  = tileDistribution_dict.keyArray()[randomIndex];
        int tileCount = tileDistribution_dict.get(spriteID);
        
        // decrease the tileCount
        tileDistribution_dict.sub(spriteID, 1);
        if(tileDistribution_dict.get(spriteID) == 0)
            tileDistribution_dict.remove(spriteID);

        // copy sprite id to the preview sprite
        previewTileSpriteID = int(spriteID);
        
        // check if it is impossible
        if(!IsPlacementPossible()){
            discardCount++;
            DrawNextTile();
        }

        println("Count: " + GetDistributionCount());
    }

    int GetDistributionCount(){
        int count = 0;
        for(int i : tileDistribution_dict.values())
            count += i;
        return count;
    }

    // places a tile at the current preview position
    void PlaceTile(){
        Tile newTile = new Tile(previewTileGridPosition, previewTileSpriteID, previewTileRotation);
        this.placedTilesArray[previewTileGridPosition.x][previewTileGridPosition.y] = newTile;
    }

    // clear preview and confirm placement flags
    void ClearPlacementFlags(){
        this.hasConfirmedPlacement = false;
        this.isPreviewingPlacement = false;
        previewCorrectTileRotations.clear();
        previewCorrectTileRotationsIndex = 0;
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

        for(int i=0; i<4; i++){
            if(correctRotations[i])
                previewCorrectTileRotations.append(i);
        }
        previewTileRotation = previewCorrectTileRotations.get(0);
    }

    void FillTilePile(){
        tileDistribution_dict.clear();
        for(int i=0; i<tileDataList.length; i++){
            TileData td = tileDataList[i];

            String id = str(td.getSpriteID());
            int count = td.getTileCount();

            tileDistribution_dict.set(id, count);
        }
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

        if( !MouseWithinPlayarea() )
            return;

        VectorInt mouseGridPos = MouseToGridPosition();
        if( mouseGridPos == null ) return;

        if( !IsValidTilePlacement(mouseGridPos) )
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

    public int[] RetrieveSurroundingFaceTypes(VectorInt _gridPosition){
        int[] facesList = new int[4];
        for(int i=0; i<4; i++){
            // check a certain position around _gridLocation
            VectorInt checkPosition = new VectorInt(
                _gridPosition.x + theFourHorsemen[i][0],
                _gridPosition.y + theFourHorsemen[i][1]
            );
            // get the tile or null at that location
            if( checkPosition.x < 0 || checkPosition.x >= PLAY_AREA_SIZE.x ||
            checkPosition.y < 0 || checkPosition.y >= PLAY_AREA_SIZE.y )
                continue;
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

    // Rotates a given list a certain amount of times given by rotation count
    private int[] RotateList(int[] _list, int _rotateCount){
        // rotate list
        int[] rotatedList = _list;
        for(int i=0; i<_rotateCount; i++){
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












    // JSON METHODS

    TileData[] LoadTilesFromJSON(){
        String filename = "tileData";
        JSONArray tilePieces = loadJSONArray(filename + ".json");
        TileData[] loadedTiles = new TileData[tilePieces.size()];

        // loop through available loaded Tile objects
        for (int i=0; i < tilePieces.size(); i++){
            // variables for each tile object
            int tileID, tileCount;
            int[] portTypes = new int[4];
            boolean[][] portConnections = new boolean[4][4];
            
            // load tile object at index
            JSONObject tile = tilePieces.getJSONObject(i);

            // retrieve tile id
            tileID = tile.getInt("id");

            // retrieve tile count
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
            TileData newTileData = new TileData(tileID, tileCount, portTypes, portConnections);
            loadedTiles[i] = newTileData;
        }

        println("\nLoaded " + loadedTiles.length + " tiles from JSON file!");
        return loadedTiles;
    }












    // BOOLEAN METHODS

    // is a location valid for a placement?
    public boolean IsValidTilePlacement(VectorInt _gridPosition){
        if( this.placedTilesArray[_gridPosition.x][_gridPosition.y] != null )
            return false;
        if( !HasNeighbours(_gridPosition) )
            return false;

        // we check if our tile can even be here
        boolean[] _gridPositionCorrectRotations = IsConnectionPossible(_gridPosition, previewTileSpriteID);
        boolean noRotations = false;
        for(int i=0; i<4; i++)
            noRotations = noRotations || _gridPositionCorrectRotations[i];
        if(!noRotations)
            return false;

        return true;
    }

    // Returns true if at least one direct neighbour next to a given grid position
    boolean HasNeighbours(VectorInt _gridPosition){
        for(int i = 0; i < 4; i++){
            VectorInt checkLocation = new VectorInt(
                _gridPosition.x + theFourHorsemen[i][0],
                _gridPosition.y + theFourHorsemen[i][1]
            );
            if( checkLocation.x < 0 || checkLocation.x >= PLAY_AREA_SIZE.x ||
            checkLocation.y < 0 || checkLocation.y >= PLAY_AREA_SIZE.y )
                continue;
            if(this.placedTilesArray[checkLocation.x][checkLocation.y] != null)
                return true;
        }
        return false;
    }

    // Returns true if the mouse is within the play area
    boolean MouseWithinPlayarea(){
        if( mouseX <= targetMargin || mouseY <= targetMargin ||
        mouseX >= (targetMargin + PLAY_AREA_SIZE.x*TILE_SIZE) ||
        mouseY >= (targetMargin + PLAY_AREA_SIZE.y*TILE_SIZE))
            return false;
        return true;
    }

    // Returns a boolean list of possible rotations where the index is the rotation at a given grid location with a given tile
    boolean[] IsConnectionPossible(VectorInt _gridPosition, int _spriteID){
        // get a list of connections at point
        int[] connectionsList = RetrieveSurroundingFaceTypes(_gridPosition);

        // retrieve _spriteID connection list
        int[] tileConnections = tileDataList[_spriteID].getPortTypes();

        // Rotates the tile and adds a boolean item determining if the lists match at that certain rotation
        boolean[] answer = new boolean[4];
        for(int i=0; i<4; i++){
            int[] rotatedList = RotateList(tileConnections, i);
            answer[i] = IsTypeListsMatchable(rotatedList, connectionsList);
        }
        return answer;
    }

    // Checks if two face type lists can match
    private boolean IsTypeListsMatchable(int[] _tileTypeList, int[] _surrTypeList){
        for(int i=0; i<4; i++){
            if(_surrTypeList[i] == EMPTY)
                continue;
            if(_surrTypeList[i] != _tileTypeList[i])
                return false;
        }
        return true;
    }

    public boolean IsPlacementPossible(){
        possiblePlacements.clear();
        possiblePlacementsRotations.clear();

        for(int x=0; x<PLAY_AREA_SIZE.x; x++){
            for(int y=0; y<PLAY_AREA_SIZE.y; y++){
                VectorInt pos = new VectorInt(x, y);

                if(IsValidTilePlacement(pos))
                    possiblePlacements.add(pos);
                else
                    continue;
                
                boolean[] rotations = IsConnectionPossible(pos, previewTileSpriteID);
                int count = 0;
                for(int i=0; i<4; i++){
                    if(rotations[i]) count++;
                }
                
                possiblePlacementsRotations.append(count);
            }
        }

        if(possiblePlacements.size() != 0)
            return true;
        return false;
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

    public ArrayList<VectorInt> GetPossiblePlacements(){
        return this.possiblePlacements;
    }

    public IntList GetPossiblePlacementsRotations(){
        return this.possiblePlacementsRotations;
    }
}