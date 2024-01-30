class TileData{
    int tileID;
    int[] portTypes;
    boolean[][] portConnections;

    TileData(int tileID, int[] portTypes, boolean[][] portConnections){
        this.tileID = tileID;
        this.portTypes = portTypes;
        this.portConnections = portConnections;
    }

    public int getSpriteID(){
        return this.tileID;
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