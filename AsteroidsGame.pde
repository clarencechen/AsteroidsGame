Star[] constel = new Star[64];
ArrayList<Asteroid> belt = new ArrayList();
ArrayList<Bullet> bulls = new ArrayList();
SpaceShip bob;


public void setup() 
{
	for (int i = 0;i<constel.length;i++)
	{
		constel[i] = new Star();
	}
	for (int i = 0;i<8;i++)
	{
		belt.add(new Asteroid());
	}
	bob = new SpaceShip();
	size(600, 600);
	background(0);
}
public void draw() 
{
	background(0);
	for (int i = 0;i < constel.length;i++)
	{
		constel[i].show();
	}
	for (int i = 0;i < belt.size();i++)
	{
		belt.get(i).update();
		if(belt.get(i).del)
		{
			belt.remove(i);
		}
		else
		{
			bob.collide(belt.get(i));
			for (Bullet bull : bulls)	{bull.collide(belt.get(i));}
			for (int j = i +1;j < belt.size();j++)	{belt.get(i).collide(belt.get(j));}
			belt.get(i).move();
			belt.get(i).show();
		}
	}
	for (int k = 0;k < bulls.size();k++)
	{
		if(bulls.get(k).del)
		{
			bulls.remove(k);
		}
		else
		{
			bulls.get(k).move();
			bulls.get(k).show();
		}
	}
	bob.move();
	bob.show();
}
public void keyPressed()
{
		switch (key)
	{
		case 'q' :
		{
			bulls.add(new Bullet(bob));
			break;
		}
		case 'a' :
		{
			bob.accelerate(0.1f);
			break;
		}
		case 's' :
		{
			bob.rotate(3);
			break;
		}
		case 'd' :
		{
			;
			break;
		}
		case 'z' :
		{
			bob.accelerate(-0.1f);
			break;
		}
		case 'x' :
		{
			bob.rotate(-3);
			break;
		}
		case 'c' :
		{
			;
			break;
		}
		case ' ' :
		{
			bob.setX((int)(Math.random()*600));
			bob.setY((int)(Math.random()*600));
			bob.setDirectionX(10*Math.random()-5);
			bob.setDirectionY(10*Math.random()-5);
			bob.setPointDirection((int)(Math.random()*360));
			break;
		} 
	}
}
class Bullet extends Floater
{
	protected boolean del;
	protected double mass;
	Bullet(SpaceShip s)
	{
		del = false;
		corners = 4;
		xCorners = new int[4];
		yCorners = new int[4];
		xCorners[0] = 8;	xCorners[1] = 8;	xCorners[2] = -8;	xCorners[3] = -8;
		yCorners[0] = 1;	yCorners[1] = -1;	yCorners[2] = -1;	yCorners[3] = 1;
		myColor = color(128,255,0);
		myCenterX = s.getX();
		myCenterY = s.getY();
		double v = Math.sqrt(s.getDirectionX()*s.getDirectionX()+s.getDirectionY()*s.getDirectionY());
		myDirectionX = s.getDirectionX()+v*Math.cos((double)(s.getPointDirection())*(Math.PI/180));
		myDirectionY = s.getDirectionY()+v*Math.sin((double)(s.getPointDirection())*(Math.PI/180));
		myPointDirection = s.getPointDirection();
		mass = 64;
	}
	public void collide(Asteroid a)
	{
		double rad = myPointDirection*(Math.PI/180);
		double edgeX = myCenterX +8*Math.cos(rad);
		double edgeY = myCenterY +8*Math.sin(rad);
		double dx = edgeX -a.getX();
		double dy = edgeY -a.getY();
		if (dx*dx+dy*dy < 256+Math.pow(a.getMass(), 2./3.))
		{
			a.setMass(-64);
			del = true;
		}
	}
	public void setX(int x) {myCenterX = x;}
	public int getX() {return (int)myCenterX;}
	public void setY(int y) {myCenterY = y;}
	public int getY() {return (int)myCenterY;}
	public void setDirectionX(double x) {myDirectionX = x;}
	public double getDirectionX() {return myDirectionX;}
	public void setDirectionY(double y) {myDirectionY = y;}
	public double getDirectionY() {return myDirectionY;}
	public void setPointDirection(int degrees) {myPointDirection = degrees;}
	public double getPointDirection() {return myPointDirection;}
}
class SpaceShip extends Floater  
{
	SpaceShip()
	{
		corners = 3;
		xCorners = new int[3];
		yCorners = new int[3];
		xCorners[0] = 8;	xCorners[1] = -4;	xCorners[2] = -4;
		yCorners[0] = 0;	yCorners[1] = 8;	yCorners[2] = -8;
		myColor = color(255,0,0);
		myCenterX = 300;
		myCenterY = 300;
		myDirectionX = 0.5f;
		myDirectionY = 0.5f;
		myPointDirection = 0;
		mass = 1024;
	}
	public void collide(Asteroid a)
	{
		double dx = myCenterX-a.getX();
		double dy = myCenterY-a.getY();
		if (dx*dx+dy*dy < 256 +Math.pow(a.getMass(), 2./3.))
		{
			double totalMass = mass+a.getMass();
			double deltaMass = mass-a.getMass();
			double vx = myDirectionX;
			double vy = myDirectionY;
			double wx = a.getDirectionX();
			double wy = a.getDirectionY();
			myDirectionX = (vx*deltaMass +2*a.getMass()*wx)/totalMass;
			myDirectionY = (vy*deltaMass +2*a.getMass()*wy)/totalMass;
			a.setDirectionX((-wx*deltaMass +2*mass*vx)/totalMass);
			a.setDirectionY((-wy*deltaMass +2*mass*vy)/totalMass);
		}
	}
	protected double mass;
	public void setX(int x) {myCenterX = x;}
	public int getX() {return (int)myCenterX;}
	public void setY(int y) {myCenterY = y;}
	public int getY() {return (int)myCenterY;}
	public void setDirectionX(double x) {myDirectionX = x;}
	public double getDirectionX() {return myDirectionX;}
	public void setDirectionY(double y) {myDirectionY = y;}
	public double getDirectionY() {return myDirectionY;}
	public void setPointDirection(int degrees) {myPointDirection = degrees;}
	public double getPointDirection() {return myPointDirection;}
}
class Asteroid extends Floater
{
	protected boolean del;
	protected int rotSpeed;
	protected double mass;
	public Asteroid()
	{	
		del = false;
		rotSpeed = (int)(Math.random()*30 -15);
		mass = 4096;
		corners = 4;
		xCorners = new int[4];
		yCorners = new int[4];
		xCorners[0] = -8;	xCorners[1] = -8;	xCorners[2] = 8;	xCorners[3] = 8;
		yCorners[0] = -8;	yCorners[1] = 8;	yCorners[2] = 8;	yCorners[3] = -8;
		myColor = color(128,64,0);
		myCenterX = Math.random()*600;
		myCenterY = Math.random()*600;
		myDirectionX = (Math.random()*20 -10);
		myDirectionY = (Math.random()*20 -10);
		myPointDirection = Math.random()*360;
	}
	public void move()
	{
		rotate(rotSpeed);
		super.move();
	}
	public void collide(Asteroid a)
	{
		double dx = myCenterX-a.getX();
		double dy = myCenterY-a.getY();
		if (dx*dx+dy*dy < (Math.pow(mass, 2./3.)+Math.pow(a.getMass(), 2./3.))/4)
		{
			double totalMass = mass+a.getMass();
			double deltaMass = mass-a.getMass();
			double vx = myDirectionX;
			double vy = myDirectionY;
			double wx = a.getDirectionX();
			double wy = a.getDirectionY();
			myDirectionX = (vx*deltaMass +2*a.getMass()*wx)/totalMass;
			myDirectionY = (vy*deltaMass +2*a.getMass()*wy)/totalMass;
			a.setDirectionX((-wx*deltaMass +2*mass*vx)/totalMass);
			a.setDirectionY((-wy*deltaMass +2*mass*vy)/totalMass);
		}
	}
	public void update()
	{
		xCorners[0] = (int)(-Math.pow(mass, 1./3.)/2);
		xCorners[1] = (int)(-Math.pow(mass, 1./3.)/2);
		xCorners[2] = (int)(Math.pow(mass, 1./3.)/2);
		xCorners[3] = (int)(Math.pow(mass, 1./3.)/2);
		yCorners[0] = (int)(-Math.pow(mass, 1./3.)/2);
		yCorners[1] = (int)(Math.pow(mass, 1./3.)/2);
		yCorners[2] = (int)(Math.pow(mass, 1./3.)/2);
		yCorners[3] = (int)(-Math.pow(mass, 1./3.)/2);

		if(mass < 64)
		{
			del = true;
		}
	}
	public void setX(int x) {myCenterX = x;}
	public int getX() {return (int)myCenterX;}
	public void setY(int y) {myCenterY = y;}
	public int getY() {return (int)myCenterY;}
	public void setDirectionX(double x) {myDirectionX = x;}
	public double getDirectionX() {return myDirectionX;}
	public void setDirectionY(double y) {myDirectionY = y;}
	public double getDirectionY() {return myDirectionY;}
	public void setPointDirection(int degrees) {myPointDirection = degrees;}
	public double getPointDirection() {return myPointDirection;}
	public double getMass() {return mass;}
	public void setMass(double m) {mass += m;}
}
abstract class Floater //Do NOT modify the Floater class! Make changes in the SpaceShip class 
{   
	protected int corners;  //the number of corners, a triangular floassssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscater has 3   
	protected int[] xCorners;   
	protected int[] yCorners;   
	protected int myColor;   
	protected double myCenterX, myCenterY; //holds center coordinates   
	protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel   
	protected double myPointDirection; //holds current direction the ship is pointing in degrees    
	abstract public void setX(int x);  
	abstract public int getX();   
	abstract public void setY(int y);   
	abstract public int getY();   
	abstract public void setDirectionX(double x);   
	abstract public double getDirectionX();   
	abstract public void setDirectionY(double y);   
	abstract public double getDirectionY();   
	abstract public void setPointDirection(int degrees);   
	abstract public double getPointDirection(); 

