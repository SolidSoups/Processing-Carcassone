class GraphicsHandler{
    // Game Controller reference
    private GameController gc_ref;




    // CONSTRUCTOR
    public GraphicsHandler(GameController gc_ref){
        this.gc_ref = gc_ref;
    }




    // MAIN METHOD
    public void Render(){
        if(DEBUG_MODE){
            RenderGridBounds();
            RenderPossiblePlacements();
        } 
        RenderTiles();
        if(gc_ref.isPreviewingMove())
            RenderPreviewTile();
        
        if(DEBUG_MODE)
            RenderMouseGridLocation();
        if(DEBUG_ROAD_FEATURES)
            RenderCheckedFeatures();
    }






    // RENDER METHODS

    private void RenderTiles(){
        Tile[][] pt = gc_ref.get_placedTiles();
        for(int x = 0; x < PLAY_AREA_SIZE.x; x++){
            for(int y = 0; y < PLAY_AREA_SIZE.y; y++){
                Tile tileToRender = pt[x][y];
                if( tileToRender == null ) continue;
                this.RenderTile(tileToRender.get_spriteID(), tileToRender.get_rotation(), new VectorInt(x, y), false);
            }
        }
    }

    private void RenderPreviewTile(){
        this.RenderTile(gc_ref.get_nextSpriteID(), gc_ref.get_moveRotation(),  gc_ref.get_moveGridPosition(), true);
    }

    private void RenderTile(int spriteID, int rotation, VectorInt gridLocation, boolean highlight){
        PImage      sprite          = gc_ref.FetchTileSprite(spriteID);

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



    // DEBUG RENDER METHODS

    private void RenderCheckedFeatures(){
        ArrayList<Tile> tiles = gc_ref.get_connectedTiles();
        if(tiles==null) return;
        
        pushMatrix();
        translate(targetMargin + TILE_SIZE/2, targetMargin + TILE_SIZE/2);
        for(Tile d : tiles){
            VectorInt gridPos = d.get_gridPosition();
            pushMatrix();
            translate(gridPos.x * TILE_SIZE, gridPos.y * TILE_SIZE);
            fill(255,255,0);
            ellipseMode(RADIUS);
            ellipse(0,0, TILE_SIZE*0.1f, TILE_SIZE*0.1f);
            popMatrix();
        }
        popMatrix();
    }

    private void RenderPossiblePlacements(){
        pushMatrix();
        translate(targetMargin + TILE_SIZE/2, targetMargin + TILE_SIZE/2);

        pushStyle();
        noStroke();


        rectMode(CENTER);
        textAlign(CENTER, CENTER);
        textSize(20);
        for(int i=0; i<gc_ref.get_validMoves().size(); i++){
            VectorInt v = gc_ref.get_validMoves().get(i);
            PVector drawPosition = new PVector(v.x * TILE_SIZE, v.y * TILE_SIZE);
            fill(200,100,100);
            rect(drawPosition.x, drawPosition.y, TILE_SIZE/2, TILE_SIZE/2);
            fill(0);
            text(gc_ref.get_validRotations().get(i), drawPosition.x, drawPosition.y);
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
        VectorInt mouseGridPosition = gc_ref.MouseToGridPosition();
        pushStyle();
        fill(255,0,0);

        textAlign(TOP, BOTTOM);
        textSize(25);
        text(mouseGridPosition == null ? "null" : mouseGridPosition.toString(), mouseX + 20, mouseY + 40);

        popStyle();
    }
}