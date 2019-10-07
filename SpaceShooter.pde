import java.text.MessageFormat;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import ddf.minim.*;

GameManager gm;

int frame = 0;
float player_speed = 6;
PImage friendlyShipSprite;
PImage enemyShipSprite;
PImage missileSprite;

PImage backgroundBattle;
PImage backgroundGameover;

Minim space;
AudioPlayer spaceSoundTrack;

void setup() {
    size(1200, 800);
    space = new Minim(this);
    spaceSoundTrack = space.loadFile("data/AlphaCentauri.mp3");
    spaceSoundTrack.play();
    spaceSoundTrack.setGain(-10);
    

	friendlyShipSprite = loadImage("data/SpaceShip.png");
    enemyShipSprite = loadImage("data/EnemyShip.png");
    missileSprite = loadImage("data/Missile.png");
    backgroundBattle = loadImage("data/SpaceImage.png");
    backgroundGameover = loadImage("data/gameOver.png");

    FriendlyShip player = new FriendlyShip(0.9, 0.9);
	player.position = new FloatVector(width * 0.75, height * 0.75);
	player.direction = 240;

    gm = new GameManager(player);

    EnemyShip enemy = new EnemyShip(0.9, 0.9, new FloatVector(5, 0));
	enemy.position = new FloatVector(width * 0.25, height * 0.25);
	enemy.direction = 240;

	EnemyShip enemy2 = new EnemyShip(0.9, 0.9, new FloatVector(5, 0));
	enemy2.position = new FloatVector(width * 0.5, height * 0.25);
	enemy2.direction = 240;

    gm.enemyShips.add(enemy);
    gm.enemyShips.add(enemy2);

	strokeWeight(1.5);
  	stroke(255);
}

void draw() {
	background(0);
    imageMode(CENTER);
	if(gm.currentGameState == GameState.PLAYING)
        image(backgroundBattle, width/2, height/2);
    else
		image(backgroundGameover, width/2, height/2);


    gm.update();
	gm.draw();
	
	textAlign(LEFT, CENTER);
	textSize(20);
	DecimalFormat df = new DecimalFormat();
	df.setMaximumFractionDigits(1);
	frame++;
}

void keyPressed() {
	gm.pressKey();
}

void keyReleased(){
	gm.releaseKey();
}

void gameover()
{	
	textAlign(CENTER, CENTER);
	textSize(60);
	text("Gameover", width / 2 + (frame * 2) % width, height / 2);
	text("Gameover", width / 2 + (frame * 2) % width - width, height / 2);
}