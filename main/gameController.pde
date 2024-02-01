import java.security.*;

class GameController{
    // handlers
    GraphicsHandler graphicsHandler;
    UIHandler       uiHandler;

    // sprites
    PImage[]    sprites;
    int         spriteSize = 24;
    int         nextSpriteID;

    // tile properties and arrays
    Tile[][]    placedTiles_matrix;
    TileData[]  tileData_array;

    // possible placements
    ArrayList<VectorInt>    validMoves              = new ArrayList<VectorInt>();
    IntList                 validRotations_IntList  = new IntList();

    // tile deck properties
    IntDict tileDistribution_dict;
    int     discardCount = 0;

    // preview tile properties
    private VectorInt   moveGridPosition;
    private int         moveRotation;
    private IntList     moveValidRotations_IntList  = new IntList();
    private int         moveValidRotationsIndex;

    // game control
    private boolean isGameOver = false;

    // input control
    private boolean isPreviewingMove        = false;
    private boolean hasConfirmedMove   = false;


    // finals
    final int[][] theFourHorsemen = {{0,-1}, {1,0}, {0,1}, {-1,0}};





    // CONSTRUCTOR
    public GameController(){
        // load all sprites
        sprites = new PImage[spriteSize];
        for(int i = 0; i < spriteSize; i++){
            String s = str(i);
            while( s.length() < 2)
                s = "0" + s;
            sprites[i] = loadImage("resources/sprites/sprite_" + s + ".png");
        }

        tileData_array = new TileData[spriteSize];
        tileData_array = this.LoadTilesFromJSON();

        ResetGame();
    }






    // MAIN METHODS

    public void Update(){
        // check if game is over
        if(this.tileDistribution_dict.size() == 0){
            this.GameOver();
            return;
        }

        // place a tile if we have confirmed our placed
        if(this.isPreviewingMove && this.hasConfirmedMove){
            PlaceTile();
            ClearInputFlags();
            DrawNextTile();
        }
    }

    public void Render(){
        graphicsHandler.Render();
        uiHandler.Render();
    }




    // GAME FUNCTIONALITY

    private void GameOver(){
        this.isGameOver = true;
        delay(10000);
        ResetGame();
    }

    private void ResetGame(){
        // initialize handlers
        graphicsHandler = new GraphicsHandler(this);
        uiHandler = new UIHandler(this);

        // initialize arrays
        placedTiles_matrix      = new Tile[PLAY_AREA_SIZE.x][PLAY_AREA_SIZE.y];
        tileDistribution_dict   = new IntDict();
        discardCount = 0;

        ClearInputFlags();

        // add starter tile to middle position
        VectorInt middlePosition = new VectorInt(int(PLAY_AREA_SIZE.x/2), int(PLAY_AREA_SIZE.y/2));
        placedTiles_matrix[middlePosition.x][middlePosition.y] = new Tile(middlePosition, 14);

        // Fill deck with cards and remove one starter tile
        FillDeck();
        tileDistribution_dict.sub("14", 1);

        // draw the next tile
        DrawNextTile();
    }





    // DECK FUNCTIONALITY

    public void DrawNextTile(){
        if(this.tileDistribution_dict.size() == 0) return;

        int randomIndex = int( random(0, this.tileDistribution_dict.size() ) );

        String spriteID  = this.tileDistribution_dict.keyArray()[ randomIndex ];
        int tileCount = this.tileDistribution_dict.get( spriteID );
        
        // decrease the tileCount
        this.tileDistribution_dict.sub( spriteID, 1 );
        if(this.tileDistribution_dict.get( spriteID ) == 0)
            this.tileDistribution_dict.remove( spriteID );

        nextSpriteID = int( spriteID );
        
        if(!IsPlacementPossible()){
            discardCount++;
            DrawNextTile();
        }
    }

    public int GetDistributionCount(){
        int count = 0;
        for(int i : tileDistribution_dict.values())
            count += i;
        return count;
    }

    private void FillDeck(){
        tileDistribution_dict.clear();
        for(int i=0; i<tileData_array.length; i++){
            TileData td = tileData_array[i];
            if(td == null) continue;

            String id = str(td.getSpriteID());
            int count = td.getTileCount();

            tileDistribution_dict.set(id, count);
        }
    }




    // TILE FUNCTIONALITY

    public PImage FetchTileSprite(int spriteID){
        return this.sprites[spriteID];
    }

    public PImage getNextSprite(){
        return this.sprites[nextSpriteID];
    }

