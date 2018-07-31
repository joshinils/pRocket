import java.util.Arrays;
float sigmoid(float x)
{
	return 2/(1+exp(-x*2))-1;
}

int agentAmount = 1000;
Agent[] agent;

int barrierAmount = 2;
Barrier[] barrier;

int directionLength = 1000;
Direction[] direction;

void setup()
{
	size(800, 800);
	frameRate(14400);

	background(color(0));
	agent = new Agent[agentAmount];
	direction = new Direction[agentAmount];

	for (int i = 0; i < agentAmount; ++i)
	{
		agent[i] = new Agent(width/2, 3*height/4);

		//Velocity
		float dir=random(-PI, PI);
		float r = random(1);
		agent[i].setVel(r*sin(dir), r*cos(dir));

		//Acceleration
		dir=random(-PI, PI);
		r = random(0.0);
		agent[i].setAcc(r*sin(dir), r*cos(dir));
		agent[i].draw();

		//Directions
		direction[i] = new Direction(directionLength);
		for (int j = 0; j < directionLength; ++j)
		{
			dir=random(-PI, PI);
			r = random(0.50);
			direction[i].setDir(r*sin(dir), r*cos(dir), j);
		}
	}

	stroke(255);

	barrier = new Barrier[barrierAmount];
	barrier[0] = new Barrier(width - width*4/5, height/2, width*3/5, height/10);
	barrier[0].setGood(false);

	barrier[1] = new Barrier(width/2 - width/40, height/4, width/20, height/20);
	barrier[1].setGood(true);


	//	print("s:"+sin(-2*PI/3)+"\n");
	//	print("c:"+cos(-2*PI/3)+"\n");
	//	for(float i = -10; i < 10; ++i)
	//		print(i+" "+sigmoid(i)+" "+sigmoid(i)*abs(i)+"\n");
}

int animationStep = 0;
int betweenAnim=1;

boolean allDead=true;
float minScore= -3.40282347E+38;
float maxScore=	3.40282347E+38;

void draw()
{
	if (animationStep/betweenAnim > directionLength)
	{
		//sort
		Arrays.sort(agent);

		//duplicate best
		//evolve

		//kill
		agent = Arrays.copyOfRange(agent, 0, 10);
    agentAmount=10;
    
		//reset animation
		for (int i=0; i < agentAmount; ++i)
		{
			agent[i].reset();
		}
		animationStep=0;
	}

	++animationStep;
	background((animationStep/betweenAnim) <= directionLength ? color(0):color(50));

	for (int i = 0; i < barrierAmount; ++i)
		barrier[i].draw();		

	for (int i = 0; i < agentAmount; ++i)
	{
		if (agent[i].alive)
			allDead=false;

		if (animationStep/betweenAnim <= directionLength && animationStep%betweenAnim == 0)
		{
			PVector acc = direction[i].getDir(animationStep/betweenAnim);
			agent[i].giveAcc(acc.x, acc.y);
		}
		agent[i].animate();
		agent[i].draw();
	}

	float minN= 3.40282347E+38;
	float maxN=-3.40282347E+38;

	if (allDead || true)
	{
		//score
		for (int i=0; i<agentAmount; ++i)
		{
			//https://gamedev.stackexchange.com/questions/44483/how-do-i-calculate-distance-between-a-point-and-an-axis-aligned-rectangle
			float dx = max( abs(agent[i].xPos - (barrier[1].xTop + barrier[1].xWid / 2)) - barrier[1].xWid / 2, 0);
			float dy = max( abs(agent[i].yPos - (barrier[1].yTop + barrier[1].yWid / 2)) - barrier[1].yWid / 2, 0);
			agent[i].score = -sqrt(dx*dx + dy*dy) + agent[i].winner*255;

			if (agent[i].score > maxN)
				maxN = agent[i].score;
			if (agent[i].score < minN)
				minN = agent[i].score;

			agent[i].drawScore(minScore, maxScore);
		}
		minScore=minN;
		maxScore=maxN;

		print((float(animationStep)/betweenAnim)/directionLength*100+"% min: "+minScore +" max:"+ maxScore + "\n" );
	}

	allDead=true;
}
