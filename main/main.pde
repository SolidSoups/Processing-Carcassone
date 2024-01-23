GameController gc;

final int TILE_SIZE = 100;

void setup(){
    size(1500, 1000);

    gc = new GameController();
}

void draw(){
    background(0);

    gc.update();
    gc.render();
}

void mousePressed(){
    if(mouseButton == LEFT){
        gc.leftMousePressed();
    }
    if( mouseButton == RIGHT){
        gc.rightMousePressed();
    }
}