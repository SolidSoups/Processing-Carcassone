import java.security.*;

class Tile{
    // organized as North, East, South, West: with each element being either a City, Road or Grass.
    int[] portTypes = {GRASS, GRASS, GRASS, GRASS};
    // organized as North, East, South, West: with each 4 elements being a collection of which direction the port connects to.
    boolean[][] portConnections;

    // lock editing
    private boolean lock = false;

    // sprite id for tile
    int id;

    Tile(int id){
        this.id = id;
        this.portConnections = new boolean[4][4];
    }

    Tile(int id, int[] portTypes, boolean[][] portConnections){
        this.id = id;
        this.portTypes = portTypes;
        this.portConnections = portConnections;
        this.lock = true;
    }

    public int getID(){
        return this.id;
    }

    public int[] getPortTypes(){
        return this.portTypes;
    }

    public int getPortType(int i ){
        return this.portTypes[i];
    }

    public void setPortType(int i, int value){
        if(lock) return;
        if( value < 0 || value >= 3 )
            throw new InvalidParameterException("value out of bounds.");
        this.portTypes[i] = value;
    }

    public boolean[] getPortConnections(int i){
        return this.portConnections[i];
    }

    public void flipPortConnection(int i, int portDirection){
        if( lock ) return;
        if( i == portDirection )
            return;
        this.portConnections[i][portDirection] = !this.portConnections[i][portDirection];
    }

    String getLockString(){
        if(lock) return "locked";
        return "unlocked";
    }

    public boolean getLock(){
        return this.lock;
    }

    public void flipLock(){
        this.lock = !lock;
    }

    public String toString(){
        String s = "\nID: " + this.id + " " + this.getLockString() + "\n";
        for(int i=0; i<4; i++){
            s += typeNames[this.portTypes[i]] + ": ";
            for(int y=0; y<4; y++){
                s += this.portConnections[i][y] + " ";
            }
            s += "\n";
        }
        return s;
    }

}