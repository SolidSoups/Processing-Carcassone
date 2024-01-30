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

        if( gridMousePosition != null && gc.ValidTilePlacement(gridMousePosition) )
            drawHighlightedPlacement(gridMousePosition);
        
        drawNextTile();

        if( gc.isPreviewingPlacement() )
            drawConditionalButton();
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