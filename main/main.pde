GameController gc;

final int TILE_SIZE = 100;

void setup(){
    size(1000, 1000);

    gc = new GameController();
}

void draw(){
    background(0);

    gc.renderTiles();
}

void mousePressed(){
    if(mouseButton == LEFT){
        gc.mousePressed();
    }
}