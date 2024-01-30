class GraphicsHandler{
    // Game Controller reference
    private GameController gc;

    public GraphicsHandler(GameController gc){
        this.gc = gc;
    }

    public void Render(){
        RenderGridBounds();
        RenderTiles();
        if(gc.isPreviewingPlacement())
            RenderPreviewTile();
        
        RenderMouseGridLocation();
    }

    private void RenderTiles(){
        Tile[][] pt = gc.GetPlacedTilesArray();
        for(int x = 0; x < PLAY_AREA_SIZE.x; x++){
            for(int y = 0; y < PLAY_AREA_SIZE.y; y++){
                Tile tileToRender = pt[x][y];
                if( tileToRender == null ) continue;
                this.RenderTile(tileToRender.getSpriteID(), tileToRender.getRotation(), new VectorInt(x, y), false);
            }
        }
    }

    private void RenderPreviewTile(){
        this.RenderTile(gc.GetPreviewTileSpriteID(), gc.GetPreviewTileRotation(),  gc.GetPreviewTileGridPosition(), true);
    }

    private void RenderTile(int spriteID, int rotation, VectorInt gridLocation, boolean highlight){
        PImage      sprite          = gc.getTileSprite(spriteID);

        PVector drawLocation = new PVector(
            gridLocation.x * TILE_SIZE, 
            gridLocation.y * TILE_SIZE
        );
    
        pushMatrix();
        translate(
            targetMargin + TILE_SIZE/2, 
            targetMargin + TILE_SIZE/2);
        translate(
            drawLocation.x,
            drawLocation.y);
        pushStyle();
        imageMode(CENTER);

        // change direction if needed
        rotate(rotation * HALF_PI);

        if( highlight )
            tint(170, 170, 170, 150);
        image(
            sprite, 
            0, 0, 
            TILE_SIZE, TILE_SIZE );
        if(DEBUG_MODE){
            stroke(255,0,0);
            strokeWeight(2);
            line(0,0,0,-TILE_SIZE/2);
        }
        popStyle();
        popMatrix();
    }

    private void RenderGridBounds(){
        pushMatrix();
        translate(targetMargin, targetMargin);

        // draw a light gridmap with numbers
        for(int x = 0; x < PLAY_AREA_SIZE.x; x++){
            for(int y = 0; y < PLAY_AREA_SIZE.y; y++){
                noFill();
                strokeWeight(1);
                rect(
                    x*TILE_SIZE,
                    y*TILE_SIZE,
                    TILE_SIZE,
                    TILE_SIZE
                );
            }
        }
        
        // draw the boundaries
        noFill();
        stroke(255,0,0);
        strokeWeight(2);
        rect(0, 0, PLAY_AREA_SIZE.x*TILE_SIZE, PLAY_AREA_SIZE.y*TILE_SIZE);
        popMatrix();
    }

    private void RenderMouseGridLocation(){
        VectorInt mouseGridPosition = gc.MouseToGridPosition();
        pushStyle();
        fill(255,0,0);

        textAlign(TOP, BOTTOM);
        textSize(25);
        text(mouseGridPosition == null ? "null" : mouseGridPosition.toString(), mouseX + 20, mouseY + 40);

        popStyle();
    }
}