    private void PlaceTile(){
        Tile newTile = new Tile(moveGridPosition, nextSpriteID, moveRotation);
        
        // set neighbours
        Tile[] neighbours = FetchNeighbours(moveGridPosition);
        println();
        for(int i=0; i<4; i++){
            if(neighbours[i] == null) continue;
            newTile.AddNeighbour(i, neighbours[i]);
            neighbours[i].AddNeighbour(BoundDirection(i-2), newTile);
            println("Neighbour " + DIRECTION_NAMES[i] + ": " + neighbours[i].getSpriteID());
        } 

        // highlight a current city feature

        this.placedTiles_matrix[moveGridPosition.x][moveGridPosition.y] = newTile;
    }

    private boolean PositionHasNeighbours(VectorInt _gridPosition){
        for(int i = 0; i < 4; i++){
            VectorInt checkLocation = new VectorInt(
                _gridPosition.x + theFourHorsemen[i][0],
                _gridPosition.y + theFourHorsemen[i][1]
            );
            if( checkLocation.x < 0 || checkLocation.x >= PLAY_AREA_SIZE.x ||
            checkLocation.y < 0 || checkLocation.y >= PLAY_AREA_SIZE.y )
                continue;
            if(this.placedTiles_matrix[checkLocation.x][checkLocation.y] != null)
                return true;
        }
        return false;
    }

    private Tile[] FetchNeighbours(VectorInt _gridPosition){
        Tile[] compassNeighbours = new Tile[4];
        for(int i=0; i<4; i++){
            VectorInt checkPosition = new VectorInt(
                _gridPosition.x + theFourHorsemen[i][0],
                _gridPosition.y + theFourHorsemen[i][1]
            );
            Tile checkTile = placedTiles_matrix[checkPosition.x][checkPosition.y];
            if(checkTile != null){
                compassNeighbours[i] = checkTile;
            }
        }

        return compassNeighbours;
    }


    // FEATURE FUNCTIONALITY




    // MOVE FUNCTIONALITY

    public boolean IsValidTilePlacement(VectorInt _gridPosition){
        if( this.placedTiles_matrix[_gridPosition.x][_gridPosition.y] != null )
            return false;
        if( !PositionHasNeighbours(_gridPosition) )
            return false;

        boolean[] _gridPositionCorrectRotations = FetchValidRotations(_gridPosition, nextSpriteID);
        boolean noRotations = false;
        for(int i=0; i<4; i++)
            noRotations = noRotations || _gridPositionCorrectRotations[i];
        if(!noRotations)
            return false;

        return true;
    }

    public boolean IsPlacementPossible(){
        this.validMoves.clear();
        this.validRotations_IntList.clear();

        for(int x=0; x<PLAY_AREA_SIZE.x; x++){
            for(int y=0; y<PLAY_AREA_SIZE.y; y++){
                VectorInt pos = new VectorInt(x, y);

                if(IsValidTilePlacement(pos))
                    this.validMoves.add(pos);
                else
                    continue;
                
                boolean[] rotations = FetchValidRotations(pos, nextSpriteID);
                int count = 0;
                for(int i=0; i<4; i++){
                    if(rotations[i]) count++;
                }
                
                this.validRotations_IntList.append(count);
            }
        }

        if(this.validMoves.size() != 0)
            return true;
        return false;
    }

    public TileData FetchTileData(int _tileID){
        for(TileData td : tileData_array){
            if( td.getSpriteID() == _tileID )
                return td;
        }
        return null;
    }

    private boolean[] FetchValidRotations(VectorInt _gridPosition, int _spriteID){
        // get a list of connections at point
        int[] connectionsList = CalculateNeighbouringFaces(_gridPosition);

        // retrieve _spriteID connection list
        int[] tileConnections = tileData_array[_spriteID].getPortTypes();

        // Rotates the tile and adds a boolean item determining if the lists match at that certain rotation
        boolean[] answer = new boolean[4];
        for(int i=0; i<4; i++){
            int[] rotatedList = RotateListNTimes(tileConnections, i);
            answer[i] = IsTypeListsMatchable(rotatedList, connectionsList);
        }
        return answer;
    }



    // INPUT

