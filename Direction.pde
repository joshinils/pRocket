class Direction{
	PVector[] dir;
	int length;
	Direction(int l)
	{
		length=l;
		dir = new PVector[length];
		for(int i = 0; i< length; ++i)
			dir[i] = new PVector(0,0);
	}
	
	boolean setDir(float x, float y, int pos)
	{
		if(pos >= 0 && pos < length)
		{
			dir[pos].set(x,y);
			return true;
		}
		return false;
	}
	
	PVector getDir(int pos)
	{
		if(pos >= 0 && pos < length)
			return dir[pos];
		return new PVector(0,0);
	}
}