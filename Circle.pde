public class Circle{
	FloatVector position;
	float size;
	public Circle (FloatVector position, float size) {
		super();
		this.position = position;
		this.size = size;
	}

	public float getDistance() {return this.size/2;}
	public boolean collisionWith(FloatVector thisPosition, Circle other, float thisSize, float otherSize){
		//Collision between two circles

		float distance = thisSize/2 + otherSize/2;
		if ((abs(thisPosition.x - other.position.x) > distance) || (abs(thisPosition.y - other.position.y) > distance)) {
			return false;
		}
		else if(dist(thisPosition.x, thisPosition.y, other.position.x, other.position.y) > distance) {
			return false;
		}
		else{
			return true;
		}
	}
}