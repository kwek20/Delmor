/**
 * A compass interface to display the compass
 */
class DELInterfaceCompass extends DELInterfaceTexture implements(DELICompass)
	placeable;

var(Movement) const vector Location;
var(Movement) const rotator Rotation;

var array<MaterialInstanceConstant> materials;

/*COMPASS VARIABLES*/
var DELMinimap GameMinimap;
var float TileSize;
var int MapDim;

function load(DELPlayerHud hud){
	local float xSize, ySize, xStart, yStart, mapDim;
	ySize = hud.SizeY * class'DELInterfaceHealthBars'.const.hudFactorScaleY;
	xSize = hud.SizeX * class'DELInterfaceHealthBars'.const.hudFactorScaleX;

	mapDim = ySize*1.2;
	yStart = hud.SizeY/36 - (mapDim - ySize) / 2;
	xStart = hud.SizeY/36 + (xSize / 4 - mapDim/2);
	
	setPos(xStart,yStart,mapDim,mapDim, hud);
	GameMiniMap = DELGame(WorldInfo.Game).GameMinimap;

	materials.AddItem(GameMinimap.Minimap);
	materials.AddItem(GameMinimap.CompassOverlay);
	materials.AddItem(GameMinimap.CompassGloss);
}


/**
 * Draws compass to hud
 * @param hud
 * */
function draw(DELPlayerHud hud){
	local DELPawn pawn;
	local float TrueNorth, PlayerHeading;
	local float CompassRotation, MapRotation;
	local LinearColor MapOffset;

	if ( GameMinimap != none ){
		pawn = hud.getPlayer().getPawn();
		if (pawn == None || pawn.Health <= 0)return;

		super.draw(hud);

		//returns the direction the in-game placed minimap is pointing
		TrueNorth = GameMinimap.getRadianHeading();
		//returns the player heading in-game
		Playerheading = getPlayerHeading();
	
		//Check wether the compass should rotate along with the player rotation, it shouldnt.
		if(GameMinimap.bForwardAlwaysUp){
			MapRotation = PlayerHeading;
			CompassRotation = PlayerHeading - TrueNorth;
		} else {
			MapRotation = PlayerHeading - TrueNorth;
			CompassRotation = MapRotation;
		}

		GameMinimap.Minimap.SetScalarParameterValue('MapRotation',MapRotation);
		GameMinimap.Minimap.SetScalarParameterValue('TileSize',TileSize);
		GameMinimap.Minimap.SetVectorParameterValue('MapOffset',MapOffset);
		GameMinimap.CompassOverlay.SetScalarParameterValue('CompassRotation',CompassRotation);

		drawMaterialTiles(hud.Canvas, materials);
	}
}

function drawMaterialTiles(Canvas c, array<MaterialInstanceConstant> materials){
	local MaterialInstanceConstant mat;
	foreach materials(mat){
		c.SetPos(position.X, position.Y); 
		c.DrawMaterialTile(mat,position.Z,position.W,0.0,0.0,1.0,1.0);
	}
}

/**
 * Returns the Players' Yaw 
 */
function int getYaw(){
	return self.Rotation.Yaw;
}

/**
 * Returns Players' rotation
 */
function Rotator getRotator(){
	return self.Rotation;
}

/**
 * Returns Players' rotator as a vector
 **/
function vector getVectorizedRotator(){
	return Vector(self.Rotation);
}

/**
 * Gets the heading in radians
 * Used for pointing the compassNeedle in the proper direction on the UI
 * 
 **/
function float getRadianHeading(){
	local Vector v;
	local rotator r;
	local float f;
	
	r.Yaw = getYaw();
	v = vector(r);
	f = GetHeadingAngle(v);
	f = UnwindHeading(f);

	//Algorithm used with vehicles to save radian conversion
	//UTVehicle.uc line 1199
	while(f < 0){
		f += PI*2.0f;
	}
	return f;
}

/**
 * Gets the heading in degrees
 * Converts the getRadianHeading() result to degrees
 **/
function float getDegreeHeading(){
	local float f;

	f = getRadianHeading();

	f *= RadToDeg;
	return f;
}

/**
 * Returns playerheading in degrees
 */
function float getPlayerHeading()
{
	local Float PlayerHeading;
	local Rotator PlayerRotation;
	local Vector v;

	PlayerRotation.Yaw = GetALocalPlayerController().Pawn.Rotation.Yaw;
	v = vector(PlayerRotation);
	PlayerHeading = GetHeadingAngle(v);
	PlayerHeading = UnwindHeading(PlayerHeading);

	while (PlayerHeading < 0)
		PlayerHeading += PI * 2.0f;

	return PlayerHeading;
}

DefaultProperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Actor'
		HiddenGame = true
		AlwaysLoadOnClient = false;
		AlwaysLoadOnServer = false;
	End Object
	Components(0) = Sprite

	Begin Object Class=ArrowComponent Name=Arrow
		ArrowColor = (B=80,G=80,R=200,A=255)
		Name = "North Heading"
	End Object
	Components(1) = Arrow

	bMoveable=false

	MapDim=125
	TileSize=0.4
}
