class Tile{
    int         rotation = 0;
    int         tileID;
    Tile[] neighbours;

    VectorInt gridPosition;

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


    public VectorInt get_gridPosition(){
        return this.gridPosition;
    }

    // getters
    public Tile[] get_neighbours(){
        return this.neighbours;
    }
    public int get_spriteID(){
        return this.tileID;
    }
    public int get_rotation(){
        return this.rotation;
    }
}