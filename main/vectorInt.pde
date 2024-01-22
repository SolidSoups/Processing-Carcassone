class VectorInt{
    public int x, y;

    VectorInt(int x, int y){
        this.x = x;
        this.y = y;
    }

    public PVector scaleToGrid(){
        float x = this.x * TILE_SIZE;
        float y = this.y * TILE_SIZE;
        return new PVector(x, y);
    }

    @Override
    public String toString(){
        return "(" + this.x + ", " + this.y + ")";
    }
}