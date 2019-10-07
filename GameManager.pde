enum Difficulty {
    EASY, MEDIUM, HARD
}

enum GameState {
    INTRO, PLAYING, GAME_OVER
}

class Keys {

    //Controls
    public static final int KEY_W = 87;
    public static final int KEY_S = 83;
    public static final int KEY_A = 65;
    public static final int KEY_D = 68;

    //Utilities
    public static final int KEY_F = 70;
    public static final int KEY_M = 77;
    public static final int KEY_P = 80;

    private Keys () {}

}

public class GameManager {
	public Difficulty choosenDifficulty = Difficulty.EASY;
	public GameState currentGameState = GameState.PLAYING;
	public boolean paused = false;
	public boolean escapeReleased = true;

	public FriendlyShip friendlyShip;
	public List<FriendlyBullet> friendlyBullets = new ArrayList<FriendlyBullet>();
	public List<FriendlyMissile> friendlyMissiles = new ArrayList<FriendlyMissile>();

	public List<EnemyShip> enemyShips = new ArrayList<EnemyShip>();
	public List<EnemyBullet> enemyBullets = new ArrayList<EnemyBullet>();
	public List<EnemyMissile> enemyMissiles = new ArrayList<EnemyMissile>();

	public GameManager (FriendlyShip participant) {
		this.friendlyShip = participant;
	}

