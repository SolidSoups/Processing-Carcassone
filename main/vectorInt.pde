class VectorInt{
    public int x, y;

    VectorInt(int x, int y){
        this.x = x;
        this.y = y;
    }

    public VectorInt returnGridPosition(){
        int x = int(this.x / TILE_SIZE);
        int y = int(this.y / TILE_SIZE);
        return new VectorInt(x, y);
    }
    
    public VectorInt scaleToGrid(){
        int x = int(this.x * TILE_SIZE);
        int y = int(this.y * TILE_SIZE);
        return new VectorInt(x, y);
    }
    
    public VectorInt asNew(){
        return new VectorInt(this.x, this.y);
    }

    // OPERATIONS

    public VectorInt mult(int d){
        this.x = this.x * d;
        this.y = this.y * d;
        return this;
    }

    public VectorInt mult(float d){
        this.x = int(this.x * d);
        this.y = int(this.y * d);
        return this;
    }

    public VectorInt div(int d){
        this.x = this.x / d;
        this.y = this.y / d;
        return this;
    }

    public VectorInt div(float d){
        this.x = int(this.x / d);
        this.y = int(this.y / d);
        return this;
    }
    
    @Override
    public String toString(){
        return "(" + this.x + ", " + this.y + ")";
    }
}