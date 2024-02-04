import java.security.*;

class GameController{
    // handlers
    GraphicsHandler graphicsHandler;
    UIHandler       uiHandler;
    Deck gameDeck;
    Features features;

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

    // move handler
    private Move        currentMove;

    // game control
    private boolean isGameOver = false;

    // player control
    int score = 0;
    
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
        if(this.gameDeck.isEmpty()){
            this.GameOver();
            return;
        }

        // place a tile if we have confirmed our placed
        if(this.isPreviewingMove && this.hasConfirmedMove){
            PlaceTile();
            ClearInputFlags();

            // grab a new card that can be placed
            gameDeck.DrawCard();
            while(!IsPlacementPossible()){
                gameDeck.DrawCard();
            }
        }
    }

    public void Render(){
        graphicsHandler.Render();
        uiHandler.Render();
    }

    private void GameOver(){
        this.isGameOver = true;
        println("Game Over");
        delay(10000);
        ResetGame();
    }

    private void ResetGame(){
        // initialize handlers
        graphicsHandler = new GraphicsHandler(this);
        uiHandler = new UIHandler(this);

        gameDeck = new Deck(this);
        features = new Features(this);

        // initialize arrays
        placedTiles_matrix      = new Tile[PLAY_AREA_SIZE.x][PLAY_AREA_SIZE.y];

        ClearInputFlags();

        // add starter tile to middle position
        VectorInt middlePosition = new VectorInt(int(PLAY_AREA_SIZE.x/2), int(PLAY_AREA_SIZE.y/2));
        placedTiles_matrix[middlePosition.x][middlePosition.y] = new Tile(middlePosition, 14);

        // Fill deck with cards and remove one starter tile
        gameDeck.FillDeck(14);

        // draw the next tile
        gameDeck.DrawCard();
    }

    public void AddScore(int score){
        this.score += score;
    }












    // TILE FUNCTIONALITY

    public PImage FetchTileSprite(int spriteID){
        return this.sprites[spriteID];
    }

    public PImage getNextSprite(){
        return this.sprites[this.gameDeck.get_currentCard()];
    }

    private void PlaceTile(){
        VectorInt gridPosition = this.currentMove.get_gridPosition();
        Tile newTile = new Tile(gridPosition, this.gameDeck.get_currentCard(), this.currentMove.get_rotation());
        
        // set neighbours
        Tile[] neighbours = FetchNeighbours(gridPosition);

        for(int i=0; i<4; i++){
            if(neighbours[i] == null) continue;
            newTile.AddNeighbour(i, neighbours[i]);
            neighbours[i].AddNeighbour(BoundOrientation(i-2), newTile);
        } 

        if(!this.features.IsRoadComplete(newTile)){
            if(DEBUG_MODE)
                println("Total Score: " + score);
        }


        this.placedTiles_matrix[gridPosition.x][gridPosition.y] = newTile;
    }

    private boolean PositionHasNeighbours(VectorInt _gridPosition){
        for(int i = 0; i < 4; i++){
            VectorInt checkPosition = new VectorInt(
                _gridPosition.x + theFourHorsemen[i][0],
                _gridPosition.y + theFourHorsemen[i][1]
            );

            if(!IsWithingGridPlayArea(checkPosition)) continue;
            
            if(this.placedTiles_matrix[checkPosition.x][checkPosition.y] != null)
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
            
            if(!IsWithingGridPlayArea(checkPosition)) continue;
            
            Tile checkTile = placedTiles_matrix[checkPosition.x][checkPosition.y];
            if(checkTile != null){
                compassNeighbours[i] = checkTile;
            }
        }

        return compassNeighbours;
    }










    // MOVE FUNCTIONALITY

    public boolean IsValidTilePlacement(VectorInt _gridPosition){
        if( this.placedTiles_matrix[_gridPosition.x][_gridPosition.y] != null )
            return false;
        if( !PositionHasNeighbours(_gridPosition) )
            return false;

        boolean[] _gridPositionCorrectRotations = FetchValidRotations(_gridPosition, this.gameDeck.get_currentCard());
        boolean noRotations = false;
        for(int i=0; i<4; i++)
            noRotations = noRotations || _gridPositionCorrectRotations[i];
        if(!noRotations)
            return false;

        return true;
    }

    public boolean IsPlacementPossible(){
        int spriteID = gameDeck.get_currentCard();
        this.validMoves.clear();
        this.validRotations_IntList.clear();

        for(int x=0; x<PLAY_AREA_SIZE.x; x++){
            for(int y=0; y<PLAY_AREA_SIZE.y; y++){
                VectorInt pos = new VectorInt(x, y);

                if(IsValidTilePlacement(pos))
                    this.validMoves.add(pos);
                else
                    continue;
                
                boolean[] rotations = FetchValidRotations(pos, spriteID);
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
            if( td.get_spriteID() == _tileID )
                return td;
        }
        return null;
    }

    private boolean[] FetchValidRotations(VectorInt _gridPosition, int _spriteID){
        // get a list of connections at point
        int[] connectionsList = CalculateNeighbouringFaces(_gridPosition);

        // retrieve _spriteID connection list
        int[] tileConnections = tileData_array[_spriteID].get_portTypes();

        // Rotates the tile and adds a boolean item determining if the lists match at that certain rotation
        boolean[] answer = new boolean[4];
        for(int i=0; i<4; i++){
            int[] rotatedList = RotateListNTimes(tileConnections, i);
            answer[i] = IsTypeListsMatchable(rotatedList, connectionsList);
        }
        return answer;
    }

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
                faceType = PortType.EMPTY.index;
            else{
                int checkSpriteID =  checkTile.get_spriteID();
                int[] dataTilePortList = tileData_array[checkSpriteID].get_portTypes();
                int[] rotatedDataList = RotateListNTimes(dataTilePortList, checkTile.get_rotation());
                faceType = rotatedDataList[BoundOrientation(i+2)];
            }

            // add that type to the facesList
            facesList[i] = faceType;
        }
        return facesList;
    }

    private boolean IsWithingGridPlayArea(VectorInt _v){
        if(_v.x < 0 || _v.x >= PLAY_AREA_SIZE.x ||
        _v.y < 0 || _v.y >= PLAY_AREA_SIZE.y )
            return false;
        return true;
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

        if( !IsValidTilePlacement(mouseGridPos) ){
            currentMove = null;
            return;
        }
        
        currentMove = new Move(this, mouseGridPos);

        this.isPreviewingMove = true;
    }


    public void RightMousePressed(){
        if( isPreviewingMove ){
            currentMove.NextRotation();
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
        this.currentMove = null;
    }

    // HELLO ROZA   ! ! ! ! ! ! <3
    //
    //     |\__/,|   (`\
    //   _.|o o  |_   ) )
    // -(((---(((--------
    //
    

    








    // TILE PROPERTY MAGIC MATH

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
            if(_surrTypeList[i] == PortType.EMPTY.index)
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

    public Move get_currentMove(){
        return this.currentMove;
    }

    // sprite
    public int get_nextSpriteID(){
        return this.gameDeck.get_currentCard();
    }
    
    // tiles
    public Tile[][] get_placedTiles(){
        return this.placedTiles_matrix;
    }
    public Deck get_gameDeck(){
        return this.gameDeck;
    }
    public Features get_features(){
        return this.features;
    }

    // tile data
    public TileData[] get_tileDataArray(){
        return this.tileData_array;
    }

    // possible moves properties
    public IntList get_validRotations(){
        return this.validRotations_IntList;
    }
    public ArrayList<VectorInt> get_validMoves(){
        return this.validMoves;
    }
    public boolean isPreviewingMove(){
        return this.isPreviewingMove;
    }
}