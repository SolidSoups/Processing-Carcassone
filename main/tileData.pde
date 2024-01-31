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

    public int getSpriteID(){
        return this.tileID;
    }

    public int getTileCount(){
        return this.tileCount;
    }

    // return entire port types list
    public int[] getPortTypes(){
        return this.portTypes;
    }

    // return port type at compass direction
    public int getPortType(int i){
        return this.portTypes[i];
    }
}