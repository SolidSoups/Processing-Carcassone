class TileData{
    int tileID, tileCount;
    int[] portTypes;
    boolean[][] portConnections;

    TileData(int tileID, int tileCount, int[] portTypes, boolean[][] portConnections){
        this.tileID = tileID;
        this.portTypes = portTypes;
        this.portConnections = portConnections;
        this.tileCount = tileCount;
    }

    // prints a boolean tile table
    public void printBooleanTable(){
        String[] values = {"North", "East", "South", "West"};
        println("From/To:\tNorth\tEast\tSouth\tWest");
        for(int x=0; x<4; x++){
            String newRow = "";
            newRow += values[x] + "\t\t";
            for(int y=0; y<4; y++){
                newRow += portConnections[x][y] + "\t";
            }
            println(newRow);
        }
    }

    public int get_spriteID(){
        return this.tileID;
    }
    public int get_tileCount(){
        return this.tileCount;
    }
    public int[] get_portTypes(){
        return this.portTypes;
    }
    public boolean[][] get_portConnections(){
        return this.portConnections;
    }
}