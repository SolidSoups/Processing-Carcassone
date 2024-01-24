// enums
public final int GRASS      = 0; // default int value is 0
public final int ROAD       = 1;
public final int CITY       = 2;
public final String[] typeNames = {
    "grass", 
    "road",
    "city",
};
public final String[] directionNames = {
    "north",
    "east",
    "south",
    "west"
};

// directions
public final int NORTH = 0;
public final int EAST  = 1;
public final int SOUTH = 2;
public final int WEST  = 3;


public final int ERROR = 100;

PImage[] tileSprites;
int tileSpritesSize = 24;

int currentSpriteIndex = 0;

// colors
color blue = color(0, 0, 255);
color green = color(0, 255, 0);

ArrayList<Connections> connectionsList;
int currentDirection = NORTH;
int portDirectionCount = 0;

void setup(){
    size(600, 600);
    
    connectionsList = new ArrayList<Connections>();

    // load sprites
    tileSprites = new PImage[tileSpritesSize];
    for(int i = 0; i < tileSpritesSize; i++){
        String s = str(i);
        while( s.length() < 2)
            s = "0" + s;
        tileSprites[i] = loadImage("resources/sprites/sprite_" + s + ".png");
        connectionsList.add( new Connections(i) );
    }
}

void draw(){
    background(0);

    // draw current sprite index
    fill(255,0,0);
    
    textSize(50);
    text(str(currentSpriteIndex), 10, 40);

    // draw current sprite
    image(tileSprites[currentSpriteIndex], 100, 100, 400, 400);

    // draw all connections on current sprite
    pushStyle();
    textSize(30);
    textAlign(CENTER, TOP);

    // draw north type
    String portType = typeNames[connectionsList.get(currentSpriteIndex).getPort(NORTH).getPortType()];
    if(currentDirection == NORTH)
        portType = "----" + portType + "----";
    fill(blue);
    text(portType, 300, 50 );
    IntList portConnections = connectionsList.get(currentSpriteIndex).getPort(NORTH).getPortConnections();
    String pConnections = "";
    for(int i : portConnections){
        pConnections += directionNames[i] + "\n";
    }
    fill(green);
    textLeading(40);
    text(pConnections, 300, 80);

    // draw east type
    portType = typeNames[connectionsList.get(currentSpriteIndex).getPort(EAST).getPortType()];
    if(currentDirection == EAST)
        portType = "----" + portType + "----";
    fill(blue);
    text(portType, 500, 250 );
    portConnections = connectionsList.get(currentSpriteIndex).getPort(EAST).getPortConnections();
    pConnections = "";
    for(int i : portConnections){
        pConnections += directionNames[i] + "\n";
    }
    fill(green);
    textLeading(40);
    text(pConnections, 500, 280);

    // draw south type
    portType = typeNames[connectionsList.get(currentSpriteIndex).getPort(SOUTH).getPortType()];
    if(currentDirection == SOUTH)
        portType = "----" + portType + "----";
    fill(blue);
    text(portType, 300, 450 );
    portConnections = connectionsList.get(currentSpriteIndex).getPort(SOUTH).getPortConnections();
    pConnections = "";
    for(int i : portConnections){
        pConnections += directionNames[i] + "\n";
    }
    fill(green);
    textLeading(40);
    text(pConnections, 300, 480);

    // draw west type
    portType = typeNames[connectionsList.get(currentSpriteIndex).getPort(WEST).getPortType()];
    if(currentDirection == WEST)
        portType = "----" + portType + "----";
    fill(blue);
    text(portType, 100, 250 );
    portConnections = connectionsList.get(currentSpriteIndex).getPort(WEST).getPortConnections();
    pConnections = "";
    for(int i : portConnections){
        pConnections += directionNames[i] + "\n";
    }
    fill(green);
    textLeading(40);
    text(pConnections, 100, 280);
}

