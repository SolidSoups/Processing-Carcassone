class GameController{
    ArrayList<Tile> tiles;

    public GameController(){
        tiles = new ArrayList<Tile>();
    }

    public void renderTiles(){
        for(Tile t : tiles){
            t.draw();
        }

        drawMouse();
    }

    public void drawMouse(){
        Vector mousePosition = new Vector(mouseX, mouseY);
        VectorInt snappedMousePosition = mousePosition.snapToGrid();

        pushMatrix();
        translate(snappedMousePosition.x, snappedMousePosition.y);
        rectMode(CORNER);
        noFill();
        stroke(255);
        strokeWeight(4);
        rect(0, 0, TILE_SIZE, TILE_SIZE);
        popMatrix();
    }

    public void addTile(Tile newTile){
        VectorInt newTile_position = newTile.getGridPosition();
        for(Tile refTile : this.tiles){
            VectorInt refTile_position = refTile.getGridPosition();
            if( refTile_position.x == newTile_position.x && refTile_position.y == newTile_position.y ){
                println("Tile already exists at location " + refTile_position);
                return;
            }
        }


        this.tiles.add(newTile);
    }
}