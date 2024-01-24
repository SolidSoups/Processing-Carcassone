class Tile{
    VectorInt gridPosition;
    color c;
    PImage sprite;

    // directions
    public final int NORTH = 0;
    public final int EAST  = 1;
    public final int SOUTH = 2;
    public final int WEST  = 3;
    int rotation = 0;

    //tint
    boolean addHighlight = false;

    public Tile(VectorInt gridPosition, PImage sprite){
        this.gridPosition = gridPosition;
        this.sprite = sprite;
        this.rotation = this.NORTH;
    }

    public Tile(VectorInt gridPosition, PImage sprite, int rotation){
        this.gridPosition = gridPosition;
        this.sprite = sprite;
        this.rotation = rotation;
    }



    public void draw(){
        VectorInt drawPosition = gridPosition.scaleToGrid();
        
        pushMatrix();
        translate(drawPosition.x + TILE_SIZE/2, drawPosition.y + TILE_SIZE/2);
        pushStyle();
        imageMode(CENTER);

        // change direction if needed
        rotate(rotation * HALF_PI);

        if( this.addHighlight )
            tint(170, 170, 170, 150);
        image(sprite, 0, 0, TILE_SIZE, TILE_SIZE);
        popStyle();
        popMatrix();
    }

    public VectorInt getGridPosition(){
        return this.gridPosition;
    }

    public int getRotation(){
        return this.rotation;
    }

    public void rotateTile(){
        if( rotation < 3 )
            rotation += 1;
        else
            rotation = 0;
    }

    public void addHighlight(){
        this.addHighlight = true;
    }
}