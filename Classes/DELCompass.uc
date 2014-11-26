class DELCompass extends Actor placeable implements(DELICompass);

var(Movement) const vector Location;
var(Movement) const rotator Rotation;


event PostBeginPlay(){
	super.PostBeginPlay();
//	`log("=====",,'UTBook');
//	`log("Compass Heading"@GetRadianHeading()@GetDegreeHeading(),,'UTBook');
//	`log("=====",,'UTBook');
	ConsoleCommand("DisableAllScreenMessages");
}

/**
 * Returns the Yaw 
 */
function int getYaw(){
	//`log("getYaw: " $ self.Rotation.Yaw);
	return self.Rotation.Yaw;
}

/**
 * Returns rotator
 */
function Rotator getRotator(){
	//`log("getRotator: " $ self.Rotation);
	return self.Rotation;
}

/**
 * Returns rotator as a vector
 */
function vector getVectorizedRotator(){
	//`log("getVectorizedRotator: " $ self.Rotation);
	return Vector(self.Rotation);
}

/**
 * Gets the heading in radians
 */
function float getRadianHeading(){
	local Vector v;
	local rotator r;
	local float f;
	
	r.Yaw = getYaw();
	v = vector(r);
	f = GetHeadingAngle(v);
	f = UnwindHeading(f);

	while(f < 0){
		f += PI*2.0f;
	}
	//`log("getRadianHeading: " $ f);
	return f;
}

/**
 * Gets the heading in degrees
 */
function float getDegreeHeading(){
	local float f;

	f = getRadianHeading();

	f *= RadToDeg;
	`log("getDegreeHeading: " $ f);
	return f;
}





DefaultProperties
{
	Begin Object Class=ArrowComponent Name=Arrow
		ArrowColor=(B=80,G=80,R=200,A=255)
		ArrowSize = 1.000000
		Name="North Heading"
		end Object
	Components(0) = Arrow

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'CompassContent.compass'
		HiddenGame=True
		AlwaysLoadOnClient=false
		AlwaysLoadOnServer = False
		Name = "Sprite"
		End Object
	Components(1) = Sprite

	bStatic=true
	bHidden=true
	bNoDelete = True
	bMoveable=false
}
