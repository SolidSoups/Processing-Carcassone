class GameController{
    ArrayList<Tile> tiles;

    // sprites
    PImage[] sprites;
    int spriteSize = 24;

    // cursor
    int selectedSpriteIndex;
    VectorInt snappedMousePosition;

    // input
    private boolean previewPlacement = false;
    private Tile previewTile;
    private boolean confirmPlacement = false;

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




    // Functionality

    void update(){
        // check current snappedMousePosition
        Vector mousePosition = new Vector(mouseX, mouseY);
        snappedMousePosition = mousePosition.snapToGrid();

        if(this.previewPlacement && this.confirmPlacement){
            placeTile();
            this.confirmPlacement = false;
            this.previewPlacement = false;
        }
    }

    void selectNewRandomSprite(){
        selectedSpriteIndex = int(random(0, spriteSize));
    }

    void placeTile(){
        // creation
        Tile newTile = new Tile(previewTile.getGridPosition(), sprites[selectedSpriteIndex]);
        previewTile = null;
        selectNewRandomSprite();

        this.tiles.add(newTile);
    }




    // Graphics

    public void render(){
        renderGraphics();
        renderUI();
    }
    
    public void renderGraphics(){
        for(Tile t : tiles){
            t.draw();
        }
        if(previewPlacement){
            previewTile.draw();
        }
    }





    // UI

    public void renderUI(){
        drawCursor();
        drawNextTile();
    }

    public void drawCursor(){
        if( !validTilePlacement(snappedMousePosition.returnGridPosition()))
            return;

        

        pushMatrix();
        pushStyle();
        
        translate(snappedMousePosition.x, snappedMousePosition.y);
        rectMode(CORNER);
        noStroke();
        fill(255, 120);
        rect(0, 0, TILE_SIZE, TILE_SIZE);
        
        popStyle();
        popMatrix();
    }

    public void drawNextTile(){
        // get bottom right corner location
        float boxDelta = 0.2;
        PVector boxSize = new PVector(height * boxDelta, height * boxDelta);
        PVector drawLoc = new PVector(width - boxSize.x, 0);
        float padding = height * boxDelta * 0.1;
        PVector frameSize = new PVector(boxSize.x-padding*2, boxSize.y-padding*2);

        pushMatrix();

        translate(drawLoc.x, drawLoc.y);
        fill(120, 120, 150);
        noStroke();
        rectMode(CORNER);
        rect(0, 0, boxSize.x, boxSize.y);
        translate(padding, padding);
        imageMode(CORNER);
        image(sprites[selectedSpriteIndex], 0, 0, frameSize.x, frameSize.y);

        popMatrix();
    }




    // input
    public void leftMousePressed(){
        VectorInt previewLocation = this.snappedMousePosition.returnGridPosition();

        if( !validTilePlacement(previewLocation) )
            return;

        previewTile = new Tile(previewLocation, sprites[selectedSpriteIndex]);
        this.previewPlacement = true;
    }

    public void rightMousePressed(){
        if( previewPlacement ){
            previewTile.rotateTile();
        }
    }



    // boolean methods
    boolean validTilePlacement(VectorInt gridPosition){
        // validity
        if( !hasNeighbours(gridPosition) ){
            return false;
        }
        for(Tile refTile : this.tiles){
            VectorInt refTile_position = refTile.getGridPosition();
            if( refTile_position.x == gridPosition.x && refTile_position.y == gridPosition.y ){
                return false;
            }
        }

        return true;
    }

    boolean hasNeighbours(VectorInt gridPosition){
        int[][] theFourHorsemen = {{-1,0}, {0,-1}, {1,0}, {0,1}};
        for(Tile t : tiles){
            VectorInt tPos = t.getGridPosition();
            for(int i = 0; i < 4; i++){
                int dX = (gridPosition.x + theFourHorsemen[i][0]);
                int dY = (gridPosition.y + theFourHorsemen[i][1]);
                if( tPos.x == dX && tPos.y == dY)
                    return true;
            }
        }

        return false;
    }
}