	//Accelerates the floater in the direction it is pointing (myPointDirection)   
	public void accelerate (double dAmount)   
	{          
		//convert the current direction the floater is pointing to radians    
		double dRadians =myPointDirection*(Math.PI/180);     
		//change coordinates of direction of travel    
		myDirectionX += ((dAmount) * Math.cos(dRadians));    
		myDirectionY += ((dAmount) * Math.sin(dRadians));       
	}   
	public void rotate (int nDegreesOfRotation)   
	{     
		//rotates the floater by a given number of degrees    
		myPointDirection+=nDegreesOfRotation;   
	}   
	public void move ()   //move the floater in the current direction of travel
	{      
		//change the x and y coordinates by myDirectionX and myDirectionY       
		myCenterX += myDirectionX;    
		myCenterY += myDirectionY;     

		//wrap around screen    
		if(myCenterX >width)
		{     
			myCenterX = 0;    
		}    
		else if (myCenterX<0)
		{     
			myCenterX = width;    
		}    
		if(myCenterY >height)
		{    
			myCenterY = 0;    
		}   
		else if (myCenterY < 0)
		{     
			myCenterY = height;    
		}   
	}   
	public void show ()  //Draws the floater at the current position  
	{             
		fill(myColor);   
		stroke(myColor);    
		//convert degrees to radians for sin and cos         
		double dRadians = myPointDirection*(Math.PI/180);
		int xRotatedTranslated, yRotatedTranslated;    
		beginShape();         
		for(int nI = 0; nI < corners; nI++)    
		{
			//rotate and translate the coordinates of the floater using current direction 
			xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);
			yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);
			vertex(xRotatedTranslated,yRotatedTranslated);
		}
		endShape(CLOSE);  
	}   
}
class Star
{
	private int x;
	private int y;
	public Star()
	{
		x = (int)(Math.random()*600);
		y = (int)(Math.random()*600);
	}
	public void show()
	{
		fill(255);   
		noStroke();
		ellipse(x, y, 1, 1);
	}
}