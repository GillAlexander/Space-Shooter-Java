class Ship extends Circle {
    public FloatVector position=new FloatVector(0, 0), velocity;
    public float direction=0, maxMovement = 7, size=60f;
    public float spinDecay, velocityDecay;
    public int gunCooldown=0, gunFired=0, gunFireCooldown=45;
    public int missileCooldown=0, missileFired=0, missileFireCooldown=45;
    public PImage shipSprite = loadImage("data/SpaceShip.png");

    public Ship (float velocityDecay, float spinDecay) {
        super(new FloatVector(0, 0), 8);
        this.velocity = new FloatVector(0, 0);
        this.position = new FloatVector(0, 0);
        this.velocityDecay = velocityDecay;
        this.spinDecay = spinDecay;
    }

    public void draw() {
        FloatVector widthVector = new FloatVector(width, 0);
        FloatVector heightVector = new FloatVector(0, height);

        for(int i=-1; i < 2; i++)
            for(int j=-1; j < 2; j++)
                this.draw_spaceship(
                    this.position.add(
                        widthVector.multiply(i).add(heightVector.multiply(j))
                    ), 
                    this.direction);
    }

    private void draw_spaceship(FloatVector position, float rotation) {
        translate(position.x, position.y);
        rotate(radians(direction - 90));
        imageMode(CENTER);
        image(this.shipSprite, 0, 0);
        rotate(-radians(direction - 90));
        translate(-position.x, -position.y);
    }

    public void update() {}
}