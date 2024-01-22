class Tile{
    VectorInt gridPosition;
    color c;


    public Tile(VectorInt gridPosition){
        // randomizing tile color
        int r = int(random(0,255));
        int g = int(random(0,255));
        int b = int(random(0,255));

        c = color(r, g, b);

        this.gridPosition = gridPosition;
    }

    public void draw(){
        PVector drawPosition = gridPosition.scaleToGrid();

        pushMatrix();
        translate(drawPosition.x + TILE_SIZE/2, drawPosition.y + TILE_SIZE/2);
        rectMode(CENTER);
        fill(c);
        noStroke();
        rect(0, 0, TILE_SIZE, TILE_SIZE);
        popMatrix();
    }

    public VectorInt getGridPosition(){
        return this.gridPosition;
    }
}