    public void LeftMousePressed(){
        // check for UI click
        if( uiHandler.IsInsideUI() ){
            int buttonPressed = uiHandler.LeftMousePressed();
            if( buttonPressed == uiHandler.CANCEL){
                ClearInputFlags();
            }
            else if( buttonPressed == uiHandler.CONFIRM){
                this.hasConfirmedMove = true;
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

        moveGridPosition = mouseGridPos;
        this.isPreviewingMove = true;
    }

    public void RightMousePressed(){
        if( isPreviewingMove ){
            moveValidRotationsIndex++;
            if(moveValidRotationsIndex > (moveValidRotations_IntList.size()-1))
                moveValidRotationsIndex = 0;
            moveRotation = moveValidRotations_IntList.get(moveValidRotationsIndex);
        }
    }

    public VectorInt MouseToGridPosition(){
        PVector offsetMousePos = new PVector(mouseX-targetMargin, mouseY-targetMargin);
        if( offsetMousePos.x < 0 || offsetMousePos.y < 0 || offsetMousePos.x >= (PLAY_AREA_SIZE.x*TILE_SIZE) || offsetMousePos.y >= (PLAY_AREA_SIZE.y*TILE_SIZE) )
            return null;
        
        return new VectorInt( int(offsetMousePos.x / TILE_SIZE), int(offsetMousePos.y / TILE_SIZE) );
    }

    private boolean MouseWithinPlayarea(){
        if( mouseX <= targetMargin || mouseY <= targetMargin ||
        mouseX >= (targetMargin + PLAY_AREA_SIZE.x*TILE_SIZE) ||
        mouseY >= (targetMargin + PLAY_AREA_SIZE.y*TILE_SIZE))
            return false;
        return true;
    }

    private void ClearInputFlags(){
        this.hasConfirmedMove = false;
        this.isPreviewingMove = false;
        moveValidRotations_IntList.clear();
        moveValidRotationsIndex = 0;
    }

    // HELLO ROZA   ! ! ! ! ! ! <3
    //
    //     |\__/,|   (`\
    //   _.|o o  |_   ) )
    // -(((---(((--------
    //
    

    


    // TILE PROPERTY MAGIC MATH

    public int[] CalculateNeighbouringFaces(VectorInt _gridPosition){
        if(_gridPosition == null) return null;
        int[] facesList = new int[4];
        for(int i=0; i<4; i++){
            VectorInt checkPosition = new VectorInt(
                _gridPosition.x + theFourHorsemen[i][0],
                _gridPosition.y + theFourHorsemen[i][1]
            );
            // get the tile or null at that location
            if( checkPosition.x < 0 || checkPosition.x >= PLAY_AREA_SIZE.x ||
            checkPosition.y < 0 || checkPosition.y >= PLAY_AREA_SIZE.y )
                continue;
            Tile checkTile = this.placedTiles_matrix[checkPosition.x][checkPosition.y];
            
            // set facetype depending on if there is a tile or not
            int faceType;
            if(checkTile == null)
                faceType = EMPTY;
            else{
                int checkSpriteID =  checkTile.getSpriteID();
                int[] dataTilePortList = tileData_array[checkSpriteID].getPortTypes();
                int[] rotatedDataList = RotateListNTimes(dataTilePortList, checkTile.getRotation());
                faceType = rotatedDataList[BoundDirection(i+2)];
            }

            // add that type to the facesList
            facesList[i] = faceType;
        }
        return facesList;
    }

    private void GenerateCorrectRotations(VectorInt _gridPosition){
        moveValidRotationsIndex = 0;
        moveValidRotations_IntList.clear();


        boolean[] correctRotations = new boolean[4];

        int[] connectionsList = CalculateNeighbouringFaces(_gridPosition);
        int[] tileConnections = tileData_array[get_nextSpriteID()].getPortTypes();

        for(int i=0; i<4; i++){
            int[] rotatedList = RotateListNTimes(tileConnections, i);
            correctRotations[i] = IsTypeListsMatchable(rotatedList, connectionsList);
        }


        for(int i=0; i<4; i++){
            if(correctRotations[i])
                moveValidRotations_IntList.append(i);
        }
        moveRotation = moveValidRotations_IntList.get(0);
    }

    private int[] RotateListNTimes(int[] _list, int _n){
        int[] rotatedList = _list;
        for(int i=0; i<_n; i++){
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

    private boolean IsTypeListsMatchable(int[] _tileTypeList, int[] _surrTypeList){
        for(int i=0; i<4; i++){
            if(_surrTypeList[i] == EMPTY)
                continue;
            if(_surrTypeList[i] != _tileTypeList[i])
                return false;
        }
        return true;
    }





    // JSON 

    private TileData[] LoadTilesFromJSON(){
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





    // GETTERS

    // sprite
    public int get_nextSpriteID(){
        return this.nextSpriteID;
    }

    // tiles
    public Tile[][] get_placedTiles(){
        return this.placedTiles_matrix;
    }
    public IntDict get_tileDistribution(){
        return this.tileDistribution_dict;
    }
    public int get_discardCount(){
        return this.discardCount;
    }

    // possible moves properties
    public IntList get_validRotations(){
        return this.validRotations_IntList;
    }
    public ArrayList<VectorInt> get_validMoves(){
        return this.validMoves;
    }

    // move properties
    public VectorInt get_moveGridPosition(){
        return this.moveGridPosition;
    }
    public int get_moveRotation(){
        return this.moveRotation;
    }
    public IntList get_moveValidRotations(){
        return this.moveValidRotations_IntList;
    }
    public int get_moveValidRotationsIndex(){
        return this.moveValidRotationsIndex;
    }

    public boolean isPreviewingMove(){
        return this.isPreviewingMove;
    }
}