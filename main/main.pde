GameController gc;

final int TILE_SIZE = 100;

void setup(){
    size(1000, 1000);

    gc = new GameController();
    gc.addTile(new Tile(new VectorInt(2, 5)));
}

void draw(){
    background(0);

    gc.renderTiles();
}

void mousePressed(){
    if(mouseButton == LEFT){
        Vector mousePos = new Vector(mouseX, mouseY);
        VectorInt snappedMousePos = mousePos.returnGridPos();
        
        gc.addTile(new Tile(snappedMousePos));
    }
}