class Agent {
	float xPos;
	float yPos;
	float xVel;
	float yVel;
	float xAcc;
	float yAcc;
	boolean alive;
	float score;
	int winner;
	
	Agent(float x, float y)
	{
		xPos = x;
		yPos = y;
		setVel(0,0);
		setAcc(0,0);
		alive=true;
		winner=0;
	}
	
	void setVel(float x, float y)
	{
		xVel = x;
		yVel = y;
	}

	void setAcc(float x, float y)
	{
		xAcc = x;
		yAcc = y;
	}
	
	void giveAcc(float x, float y)
	{
		float xAccN = xAcc+x;
		float yAccN = yAcc+y;
//		float normO = sqrt( xAcc*xAcc	+	yAcc*yAcc );
//		float normN = sqrt(xAccN*xAccN + yAccN*yAccN);
//
		xAcc = xAccN;
		yAcc = yAccN;
	}
	
	void kill()
	{
		xVel=0;
		yVel=0;
		xAcc=0;
		yAcc=0;

		alive=false;
	}
	
	void setScore(float x)
	{
		score=x;
	}
	
	float getScore()
	{
		return score;
	}
	
	void draw()
	{
		float vLength=sqrt(xVel*xVel + yVel*yVel);
		float xVN=xVel/vLength;
		float yVN=yVel/vLength;
		
		float size=15;
		float xFro=xPos+xVN*size;
		float yFro=yPos+yVN*size;

		float xBaR=xPos + (-0.5			*xVN + 0.8660254*yVN)*size/2;
		float yBaR=yPos + (-0.8660254*xVN - 0.5			*yVN)*size/2;

		float xBaL=xPos + (-0.5			*xVN - 0.8660254*yVN)*size/2;
		float yBaL=yPos + ( 0.8660254*xVN - 0.5			*yVN)*size/2;
		
		fill(255,255,255,100+100*int(alive));
		stroke(255,255,255,50+50*int(alive));
		triangle(xFro, yFro, xBaL, yBaL, xBaR, yBaR);
		
		stroke(255,255,255,100);
		if(alive)
			fill(255, 255,	0, 200);
		else if(winner==1)
			fill(	0, 255,	0, 200);
		else
			fill(255,	 0,	0, 200);
		ellipse(xPos, yPos, size/3, size/3);
	}
	
	void animate()
	{
		if(!alive)
			return;
		
		xPos += xVel;
		yPos += yVel;
		
		xVel += xAcc;
		yVel += yAcc;

		//drag
		float speed = sqrt(xVel*xVel + yVel*yVel);
		xVel=xVel*min(sigmoid(speed), .99);
		yVel=yVel*min(sigmoid(speed), .99);

		//stop accelerating
		xAcc*=0.5;
		yAcc*=0.5;

		if(xPos >= width)
			xPos -= width;
		if(yPos >= height)
			yPos -= height;
		
		if(xPos < 0)
			xPos += width;
		if(yPos < 0)
			yPos += height;
			
		for(int i=0; i < barrierAmount; ++i)
		{
			if(		xPos >= barrier[i].xTop && xPos <= barrier[i].xTop + barrier[i].xWid
					&& yPos >= barrier[i].yTop && yPos <= barrier[i].yTop + barrier[i].yWid)
			{
				alive=false;
				winner=int((int(barrier[i].good)-.5)*2);
			}
		}
	}
}
