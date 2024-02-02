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