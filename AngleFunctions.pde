public float smoothTurn(float previousDirection, FloatVector newVector, float decay) {
    class DirectionDelta{
        public float degreesDelta, newDirection;
        DirectionDelta(float degreesDelta, float newDirection) {
            this.degreesDelta = degreesDelta;
            this.newDirection = newDirection;
        }
    }

    ArrayList<DirectionDelta> distances = new ArrayList<DirectionDelta>();

    float newDirection = degrees(getAngleFromVector(newVector));
    distances.add(new DirectionDelta(abs(360 - previousDirection + newDirection), newDirection + 360));
    distances.add(new DirectionDelta(abs(previousDirection - (newDirection - 360)), (newDirection - 360)));
    distances.add(new DirectionDelta(abs(previousDirection - newDirection), newDirection));

    DirectionDelta dd = distances.get(0);
    for(int i=1; i < distances.size(); i++) {
        if(dd.degreesDelta > distances.get(i).degreesDelta)
            dd = distances.get(i);
    }

    float finalDirection = previousDirection * decay + (1 - decay) * dd.newDirection;

    if(finalDirection < 0)
        finalDirection += 360;
    else if(finalDirection > 360)
        finalDirection -= 360;

    return finalDirection;
}

public float getShortestTurn(float currentDirection, FloatVector newVector) {
    class DirectionDelta{
        public float degreesDelta, newDirection;
        DirectionDelta(float degreesDelta, float newDirection) {
            this.degreesDelta = degreesDelta;
            this.newDirection = newDirection;
        }
    }

    ArrayList<DirectionDelta> distances = new ArrayList<DirectionDelta>();

    float newDirection = degrees(getAngleFromVector(newVector));
    distances.add(new DirectionDelta(abs(360 - currentDirection + newDirection), newDirection + 360));
    distances.add(new DirectionDelta(abs(currentDirection - (newDirection - 360)), (newDirection - 360)));
    distances.add(new DirectionDelta(abs(currentDirection - newDirection), newDirection));

    DirectionDelta dd = distances.get(0);
    for(int i=1; i < distances.size(); i++) {
        if(dd.degreesDelta > distances.get(i).degreesDelta)
            dd = distances.get(i);
    }

    return dd.degreesDelta;
}

float getAngleFromVector(FloatVector vector) {
    if(vector.x != 0)
        if(vector.y != 0)
        {
            return atan2(vector.y, vector.x) + radians(180);
        }
    return 0.0;
}