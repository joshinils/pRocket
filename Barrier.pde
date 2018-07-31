class Barrier{
	float xTop;
	float yTop;
	float xWid;
	float yWid;
	boolean good;
	
	Barrier(float xT, float yT, float xW, float yW)
	{
		xTop = xT;
		yTop = yT;
		xWid = xW;
		yWid = yW;
		good=false;
	}
	
	void setGood(boolean b)
	{
		good=b;
	}
	
	void draw()
	{
		fill(50+20*(int(!good)-.5),50,50);
		rect(xTop, yTop, xWid, yWid);
	}
}