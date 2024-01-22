class Vector extends PVector{
    Vector(float x, float y){
        super(x, y);
    }

    public VectorInt snapToGrid(){
        int x = int(this.x / TILE_SIZE) * TILE_SIZE;
        int y = int(this.y / TILE_SIZE) * TILE_SIZE;
        return new VectorInt(x, y);
    }

    public VectorInt returnGridPos(){
        int x = int(this.x / TILE_SIZE);
        int y = int(this.y / TILE_SIZE);
        return new VectorInt(x, y);
    }
}