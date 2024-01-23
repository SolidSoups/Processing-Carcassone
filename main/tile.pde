class Tile{
    VectorInt gridPosition;
    color c;
    PImage sprite;

    // directions
    public final int NORTH = 0;
    public final int EAST  = 1;
    public final int SOUTH = 2;
    public final int WEST  = 3;
    public final int[] directions = {this.NORTH, this.EAST, this.SOUTH, this.WEST};
    int selectedDirectionIndex = 0;


    public Tile(VectorInt gridPosition, PImage sprite){
        // randomizing tile color
        int r = int(random(0,255));
        int g = int(random(0,255));
        int b = int(random(0,255));

        c = color(r, g, b);

        this.gridPosition = gridPosition;
        this.sprite = sprite;
    }



    public void draw(){
        PVector drawPosition = gridPosition.scaleToGrid();
        
        pushMatrix();
        translate(drawPosition.x + TILE_SIZE/2, drawPosition.y + TILE_SIZE/2);
        pushStyle();
        imageMode(CENTER);

        // change direction if needed
        float rotation = directions[selectedDirectionIndex] * HALF_PI;
        rotate(rotation);

        image(sprite, 0, 0, TILE_SIZE, TILE_SIZE);
        popStyle();
        popMatrix();
    }

    public VectorInt getGridPosition(){
        return this.gridPosition;
    }

    public void rotateTile(){
        if( selectedDirectionIndex < (directions.length - 1) )
            selectedDirectionIndex += 1;
        else
            selectedDirectionIndex = 0;
    }
}