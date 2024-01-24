class GameController{
    ArrayList<Tile> placedTiles;

    // handlers
    GraphicsHandler gh;
    UIHandler uih;

    // sprites
    PImage[] sprites;
    int spriteSize = 24;
    int iSprite;

    // mouse position snapped to a grid
    private VectorInt snappedMousePos;

    // input
    private boolean isPreviewingPlacement = false;
    private boolean hasConfirmedPlacement = false;
    private Tile previewTile;



    // constructor
    public GameController(){
        placedTiles = new ArrayList<Tile>();
        sprites = new PImage[spriteSize];

        // init handlers
        gh = new GraphicsHandler(this);
        uih = new UIHandler(this);
        
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
        VectorInt middleGridPos = middlePos.returnGridPosition();
        Tile starterTile = new Tile(middleGridPos, sprites[14]);
        placedTiles.add(starterTile);
    }





    // main methods

    void update(){
        Vector mousePosition = new Vector(mouseX, mouseY);
        snappedMousePos = mousePosition.snapToGrid();

        if(this.isPreviewingPlacement && this.hasConfirmedPlacement){
            placeTile();
            clearPlacementFlags();
            selectNewRandomSprite();
        }
    }

    public void render(){
        gh.render();
        uih.render();
    }





    // Functionality

    void selectNewRandomSprite(){
        iSprite = int(random(0, spriteSize));
    }

    void placeTile(){
        Tile newTile = new Tile(previewTile.getGridPosition(), sprites[iSprite], previewTile.getRotation());
        this.placedTiles.add(newTile);
    }

    void clearPlacementFlags(){
        previewTile = null;
        this.hasConfirmedPlacement = false;
        this.isPreviewingPlacement = false;
    }



    // input

    public void leftMousePressed(){
        if( uih.isInsideUI() ){
            int buttonPressed = uih.leftMousePressed();
            if( buttonPressed == uih.CANCEL){
                clearPlacementFlags();
            }
            else if( buttonPressed == uih.CONFIRM){
                this.hasConfirmedPlacement = true;
            }
            return;
        }

        VectorInt previewLocation = this.snappedMousePos.returnGridPosition();

        if( !validTilePlacement(previewLocation) )
            return;

        previewTile = new Tile(previewLocation, sprites[iSprite]);
        previewTile.addHighlight();
        this.isPreviewingPlacement = true;
    }

    public void rightMousePressed(){
        if( isPreviewingPlacement ){
            previewTile.rotateTile();
        }
    }





    // boolean methods

    public boolean validTilePlacement(VectorInt gridPosition){
        // validity
        if( !hasNeighbours(gridPosition) ){
            return false;
        }
        for(Tile refTile : this.placedTiles){
            VectorInt refTile_position = refTile.getGridPosition();
            if( refTile_position.x == gridPosition.x && refTile_position.y == gridPosition.y ){
                return false;
            }
        }

        return true;
    }

    boolean hasNeighbours(VectorInt gridPosition){
        int[][] theFourHorsemen = {{-1,0}, {0,-1}, {1,0}, {0,1}};
        for(Tile t : placedTiles){
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





    // getters

    public ArrayList<Tile> getPlacedTiles(){
        return this.placedTiles;
    }

    public Tile getPreviewTile(){
        return this.previewTile;
    }

    public boolean isPreviewingPlacement(){
        return this.isPreviewingPlacement;
    }

    public VectorInt getSnappedMousePos(){
        return this.snappedMousePos;
    }

    public PImage getNextSprite(){
        return this.sprites[iSprite];
    }
}