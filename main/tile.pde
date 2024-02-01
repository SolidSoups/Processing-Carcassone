class Tile{
    int         rotation = 0;

    VectorInt   gridPosition;
    int         tileID;

    Tile[] neighbours;

    // main constructor
    public Tile(VectorInt gridPosition, int tileID){
        this.gridPosition = gridPosition;
        this.tileID = tileID;
        this.rotation = NORTH;

        neighbours = new Tile[4];
    }

    // place tile constructor
    public Tile(VectorInt gridPosition, int tileID, int rotation){
        this.gridPosition = gridPosition;
        this.tileID = tileID;
        this.rotation = rotation;
        
        neighbours = new Tile[4];
    }

    public void AddNeighbour(int _index, Tile _tileRef){
        this.neighbours[_index] = _tileRef;
    }

    // getters
    public int getSpriteID(){
        return this.tileID;
    }
    public VectorInt getGridPosition(){
        return this.gridPosition;
    }
    public int getRotation(){
        return this.rotation;
    }
}