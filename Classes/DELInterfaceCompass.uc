class DELInterfaceCompass extends DELInterface implements(DELICompass)
	placeable;

var(Movement) const vector Location;
var(Movement) const rotator Rotation;

/*COMPASS VARIABLES*/
var DELMinimap GameMinimap;
var MaterialInstanceConstant GameMiniMapMIC;
var Material GameMinimapp;
var float TileSize;
var int MapDim;
var int BoxSize;
var float ResolutionScale;
var float MPosXMap;
var float MPosYMap;

function load(DELPlayerHud hud){
	GameMiniMap = DELGame(WorldInfo.Game).GameMinimap;
}


/**
 * Draws compass to hud
 * @PARAMS DELPlayerHud hud
 * */
function draw(DELPlayerHud hud){
	local float TrueNorth, PlayerHeading;
	local Vector2D MapPosition;
	local float CompassRotation, MapRotation;
	
	local LinearColor MapOffset;

	//set map positions to draw
	MapPosition.X = hud.Canvas.OrgX;
	MapPosition.Y = hud.Canvas.OrgY;

	//set the size of the compass
	MapDim = MapDim * ResolutionScale;

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
	//Draw the Compass
	hud.Canvas.SetPos(MapPosition.X,MapPosition.Y);
	hud.Canvas.DrawMaterialTile(GameMinimap.Minimap,
            MapDim,
            MapDim,
            0.0,0.0,1.0,1.0);

	//Draw the needle
	hud.Canvas.SetPos(MapPosition.X,MapPosition.Y);
	hud.Canvas.DrawMaterialTile(GameMinimap.CompassOverlay,MapDim,MapDim,0.0,0.0,1.0,1.0);
	//Draw the overlay
	hud.Canvas.SetPos(MapPosition.X,MapPosition.Y);
	hud.Canvas.DrawMaterialTile(GameMinimap.CompassGloss,MapDim,MapDim,0.0,0.0,1.0,1.0);
}

/**
 * Returns the Players' Yaw 
 */
function int getYaw(){
	//`log("getYaw: " $ self.Rotation.Yaw);
	return self.Rotation.Yaw;
}

/**
 * Returns Players' rotation
 */
function Rotator getRotator(){
	//`log("getRotator: " $ self.Rotation);
	return self.Rotation;
}

/**
 * Returns Players' rotator as a vector
 **/
function vector getVectorizedRotator(){
	//`log("getVectorizedRotator: " $ self.Rotation);
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

	bMoveable=false

	MapDim=150
	TileSize=0.4
	  BoxSize=12
	 MapPosition=(X=0.000000,Y=0.000000)
	ResolutionScale=1.0
}