	public void update(){
		for (int i=0; i < this.friendlyBullets.size(); i++) {
			this.friendlyBullets.get(i).update();
		}

		for (int i=0; i < this.friendlyMissiles.size(); i++) {
			this.friendlyMissiles.get(i).update();
		}

		this.friendlyShip.update();
		if(this.friendlyShip.isGunKeyPressed())
		{
        	FriendlyBullet friendlyBullet = this.friendlyShip.shootBullet();
        	if(friendlyBullet != null)
            	this.friendlyBullets.add(friendlyBullet);
		}

        if(this.friendlyShip.isMissileKeyPressed()){
        	EnemyShip closestShip = null;

			for (int f=0; f < this.enemyShips.size(); f++) {
				EnemyShip enemyShip = this.enemyShips.get(f);
				
				if(closestShip == null)
					closestShip = enemyShip;
				
				FloatVector differenceVector = this.friendlyShip.position.subtract(enemyShip.position);
				if(abs(getShortestTurn(this.friendlyShip.direction, differenceVector)) > 40)
					if(!closestShip.position.isEqual(enemyShip.position))
						closestShip = enemyShip;
		}

		FriendlyMissile friendlyMissile = this.friendlyShip.shootMissile(closestShip);
    	if(friendlyMissile != null)
   		 	this.friendlyMissiles.add(friendlyMissile);
		}
		

		for (int i=0; i < this.enemyBullets.size(); i++) {
			this.enemyBullets.get(i).update();
		}

		for (int i=0; i < this.enemyMissiles.size(); i++) {
			this.enemyMissiles.get(i).update();
		}

		for (int l=0; l < this.enemyShips.size(); l++) {
			EnemyShip enemyShip = this.enemyShips.get(l);
			enemyShip.update();

			boolean shouldFire = false;

			FloatVector differenceVector = enemyShip.position.subtract(this.friendlyShip.position);
			if(abs(getShortestTurn(enemyShip.direction, differenceVector)) < 10)
				shouldFire = true;
			
			if(shouldFire)
			{
            	EnemyBullet enemyBullet = enemyShip.shootBullet();
            	if(enemyBullet != null) //&& this.enemyBullets.size() < 1)
            		this.enemyBullets.add(enemyBullet);
			}

			enemyShip.updateToPlayer(this.friendlyShip);

			List<EnemyBullet> enemyBulletsToDelete = new ArrayList<EnemyBullet>();
		for (EnemyBullet enemyBullet : this.enemyBullets) {
			if(this.friendlyShip.collisionWith(friendlyShip.position, enemyBullet, friendlyShip.size, enemyBullet.size)) {
				this.friendlyShip.onHit(enemyBullet.onHitDamage);
				enemyBulletsToDelete.add(enemyBullet);
			}
		}
		if(enemyBulletsToDelete.size() > 0)
			this.enemyBullets.removeAll(enemyBulletsToDelete);

		List<EnemyMissile> enemyMissileToDelete = new ArrayList<EnemyMissile>();
		for (EnemyMissile enemyMissile : this.enemyMissiles) {
			if(this.friendlyShip.collisionWith(friendlyShip.position, enemyMissile, friendlyShip.size, enemyMissile.size)) {
				this.friendlyShip.onHit(enemyMissile.onHitDamage);
				enemyMissileToDelete.add(enemyMissile);
			}
		}
		if(enemyMissileToDelete.size() > 0)
			this.enemyMissiles.removeAll(enemyMissileToDelete);

		for(EnemyShip enemyShipToCheck : this.enemyShips)
		{
			List<FriendlyBullet> friendlyBulletsToDelete = new ArrayList<FriendlyBullet>();
			for (FriendlyBullet friendlyBullet : this.friendlyBullets) {
				if(enemyShipToCheck.collisionWith(enemyShipToCheck.position, friendlyBullet, enemyShipToCheck.size, friendlyBullet.size)) {
					enemyShipToCheck.onHit(friendlyBullet.onHitDamage);
					friendlyBulletsToDelete.add(friendlyBullet);
				}
			}
			if(friendlyBulletsToDelete.size() > 0)
				this.friendlyBullets.removeAll(friendlyBulletsToDelete);

			List<FriendlyMissile> friendlyMissilesToDelete = new ArrayList<FriendlyMissile>();
			for (FriendlyMissile friendlyMissile : this.friendlyMissiles) {
				if(enemyShipToCheck.collisionWith(enemyShipToCheck.position, friendlyMissile, enemyShipToCheck.size, friendlyMissile.size)) {
					enemyShipToCheck.onHit(friendlyMissile.onHitDamage);
					friendlyMissilesToDelete.add(friendlyMissile);
				}
			}
			if(friendlyMissilesToDelete.size() > 0)
				this.friendlyMissiles.removeAll(friendlyMissilesToDelete);

		}
		
		List<EnemyShip> enemyToDelete = new ArrayList<EnemyShip>();
		for (EnemyShip enemyShipToCheck : this.enemyShips) {
			if(enemyShipToCheck.health < 0) {
				enemyToDelete.add(enemyShipToCheck);
				enemyShipToCheck.deleted = true;
			}
		}
		if(enemyToDelete.size() > 0)
			this.enemyShips.removeAll(enemyToDelete);

		if(this.friendlyShip.health < 0)
			this.currentGameState = GameState.GAME_OVER;

		if(this.enemyShips.size() == 0) {
			EnemyShip enemy = new EnemyShip(0.9, 0.9, new FloatVector(5, 0));
			enemy.position = new FloatVector(width * 0.25, height * 0.25);
			enemy.direction = 240;

			this.enemyShips.add(enemy);
		}
	}}

	public void draw() {
		if(this.currentGameState == GameState.GAME_OVER)
		{	
			gameover();
			return;
		}


		for (int i=0; i < this.friendlyBullets.size(); i++) {
			FriendlyBullet fm = this.friendlyBullets.get(i);
			fm.draw();
		}

		for (FriendlyMissile fm : this.friendlyMissiles) {
			//println("this.friendlyMissiles.size(): "+this.friendlyMissiles.size());
			//println("this.enemyBullets.size(): "+this.enemyBullets.size());
			if(fm != null)
				fm.draw();
		}

		for (int i=0; i < this.enemyBullets.size(); i++) {
			this.enemyBullets.get(i).draw();
		}

		for (int i=0; i < this.enemyMissiles.size(); i++) {
			this.enemyMissiles.get(i).draw();
		}

		this.friendlyShip.draw();
		
		ellipse(this.friendlyShip.position.x, this.friendlyShip.position.y, 20, 20);

		for (int i=0; i < this.enemyShips.size(); i++) {
			this.enemyShips.get(i).draw();
		}
	}

	public void pressKey() {
		this.friendlyShip.pressKey();
	}
    
    public void releaseKey() {
    	this.friendlyShip.releaseKey();
    }
}