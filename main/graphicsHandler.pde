class GraphicsHandler{
    // Game Controller reference
    private GameController gc;

    public GraphicsHandler(GameController gc){
        this.gc = gc;
    }

    public void render(){
        renderTiles();
        if(gc.isPreviewingPlacement())
            renderPreviewTile();
    }

    private void renderTiles(){
        ArrayList<Tile> placedTiles = gc.getPlacedTiles();
        for(Tile t : placedTiles){
            t.draw();
        }
    }

    private void renderPreviewTile(){
        Tile previewTile = gc.getPreviewTile();
        previewTile.draw();
    }
}