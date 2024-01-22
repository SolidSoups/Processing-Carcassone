class GameController{
    ArrayList<Tile> tiles;

    // sprites
    PImage[] sprites;
    int spriteSize = 24;

    // cursor
    int selSpritIndex;
    VectorInt snappedMousePosition;

    public GameController(){
        tiles = new ArrayList<Tile>();
        sprites = new PImage[spriteSize];
        
        // initialize all spries
        for(int i = 0; i < spriteSize; i++){
            String s = str(i);
            while( s.length() < 2)
                s = "0" + s;
            sprites[i] = loadImage("resources/sprites/sprite_" + s + ".png"); // idk why these images are in png lol
        }
        selectNewRandomSprite();

        //add middle tile
        Vector middlePos = new Vector(width/2, height/2);
        VectorInt middleGridPos = middlePos.returnGridPos();
        Tile starterTile = new Tile(middleGridPos, sprites[14]);
        tiles.add(starterTile);
    }

    public void renderTiles(){
        // check current snappedMousePosition
        Vector mousePosition = new Vector(mouseX, mouseY);
        snappedMousePosition = mousePosition.snapToGrid();

        drawSelectedTile();
        for(Tile t : tiles){
            t.draw();
        }
        drawCursor();
    }

    public void drawSelectedTile(){
        pushMatrix();
        translate(snappedMousePosition.x, snappedMousePosition.y);
        imageMode(CORNER);
        image(sprites[selSpritIndex], 0, 0, TILE_SIZE, TILE_SIZE);
        popMatrix();
    }

    public void drawCursor(){
        pushMatrix();
        translate(snappedMousePosition.x, snappedMousePosition.y);
        rectMode(CORNER);
        noFill();
        stroke(255);
        strokeWeight(4);
        rect(0, 0, TILE_SIZE, TILE_SIZE);
        popMatrix();
    }

    void selectNewRandomSprite(){
        selSpritIndex = int(random(0, spriteSize));
    }

    public void mousePressed(){
        Vector mousePos = new Vector(mouseX, mouseY);
        VectorInt snappedMousePos = mousePos.returnGridPos();
        
        if( !hasNeighbours(snappedMousePos) ){
            println("Tile has no neighbours at location " + snappedMousePos);
            return;
        }

        for(Tile refTile : this.tiles){
            VectorInt refTile_position = refTile.getGridPosition();
            if( refTile_position.x == snappedMousePos.x && refTile_position.y == snappedMousePos.y ){
                println("Tile already exists at location " + refTile_position);
                return;
            }
        }

        Tile newTile = new Tile(snappedMousePos, sprites[selSpritIndex]);
        selectNewRandomSprite();

        this.tiles.add(newTile);
    }

    boolean hasNeighbours(VectorInt gridPosition){
        int[][] theFourHorsemen = {{-1,0}, {0,-1}, {1,0}, {0,1}};
        for(Tile t : tiles){
            VectorInt tPos = t.getGridPosition();
            for(int i = 0; i < 4; i++){
                int dX = (gridPosition.x + theFourHorsemen[i][0]);
                int dY = (gridPosition.y + theFourHorsemen[i][1]);
                println("Checking position (" + dX + ", " + dY + ")");
                if( tPos.x == dX && tPos.y == dY)
                    return true;
            }
        }

        return false;
    }
}