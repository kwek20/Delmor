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

function draw(DELPlayerHud hud){
	local float TrueNorth, PlayerHeading;
	local Vector2D MapPosition;
	local float CompassRotation, MapRotation;
	local vector PlayerPos, ClampedPlayerPos, DisplayPlayerPos, RotPlayerPos, StartPos;
	local LinearColor MapOffset;
	local float ActualMapRange;

	MapPosition.X = hud.Canvas.OrgX + 30;;
	MapPosition.Y = hud.Canvas.OrgY + 30;;
//	ActualMapRange = FMax(GameMinimap.MapRangeMax.X - GameMinimap.MapRangeMin.X, GameMinimap.MapRangeMax.Y - GameMinimap.MapRangeMin.Y);
/*	`log("actualmaprangeXmax: "$ GameMinimap.MapRangeMax.X);
	`log("actualMaprangeYmax: "$ GameMinimap.MapRangeMax.Y);
	`log("actualmaprangeXmin: "$ GameMinimap.MapRangeMin.X);
	`log("actualMaprangeYmin: "$ GameMinimap.MapRangeMin.Y);
	`log("MAPPOSX: "$ MapPosition.X);
	`log("MAPPOSY: "$ MapPosition.Y);
	`log("resoscale: "$ResolutionScale);*/
	MapDim = MapDim * ResolutionScale;
/*  `log("MAPDIM " $ MapDim);
	`log("DPC.Pawn.Location.Y " $ GetALocalPlayerController().Pawn.Location.Y);
	`log("ActualMapRange: " $ ActualMapRange);
	`log("PlayerposX " $PlayerPos.X);
	`log("PlayerposY " $PlayerPos.Y);*/

/*	`log("ClampedPlayerPos.X: "$ ClampedPlayerPos.X);
	`log("ClampedPlayerPos.Y: "$ ClampedPlayerPos.Y);*/
	TrueNorth = GameMinimap.GetRadianHeading();
	Playerheading = getRadianHeading();

	/*`log("TRUENORTH : "$ TrueNorth);*/
	if(GameMinimap.bForwardAlwaysUp){
		MapRotation = PlayerHeading;
		//`log("Maprotation" $ MapRotation);
		CompassRotation = PlayerHeading - TrueNorth;
		//`log("CompassRotation"$ CompassRotation);
	} else {
		MapRotation = PlayerHeading - TrueNorth;
		//`log("Maprotation" $ MapRotation);
		CompassRotation = MapRotation;
		//`log("CompassRotation"$ CompassRotation);
	}
	GameMinimap.Minimap.SetScalarParameterValue('MapRotation',MapRotation);
	GameMinimap.Minimap.SetScalarParameterValue('TileSize',TileSize);
	GameMinimap.Minimap.SetVectorParameterValue('MapOffset',MapOffset);
	GameMinimap.CompassOverlay.SetScalarParameterValue('CompassRotation',CompassRotation);
	hud.Canvas.SetPos(MapPosition.X,MapPosition.Y);
	hud.Canvas.DrawMaterialTile(GameMinimap.Minimap,
            MapDim,
            MapDim,
            0.0,0.0,1.0,1.0);


	hud.Canvas.SetPos(MapPosition.X,MapPosition.Y);
	hud.Canvas.DrawMaterialTile(GameMinimap.CompassOverlay,MapDim,MapDim,0.0,0.0,1.0,1.0);
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

	bMoveable=false

	MapDim=180
	TileSize=0.4
	  BoxSize=12
	 MapPosition=(X=0.000000,Y=0.000000)
	ResolutionScale=1.0
}