void keyPressed(){
    // switch sprite
    if(key == 'e'){
        currentSpriteIndex++;
        if( currentSpriteIndex >= tileSpritesSize )
            currentSpriteIndex = 0;
        connectionsList.get(currentSpriteIndex).printAllPorts();
    }
    if(key == 'q'){
        currentSpriteIndex--;
        if( currentSpriteIndex < 0)
            currentSpriteIndex = tileSpritesSize - 1;
        connectionsList.get(currentSpriteIndex).printAllPorts();
    }
    if(key == 'w'){
        // add connection
        connectionsList.get(currentSpriteIndex).getPort(currentDirection).addBlankConnection();
        connectionsList.get(currentSpriteIndex).printAllPorts();
    }
    if(key == 's'){
        // add connection
        connectionsList.get(currentSpriteIndex).getPort(currentDirection).popPortConnection();
        connectionsList.get(currentSpriteIndex).printAllPorts();
    }

    if(keyCode == RIGHT){
        currentDirection++;
        if( currentDirection >= 4 )
            currentDirection = 0;
    }
    if(keyCode == LEFT){
        currentDirection--;
        if( currentDirection < 0 )
            currentDirection = 3;
    }
    if(keyCode == UP){
        int portType = connectionsList.get(currentSpriteIndex).getPort(currentDirection).getPortType();
        portType++;
        if( portType < 0 ){
            portType = 2;
        }
        else if( portType > 2 ){
            portType = 0;
        }
        connectionsList.get(currentSpriteIndex).getPort(currentDirection).setPortType(portType);
        connectionsList.get(currentSpriteIndex).printAllPorts();
    }
    if(keyCode == DOWN){
        // cycle port connection
        int topPortConnection = connectionsList.get(currentSpriteIndex).getPort(currentDirection).getTopPortConnection();
        if( topPortConnection == ERROR ) return;
        topPortConnection++;
        if( topPortConnection >= 4){
            topPortConnection = 0;
        }

        connectionsList.get(currentSpriteIndex).getPort(currentDirection).setTopPortConnection(topPortConnection);
        connectionsList.get(currentSpriteIndex).printAllPorts();
    }
}

class Connections{
    Port[] ports;
    int connectionID;
    
    Connections(int connectionID){
        this.connectionID = connectionID;
        ports = new Port[4];
        for(int i=0; i < 4; i++)
            ports[i] = new Port();
    }

    public void printAllPorts(){
        println("Connection ID: " + connectionID);
        for(int i=0; i < 4; i++){
            println(ports[i]);
        }
        println("\n");
    }

    public Port getPort(int portDirection){
        if( !isPortDirectionValid(portDirection) )
            return null;

        return ports[portDirection];
    }

    private boolean isPortDirectionValid(int portDirection){
        if( portDirection < 0 || portDirection > 3 ){
            println("portDirection invalid");
            return false;
        }
        return true;
    }

    private boolean isPortTypeValid(int portType){
        if( portType < 0 || portType > 2 ){
            println("portType invalid");
            return false;
        }
        return true;
    }
}



class Port{
    int portType;
    IntList portConnections;

    Port(){
        this.portType = GRASS;
        portConnections = new IntList();
    }


    public void addBlankConnection(){
        if( portConnections.size() >= 4){
            println("Port has max connections");
            return;
        }

        portConnections.append(NORTH);
    }

    public void popPortConnection(){
        if( portConnections.size() <= 0){
            println("PortConnections is empty");
            return;
        }

        portConnections.remove(portConnections.size()-1);
    }

    public void setTopPortConnection(int newTopPortConnection){
        if( newTopPortConnection < 0 || newTopPortConnection >= 4){
            println("newTopPortConnection is out of bounds");
            return;
        }
        
        portConnections.set(portConnections.size()-1, newTopPortConnection);
    }

    public int getTopPortConnection(){
        if( portConnections.size() <= 0){
            println("PortConnections is empty");
            return ERROR;
        }

        return portConnections.get(portConnections.size()-1);
    }
    
    public void setPortType(int portType){
        this.portType = portType;
    }

    public int getPortType(){
        return this.portType;
    }

    public IntList getPortConnections(){
        return this.portConnections;
    }

    public String toString(){
        String portString = "[";
        for(int i : portConnections){
            portString += " " + directionNames[i] + " ";
        }
        portString += "]";
        return "Port -" + typeNames[portType] + "- " + portString;
    }
}