class EnemyBullet extends Bullet{
    public FloatVector velocity, position;
    public FloatVector bulletSize = new FloatVector(15, 3);
    public float direction, size=6;
    public int onHitDamage = 1;
    
    public EnemyBullet (FloatVector position, FloatVector velocity, float direction) {
        super(position, velocity, direction);
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

class EnemyMissile extends Missile{
    public FloatVector velocity, position;
    public float direction, maxSpeed = 10, speedDecay = 0.97, size=8;
    public Ship target;
    public int onHitDamage = 4;
    public PImage missile = missileSprite;

    public EnemyMissile (FloatVector position, FloatVector velocity, float direction, FriendlyShip target) {
        super(position, velocity, direction, target);
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
        image(missile, 0, 0);
        rotate(-radians(direction));
        translate(-position.x, -position.y);
    }
}

class EnemyShip extends Ship {
    public float size=60;
    public PImage shipSprite = enemyShipSprite;
    public int health = 100;
    public boolean deleted = false;

    public EnemyShip (float velocityDecay, float spinDecay, FloatVector velocity) {
    	super(velocityDecay, spinDecay);
        this.velocity = velocity;
        this.position = new FloatVector(0, 0);
        this.velocityDecay = velocityDecay;
        this.spinDecay = spinDecay;
    }

    public EnemyBullet shootBullet() {
        if(millis() < this.gunCooldown) {
            return null;
        }

        FloatVector fireOffset;
        if(this.gunFired % 2 == 1)
            fireOffset = new FloatVector(this.direction + 60, 15, true);
        else
            fireOffset = new FloatVector(this.direction - 60, 15, true);

        this.gunCooldown = millis() + this.gunFireCooldown;
        this.gunFired++;

        return this.spawnBullet(
        	new FloatVector(this.position.x, this.position.y).add(fireOffset),
        	new FloatVector(this.direction, 10, true), 
            this.direction);
    }

    public EnemyBullet spawnBullet(FloatVector position, FloatVector velocity, float direction) {
    	return new EnemyBullet(position, velocity, direction);
    }

    public EnemyMissile shootMissile(FriendlyShip target) {
        if(millis() < this.missileCooldown) {
            return null;
        }

        FloatVector fireOffset;
        if(this.missileFired % 2 == 1)
            fireOffset = new FloatVector(this.direction + 80, 20, true);
        else
            fireOffset = new FloatVector(this.direction - 80, 20, true);

        this.missileCooldown = millis() + this.missileFireCooldown;
        this.missileFired++;

        return this.spawnMissile(
        	new FloatVector(this.position.x, this.position.y).add(fireOffset),
        	new FloatVector(this.direction + 180, 20, true), 
            this.direction + 180,
            target);
    }

    public EnemyMissile spawnMissile(FloatVector position, FloatVector velocity, float direction, FriendlyShip target) {
    	return new EnemyMissile(position, velocity, direction, target);
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

    public void update() {
        while(this.position.x < 0 || this.position.x > width) {    
            if(this.position.x < 0)
                this.position.x += width;
            if(this.position.x > width)
                this.position.x -= width;
        }
        while(this.position.y < 0 || this.position.y > width) {
            if(this.position.y < 0)
                this.position.y += width;
            if(this.position.y > width)
                this.position.y -= width;
        }

        this.position.addTo(this.velocity);
    }

    public void updateToPlayer(FriendlyShip player) {
    	FloatVector differenceVector = this.position.subtract(player.position);
        this.direction = this.direction * 0.9 + 0.1 * degrees(getAngleFromVector(differenceVector));
    }

    public void onHit(int damageTaken) {
        this.health -= damageTaken;
    }
}