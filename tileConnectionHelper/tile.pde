import java.security.*;

class Tile{
    // organized as North, East, South, West: with each element being either a City, Road or Grass.
    int[] portTypes = {GRASS, GRASS, GRASS, GRASS};
    // organized as North, East, South, West: with each 4 elements being a collection of which direction the port connects to.
    boolean[][] portConnections;

    // sprite id for tile
    int id;

    Tile(int id){
        this.id = id;
        this.portConnections = new boolean[4][4];
    }

    public int[] getPortTypes(){
        return this.portTypes;
    }

    public int getPortType(int i ){
        return this.portTypes[i];
    }

    public void setPortType(int i, int value){
        if( value < 0 || value >= 3 )
            throw new InvalidParameterException("value out of bounds.");
        this.portTypes[i] = value;
    }

    public boolean[] getPortConnections(int i){
        return this.portConnections[i];
    }

    public void flipPortConnection(int i, int portDirection){
        if( i == portDirection )
            return;
        this.portConnections[i][portDirection] = !this.portConnections[i][portDirection];
    }

    public String toString(){
        String s = "\nID: " + this.id + "\n";
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