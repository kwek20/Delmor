/**
 * A compass interface to display the compass
 */
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

var Vector2D MapPosition;

function load(DELPlayerHud hud){
	GameMiniMap = DELGame(WorldInfo.Game).GameMinimap;
}


/**
 * Draws compass to hud
 * @PARAMS DELPlayerHud hud
 * */
function draw(DELPlayerHud hud){
	local float TrueNorth, PlayerHeading;
	local float CompassRotation, MapRotation;
	
	local LinearColor MapOffset;

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

	hud.Canvas.SetPos(MapPosition.X,MapPosition.Y);
	hud.Canvas.DrawMaterialTile(GameMinimap.Minimap, MapDim, MapDim, 0.0,0.0,1.0,1.0);

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
	bMoveable=false

	MapDim=125
	TileSize=0.4
	BoxSize=12
	MapPosition=(X=30.000000,Y=10.000000)
	ResolutionScale=1.0
}
