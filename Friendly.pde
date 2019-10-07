class FriendlyBullet extends Bullet{
    public FloatVector velocity, position;
    public FloatVector bulletSize = new FloatVector(15, 3);
    public float direction, size=6;
    public int onHitDamage = 1;
    
    public FriendlyBullet (FloatVector position, FloatVector velocity, float direction) {
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

class FriendlyMissile extends Missile{
    public FloatVector velocity, position;
    public float direction, maxSpeed = 10, speedDecay = 0.97, size=8;
    public Ship target;
    public int onHitDamage = 8;

    public FriendlyMissile (FloatVector position, FloatVector velocity, float direction, EnemyShip target) {
        super(position, velocity, direction, target);
        this.position = position;
        this.velocity = velocity;
        this.direction = direction;
        this.target = target;
    }

    public void update() {
        if(this.target != null){
            FloatVector differenceVector = this.position.subtract(this.target.position);
            this.direction = smoothTurn(this.direction, differenceVector, 0.8);
        }
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

class FriendlyShip extends Ship {
    public int upKeyPressed=-1,downKeyPressed=-1, leftKeyPressed=-1, rightKeyPressed=-1, gunKeyPressed=-1, missileKeyPressed=-1;
    public FloatVector position=new FloatVector(0, 0), velocity;
    public float direction=0, maxMovement = 7, size=60;
    public float spinDecay, velocityDecay;
    public int gunCooldown=0, gunFired=0, gunFireCooldown=45;
    public int missileCooldown=0, missileFired=0, missileFireCooldown=45;
    public PImage shipSprite = friendlyShipSprite;
    public int health = 100;


    public FriendlyShip (float velocityDecay, float spinDecay) {
        super(velocityDecay, spinDecay);
        this.velocity = new FloatVector(0, 0);
        this.position = new FloatVector(0, 0);
        this.velocityDecay = velocityDecay;
        this.spinDecay = spinDecay;
    }

    public boolean isUpKeyPressed() {
        if(this.upKeyPressed != -1)
            return true;
        return false;
    }
    
    public boolean isDownKeyPressed() {
        if(this.downKeyPressed != -1)
            return true;
        return false;
    }
    
    public boolean isLeftKeyPressed() {
        if(this.leftKeyPressed != -1)
            return true;
        return false;
    }
    
    public boolean isRightKeyPressed() {
        if(this.rightKeyPressed != -1)
            return true;
        return false;
    }

    public boolean isGunKeyPressed() {
        if(this.gunKeyPressed != -1)
            return true;
        return false;
    }

    public boolean isMissileKeyPressed() {
        if(this.missileKeyPressed != -1)
            return true;
        return false;
    }

    public void pressKey() {this.setKey(millis());}
    public void releaseKey() {this.setKey(-1);}
    public void setKey(int value){
        switch (keyCode) {
            case Keys.KEY_W:
                this.upKeyPressed = value;
                break;
            case Keys.KEY_S:
                this.downKeyPressed = value;
                break;
            case Keys.KEY_A:
                this.leftKeyPressed = value;
                break;
            case Keys.KEY_D:
                this.rightKeyPressed = value;
                break;
            case Keys.KEY_F:
                this.gunKeyPressed = value;
                break;
            case Keys.KEY_M:
                this.missileKeyPressed = value;
                break;
        }
    }

    public FriendlyBullet shootBullet() {
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
            new FloatVector(this.direction + 180, 10, true), 
            this.direction);
    }

    public FriendlyBullet spawnBullet(FloatVector position, FloatVector velocity, float direction) {
        return new FriendlyBullet(position, velocity, direction);
    }

    public FriendlyMissile shootMissile(EnemyShip target) {
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

    public FriendlyMissile spawnMissile(FloatVector position, FloatVector velocity, float direction, EnemyShip target) {
        return new FriendlyMissile(position, velocity, direction, target);
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

        float x, y;

        if(this.isLeftKeyPressed() ^ this.isRightKeyPressed())
        {
            if(this.isLeftKeyPressed())
            {
                x = -this.maxMovement;
            }  
            else
            {
                x = this.maxMovement;
            }
        }
        else{
            this.leftKeyPressed = -1;
            this.rightKeyPressed = -1;

            x = 0;
        }

        if(this.isUpKeyPressed() ^ this.isDownKeyPressed())
        {
            if(this.isUpKeyPressed())
            {
                y = -this.maxMovement;
            }  
            else
            {
                y = this.maxMovement;
            }
        }
        else{
            y = 0;
        }

        FloatVector accelerelation = new FloatVector(x, y).multiply(1 - this.velocityDecay);
        this.velocity = this.velocity.multiply(this.velocityDecay).add(accelerelation);
        this.position.addTo(this.velocity);

        FloatVector mouseVector = new FloatVector(mouseX, mouseY);
        FloatVector differenceVector = mouseVector.subtract(this.position);
        float newDirection = degrees(getAngleFromVector(differenceVector));
        this.direction = smoothTurn(this.direction, differenceVector, this.spinDecay);
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

    public void onHit(int damageTaken) {
        this.health -= damageTaken;
    }
}