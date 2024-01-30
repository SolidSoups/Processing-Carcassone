class Tile{
    int         rotation = 0;

    VectorInt   gridPosition;
    int         tileID;

    // main constructor
    public Tile(VectorInt gridPosition, int tileID){
        this.gridPosition = gridPosition;
        this.tileID = tileID;
        this.rotation = NORTH;
    }

    // place tile constructor
    public Tile(VectorInt gridPosition, int tileID, int rotation){
        this.gridPosition = gridPosition;
        this.tileID = tileID;
        this.rotation = rotation;
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