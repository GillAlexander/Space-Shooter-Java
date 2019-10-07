class FloatVector {
    public float x, y;

    public FloatVector (float x, float y) {
		this.x = x;
		this.y = y;
    }

	public FloatVector (float angle, float magnitude, boolean use_angle_input) {
		this.x = cos(radians(angle)) * magnitude;
		this.y = sin(radians(angle)) * magnitude;
    }

	// public FloatVector copy() {
	// 	return new FloatVector(this.x.clone(), this.y.clone());
	// }

	public float mag()
	{
		return this.magnitude();
	}

	public float magnitude() {
		return sqrt(this.x * this.x + this.y * this.y);
	}

	public float magNoSqrt() {
		return this.magnitudeNoSqrt();
	}

	public float magnitudeNoSqrt() {
		return this.x * this.x + this.y * this.y;
	}


	public FloatVector add(FloatVector v1) {
		return new FloatVector(this.x + v1.x, this.y + v1.y);
	}

	public void addTo(FloatVector v1) {
		this.x += v1.x;
		this.y += v1.y;
	}

	public FloatVector subtract(FloatVector v1) {
		return new FloatVector(this.x - v1.x, this.y - v1.y);
	}

	public void subtractTo(FloatVector v1) {
		this.x -= v1.x;
		this.y -= v1.y;
	}

	public FloatVector multiply(float value) {
		return new FloatVector(this.x * value, this.y * value);
	}

	public void multiplyTo(float value) {
		this.x *= value;
		this.y *= value;
	}

	public FloatVector divide(float value) {
		return this.multiply(1 / value);
	}

	public void divideTo(float value) {
		this.multiplyTo(1 / value);
	}

	public boolean isXOutOfBound() {
		return this.x > width || this.x < 0;
	}

	public boolean isYOutOfBound() {
		return this.y > height || this.y < 0;
	}

	public boolean isGreaterThan(FloatVector other) {
		return this.x > other.x && this.y > other.y;
	}

	public boolean isLessThan(FloatVector other) {
		return this.x < other.x && this.y < other.y;
	}

	public void printData()
	{
		println("this.x: "+this.x);
		println("this.y: "+this.y);
	}

	public boolean isEqual(FloatVector other) {
		return this.x == other.x && this.y == other.y;
	}

}

