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

    // constructor for creating a loaded tile object
    Tile(int id, int[] portTypes, boolean[][] portConnections){
        this.id = id;
        this.portTypes = portTypes;
        this.portConnections = portConnections;
        this.lock = true;
    }

    // GETTER METHODS

    public int getID(){
        return this.id;
    }

    public boolean getLock(){
        return this.lock;
    }

    public int[] getPortTypes(){
        return this.portTypes;
    }

    // get connections for a specific port i
    public boolean[] getPortConnections(int i){
        return this.portConnections[i];
    }

    // get portType for a specific port i
    public int getPortType(int i){
        return this.portTypes[i];
    }

    // set portType to value for a specific port i
    public void setPortType(int i, int value){
        if(lock) return;
        if( value < 0 || value >= 3 )
            throw new InvalidParameterException("value out of bounds.");
        this.portTypes[i] = value;
    }

    // flip the lock state
    public void flipLock(){
        this.lock = !lock;
    }

    // enable a connection between a port to another
    public void flipPortConnection(int fromPort, int toPort){
        if( lock ) return;
        if( fromPort == toPort )
            return;
        this.portConnections[fromPort][toPort] = !this.portConnections[fromPort][toPort];
    }

    // returns a string of the lock state
    String getLockString(){
        if(lock) return "locked";
        return "unlocked";
    }

    // to string method
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