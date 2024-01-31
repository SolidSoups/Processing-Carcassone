class UIHandler{
    // GameController reference
    GameController gc;


    // color scheme
    color grayBoxing = color(90, 90, 110);

    // locations of button controls
    PVector buttonCancelLoc;
    PVector buttonConfirmLoc;

    // leftMouseDown
    boolean leftMousePressed = false;

    // references
    final int CANCEL = 0;
    final int CONFIRM = 1;
    final int NONE = 3;
    
    // conditional button parameters
    PVector buttonBoxSize   = new PVector(width*0.05f, height*0.16);
    float padding           = buttonBoxSize.x*0.25f;
    float boxRadius         = buttonBoxSize.x*0.5f;
    float buttonRadius      = boxRadius*0.75f;
    PVector drawLoc         = new PVector(width - (padding + buttonBoxSize.x), height - (padding + buttonBoxSize.y));

    public UIHandler(GameController gc){
        this.gc = gc;

        
        buttonCancelLoc = new PVector(drawLoc.x + boxRadius, drawLoc.y + boxRadius);
        buttonConfirmLoc = new PVector(drawLoc.x + boxRadius, drawLoc.y + buttonBoxSize.y - boxRadius);
    }


    public void Render(){
        VectorInt gridMousePosition = gc.MouseToGridPosition();

        if( gridMousePosition != null && gc.IsValidTilePlacement(gridMousePosition) )
            drawHighlightedPlacement(gridMousePosition);
        
        drawNextTile();

        if( gc.isPreviewingPlacement() ){
            drawConditionalButton();
            if( DEBUG_MODE )
                drawPreviewVariables();
        }

    }

    private void drawPreviewVariables(){
        int spriteID = gc.GetPreviewTileSpriteID();
        VectorInt gridPosition = gc.GetPreviewTileGridPosition();
        int tileRotation = gc.GetPreviewTileRotation();
        int[] mainFaces = gc.getTileData(spriteID).getPortTypes();
        int[] surroundingFaces = gc.RetrieveSurroundingFaceTypes(gridPosition);
        IntList correctTileRotations = gc.GetPreviewTileCorrectTileRotations();
        int correctTileRotationsIndex = gc.GetPreviewTileCorrectTileRotationsIndex();
        
        
        pushMatrix();
        pushStyle();
        textAlign(TOP, CENTER);

        translate(20, 20);

        fill(120,120,120,120);
        stroke(255,0,0);
        strokeWeight(2);
        rect(0,0,440,215);

        translate(20,20);

        fill(255,0,0);
        textSize(20);

        text("Sprite ID: " + spriteID, 0, 0);
        text("Grid position. " + gridPosition, 0, 25);
        text("Tile Rotation: " + DIRECTION_NAMES[tileRotation], 0, 50);

        String s = "null";
        s = "[ " + TYPE_NAMES[mainFaces[0]];
        for(int i=1; i<mainFaces.length; i++){
            s += ", " + TYPE_NAMES[mainFaces[i]];
        }
        s += " ]";
        text("Main faces: " + s, 0, 75);

        s = "null";
        s = "[ " + TYPE_NAMES[surroundingFaces[0]];
        for(int i=1; i<surroundingFaces.length; i++){
            s += ", " + TYPE_NAMES[surroundingFaces[i]];
        }
        s += " ]";
        text("Surrounding faces: " + s, 0, 100);

        s = "null";
        if( correctTileRotations != null ){
            s = "[ " + DIRECTION_NAMES[correctTileRotations.get(0)];
            for(int i=1; i<correctTileRotations.size(); i++){
                s += ", " + DIRECTION_NAMES[correctTileRotations.get(i)];
            }
            s += " ]";
        }
        text("Correct rotations: " + s, 0, 125);

        text("Correct rotations index: " + correctTileRotationsIndex, 0, 150);




        popStyle();
        popMatrix();
    }

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

        fill(grayBoxing);
        stroke(30);
        strokeWeight(2);
        rectMode(CORNER);
        rect(0, 0, boxSize, boxSize, 0, 0, 0, 15);

        translate(padding, padding);
        imageMode(CORNER);
        image(gc.getNextSprite(), 0, 0, frameSize.x, frameSize.y);
        
        popMatrix();
    }

    private void drawConditionalButton(){

        fill(grayBoxing);
        stroke(30);
        strokeWeight(2);
        rectMode(CORNER);
        rect(drawLoc.x, drawLoc.y, buttonBoxSize.x, buttonBoxSize.y);

        ellipseMode(RADIUS);
        
        if( isInsideButton(this.CANCEL) )
            fill(220, 100, 100);
        else
            fill(255, 100, 100);
        ellipse(buttonCancelLoc.x, buttonCancelLoc.y, buttonRadius, buttonRadius);

        if( isInsideButton(this.CONFIRM) )
            fill(100, 220, 100);
        else   
            fill(100, 255, 100);
        ellipse(buttonConfirmLoc.x, buttonConfirmLoc.y, buttonRadius, buttonRadius);
    }

    private boolean isInsideButton(int button){
        PVector mousePosition = new PVector(mouseX, mouseY);
        PVector differensVector;
        if( gc.isPreviewingPlacement() ){
            if( button == this.CANCEL )
                differensVector = PVector.sub(buttonCancelLoc, mousePosition);
            else if( button == this.CONFIRM ){
                differensVector = PVector.sub(buttonConfirmLoc, mousePosition);
            }
            else return false;
        }
        else return false;


        float magnitude = differensVector.mag();

        if( magnitude > buttonRadius)
            return false;

        return true;
    }

    public boolean isInsideUI(){
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
        if( isInsideButton(this.CANCEL) )
            return this.CANCEL;
        else if( isInsideButton(this.CONFIRM) )
            return this.CONFIRM;
        else
            return this.NONE;
    }

    // getters
    public PVector getCancelButtonLocation(){
        return this.buttonCancelLoc;
    }
    
    public PVector getConfirmButtonLocation(){
        return this.buttonConfirmLoc;
    }
}