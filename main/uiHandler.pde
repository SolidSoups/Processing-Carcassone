class UIHandler{
    // GameController reference
    GameController gc_ref;

    // color scheme
    color grayColor = color(90, 90, 110);
    color grayColorOpaque = color(90,90,110,200);

    // conditinoal button positions
    PVector buttonCancelPosition;
    PVector buttonConfirmPosition;

    // conditional button parameters
    PVector buttonBoxSize   = new PVector(width*0.05f, height*0.16);
    float   padding           = buttonBoxSize.x*0.25f;
    float   boxRadius         = buttonBoxSize.x*0.5f;
    float   buttonRadius      = boxRadius*0.75f;
    PVector drawLoc         = new PVector(width - (padding + buttonBoxSize.x), height - (padding + buttonBoxSize.y));

    // input
    boolean leftMousePressed = false;

    // finals
    final int CANCEL    = 0;
    final int CONFIRM   = 1;
    final int NONE      = 3;
    
    



    // CONSTRUCTOR
    public UIHandler(GameController gc_ref){
        this.gc_ref = gc_ref;

        
        buttonCancelPosition = new PVector(drawLoc.x + boxRadius, drawLoc.y + boxRadius);
        buttonConfirmPosition = new PVector(drawLoc.x + boxRadius, drawLoc.y + buttonBoxSize.y - boxRadius);
    }

    // MAIN METHOD
    public void Render(){
        VectorInt gridMousePosition = gc_ref.MouseToGridPosition();

        if( gridMousePosition != null && gc_ref.IsValidTilePlacement(gridMousePosition) )
            drawHighlightedPlacement(gridMousePosition);
        
        drawNextTile();

        if( gc_ref.isPreviewingMove() ){
            drawConditionalButton();
        }

        if(DEBUG_DECK_DISTRIBUTION) {
            drawTileDistribution();
        if(DEBUG_TILE_PROPERTIES)
            drawMoveVariables();
        }
    }



    // DRAW METHODS

    private void drawHighlightedPlacement(VectorInt gridMousePosition){
        pushMatrix();
        pushStyle();
        
        translate(targetMargin, targetMargin);
        rectMode(CORNER);
        noStroke();
        fill(255, 120);
        rect(gridMousePosition.x*TILE_SIZE, gridMousePosition.y*TILE_SIZE, TILE_SIZE, TILE_SIZE);
        
        popStyle();
        popMatrix();
    }

    private void drawNextTile(){
        // get bottom right corner location
        float boxDelta = 0.2;
        float boxSize = height * boxDelta;
        PVector drawLoc = new PVector(width - boxSize, 0);
        float padding = height * boxDelta * 0.1;
        PVector frameSize = new PVector(boxSize-padding*2, boxSize-padding*2);

        pushMatrix();

        translate(drawLoc.x, drawLoc.y);

        fill(grayColor);
        stroke(30);
        strokeWeight(2);
        rectMode(CORNER);
        rect(0, 0, boxSize, boxSize, 0, 0, 0, 15);

        translate(padding, padding);
        imageMode(CORNER);
        image(gc_ref.getNextSprite(), 0, 0, frameSize.x, frameSize.y);
        
        popMatrix();
    }

    private void drawConditionalButton(){

        fill(grayColor);
        stroke(30);
        strokeWeight(2);
        rectMode(CORNER);
        rect(drawLoc.x, drawLoc.y, buttonBoxSize.x, buttonBoxSize.y);

        ellipseMode(RADIUS);
        
        if( IsInsideButton(this.CANCEL) )
            fill(220, 100, 100);
        else
            fill(255, 100, 100);
        ellipse(buttonCancelPosition.x, buttonCancelPosition.y, buttonRadius, buttonRadius);

        if( IsInsideButton(this.CONFIRM) )
            fill(100, 220, 100);
        else   
            fill(100, 255, 100);
        ellipse(buttonConfirmPosition.x, buttonConfirmPosition.y, buttonRadius, buttonRadius);
    }



    // DEBUG

    private void drawTileDistribution(){
        IntDict     tileDistr           = gc_ref.get_tileDistribution();
        String[]    tileDistr_keys      = tileDistr.keyArray();
        int[]       tileDistr_values    = tileDistr.valueArray();

        IntList tileDistr_keys_list = new IntList();
        IntList tileDistr_values_list = new IntList();
        for(int i=0; i<tileDistr.size(); i++){
            tileDistr_keys_list.append(int(tileDistr_keys[i]));
            tileDistr_values_list.append(int(tileDistr_values[i]));
        }


        float   margin = 50;
        PVector boxSize = new PVector(200, 640);
        PVector controlPosition = new PVector(20, 260);

        pushMatrix();
        pushStyle();

        translate(controlPosition.x, controlPosition.y);

        fill(grayColorOpaque);
        stroke(255,0,0);
        rect(0, 0, boxSize.x, boxSize.y);

        translate(20,30);

        textSize(20);
        textAlign(BOTTOM, TOP);
        textLeading(25);

        fill(0,255,200);
        
        text("Count: " + gc_ref.GetDistributionCount() + "   D: " + gc_ref.get_discardCount(), 0, -20);
        
        int prevKey = -1;
        for(int i=0; i<tileDistr_keys_list.size(); i++){
            int key = tileDistr_keys_list.get(i);
            int value = tileDistr_values_list.get(i);

            if(key == gc_ref.get_nextSpriteID())
                fill(255,0,0);
            else
                fill(0,255,0);

            if(key != (prevKey+1)){
                if((prevKey+1) == gc_ref.get_nextSpriteID()){
                    fill(255,0,0);
                    text("ID: " + (prevKey+1),  0,      i*25);
                    text("0",                   120,    i*25);
                    fill(0,255,0);
                }
                translate(0,25);
            }
            
            text("ID: " + key,  0,      i*25);
            text(value,         120,    i*25);
            
            prevKey = key;
        }

        popStyle();
        popMatrix();
    }

    private void drawMoveVariables(){
        int spriteID = gc_ref.get_nextSpriteID();
        VectorInt gridPosition = gc_ref.get_moveGridPosition();
        int tileRotation = gc_ref.get_moveRotation();
        int[] mainFaces = gc_ref.FetchTileData(spriteID).get_portTypes();
        int[] surroundingFaces = gc_ref.CalculateNeighbouringFaces(gridPosition);
        IntList correctTileRotations = gc_ref.get_moveValidRotations();
        int correctTileRotationsIndex = gc_ref.get_moveValidRotationsIndex();
        
        
        pushMatrix();
        pushStyle();
        textAlign(TOP, CENTER);

        translate(20, 20);

        fill(120,120,120,120);
        stroke(255,0,0);
        strokeWeight(2);
        rect(0,0,440,230);

        translate(20,20);

        fill(120,255,120);
        textSize(20);

        // sprite id
        text("Sprite ID: " + spriteID, 0, 0);
        translate(0,25);

        // grid position
        text("Grid position: " + gridPosition, 0, 0);
        translate(0,25);
        
        // tile rotation
        text("Tile Rotation: " + Orientation.values()[tileRotation], 0, 0);
        translate(0,40);
        
        // main faces
        String s = "null";
        s = "[ " + PortType.values()[mainFaces[0]];
        for(int i=1; i<mainFaces.length; i++){
            s += ", " + PortType.values()[mainFaces[i]];
        }
        s += " ]";
        text("Main faces: " + s, 0, 0);
        translate(0,25);
        
        // surrounding faces
        s = "null";
        if(surroundingFaces != null){
            s = "[ " + PortType.values()[(surroundingFaces[0])];
            for(int i=1; i<surroundingFaces.length; i++){
                s += ", " + PortType.values()[surroundingFaces[i]];
            }
            s += " ]";
        }
        text("Surrounding faces: " + s, 0, 0);
        translate(0,40);
        
        // correct rotations
        s = "null";
        if( correctTileRotations.size() != 0 ){
            s = "[ " + Orientation.values()[correctTileRotations.get(0)];
            for(int i=1; i<correctTileRotations.size(); i++){
                s += ", " + Orientation.values()[correctTileRotations.get(i)];
            }
            s += " ]";
        }
        text("Correct rotations: " + s, 0, 0);
        translate(0,25);
        
        // correct rotation index
        text("Correct rotations index: " + correctTileRotationsIndex, 0, 0);
        translate(0,25);
        




        popStyle();
        popMatrix();
    }

    





    // BUTTON CONTROL

    private boolean IsInsideButton(int button){
        PVector mousePosition = new PVector(mouseX, mouseY);
        PVector differensVector;
        if( gc_ref.isPreviewingMove() ){
            if( button == this.CANCEL )
                differensVector = PVector.sub(buttonCancelPosition, mousePosition);
            else if( button == this.CONFIRM ){
                differensVector = PVector.sub(buttonConfirmPosition, mousePosition);
            }
            else return false;
        }
        else return false;


        float magnitude = differensVector.mag();

        if( magnitude > buttonRadius)
            return false;

        return true;
    }

    public boolean IsInsideUI(){
        // check button
        PVector mousePos = new PVector(mouseX, mouseY);
        PVector buttonPanelMax = new PVector(drawLoc.x + buttonBoxSize.x, drawLoc.y + buttonBoxSize.y);

        if( mousePos.x >= drawLoc.x && mousePos.y >= drawLoc.y &&
        mousePos.x <= buttonPanelMax.x && mousePos.y <= buttonPanelMax.y)
            return true;
        
        return false;
    }

    public int LeftMousePressed(){
        this.leftMousePressed = true;
        if( IsInsideButton(this.CANCEL) )
            return this.CANCEL;
        else if( IsInsideButton(this.CONFIRM) )
            return this.CONFIRM;
        else
            return this.NONE;
    }
}