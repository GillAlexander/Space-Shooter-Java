class Bullet extends Circle{
    public FloatVector velocity, position;
    public FloatVector bulletSize = new FloatVector(15, 3);
    public float direction, size=0f;
    
    public Bullet (FloatVector position, FloatVector velocity, float direction) {
        super(position, 0f);
        this.position = position;
        this.velocity = velocity;
        this.direction = direction;
    }

    public void update() {
        this.position.addTo(this.velocity);
    }

    public void draw() {
        translate(this.position.x, this.position.y);
        rotate(radians(this.direction));
        rectMode(CENTER);
        rect(0, 0, this.bulletSize.x, this.bulletSize.y);
        rotate(-radians(this.direction));
        translate(-this.position.x, -this.position.y);
    }

}

class Missile extends Circle{
    public FloatVector velocity, position;
    public float direction, maxSpeed = 10, speedDecay = 0.97, size=0f;
    public Ship target;
    public PImage missile = missileSprite;

    public Missile (FloatVector position, FloatVector velocity, float direction, Ship target) {
        super(position, 0f);
        this.position = position;
        this.velocity = velocity;
        this.direction = direction;
        this.target = target;
    }

    public void update() {
        FloatVector differenceVector = this.position.subtract(this.target.position);
        this.direction = smoothTurn(this.direction, differenceVector, 0.8);
        FloatVector newVector = new FloatVector(this.direction, maxSpeed, true).multiply(1 - this.speedDecay);
        this.velocity = this.velocity.multiply(this.speedDecay).add(newVector);
        this.position.addTo(this.velocity);
    }

    public void draw() { 
        translate(position.x, position.y);
        rotate(radians(direction));
        imageMode(CENTER);
        image(this.missile, 0, 0);
        rotate(-radians(direction));
        translate(-position.x, -position.y);
    }
}