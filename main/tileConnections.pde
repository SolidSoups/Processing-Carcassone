class TileConnections{
    // enums
    public final int GRASS      = 0; // default int value is 0
    public final int ROAD       = 1;
    public final int ROAD_NORTH = 2;
    public final int ROAD_EAST  = 3;
    public final int ROAD_SOUTH = 4;
    public final int ROAD_WEST  = 5;
    public final int CITY       = 6;
    public final int CITYNORTH  = 7;
    public final int CITYEAST   = 8;
    public final int CITYSOUTH  = 9;
    public final int CITYWEST   = 10;
    
    //
    int[][] connectionLists;

    // Parent tile reference
    Tile parentTile;

    public TileConnections(Tile parentTile){
        this.parentTile = parentTile;

        connectionLists = new int[4][];
    }

    public void setConnections(int[] north, int[] east, int[] south, int[] west){
        if( north.length > 4 || east.length > 4 || south.length > 4 || west.length > 4){
            println("Given connections are too large");
            return;
        }

        connectionLists[parentTile.NORTH] = north;
        connectionLists[parentTile.EAST]  = east;
        connectionLists[parentTile.SOUTH] = south;
        connectionLists[parentTile.WEST]  = west;
    }
}