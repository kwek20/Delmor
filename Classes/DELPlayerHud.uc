class DELPlayerHud extends UDkHUD
	config(game);

var array< DELInterface > interfaces;

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

simulated event PostBeginPlay() {
	Super.PostBeginPlay();

	GameMiniMap = DELGame(WorldInfo.Game).GameMinimap;
	`log("HUD POST BEGIN");
}

function PlayerOwnerDied(){
	local DELPlayerController PC;
    PC = getPlayer();
	PC.gotoState('End');
}

function DrawHUD() {
   super.DrawHUD();    
   //drawCrossHair();
   //drawHealthBar();
	DrawCompass();
    MPosXMap = Canvas.OrgX + 30;
    MPosYMap = Canvas.OrgX + 30;
}
/*
function DELPlayerController getPlayer(){
	return DELPlayerController(PlayerOwner);
}
*/
/*-----------------------------------------------------------
 * COMPASS
 *-----------------------------------------------------------*/

function PostRender(){
	local DELInterface interface;
	super.PostRender();

	foreach interfaces(interface){
		interface.draw(self);
	}
}

function log(String text){
	class'WorldInfo'.static.GetWorldInfo().Game.Broadcast(getPlayer(), text);
}

function DELPlayerController getPlayer(){
	return DELPlayerController(PlayerOwner);
}

/*-----------------------------------------------------------
 * COMPASS
 *-----------------------------------------------------------*/

/**
 * Returns the heading in radians
 * */

function float getRadianHeading(){
	local Vector v;
	local rotator r;
	local float f;

	r.Yaw = GetALocalPlayerController().Pawn.Rotation.Yaw;
	v = vector(r);
	f = GetHeadingAngle(v);
	f = UnwindHeading(f);

	while(f < 0){
		f += PI*2.0f;
	}

	return f;
}

/**
 * Returns the player heading 
 */
function float GetPlayerHeading(){
	local Vector v;
	local Rotator r;
	local float f;

	r.Yaw = GetALocalPlayerController().Pawn.Rotation.Yaw;
	v = vector(r);
	f = GetHeadingAngle(v);
	f = UnwindHeading(f);

	while(f < 0){
		f += PI * 2.0f;
	//	`log("f: "$f);
	}
	
	return f;
}

/**
 * Draws a compass at pre-set coordinates
 * */
function DrawCompass(){
	local float TrueNorth;
	local float PlayerHeading;
	local Vector2D MapPosition;
	local float CompassRotation;
	local float MapRotation;
	local vector PlayerPos;
	local Vector ClampedPlayerPos, DisplayPlayerPos;
	local Vector RotPlayerPos;
	local Vector StartPos;
	local LinearColor MapOffset;
	local float ActualMapRange;
	MapPosition.X = MPosXMap;
	MapPosition.Y = MPosYMap;
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
	Playerheading = GetPlayerHeading();

	/*`log("TRUENORTH : "$ TrueNorth);*/
	if(GameMinimap.bForwardAlwaysUp)
	{
		MapRotation = PlayerHeading;
		//`log("Maprotation" $ MapRotation);
		CompassRotation = PlayerHeading - TrueNorth;
		//`log("CompassRotation"$ CompassRotation);
	}
	else
	{
		MapRotation = PlayerHeading - TrueNorth;
		//`log("Maprotation" $ MapRotation);
		CompassRotation = MapRotation;
		//`log("CompassRotation"$ CompassRotation);
	}
	GameMinimap.Minimap.SetScalarParameterValue('MapRotation',MapRotation);
	GameMinimap.Minimap.SetScalarParameterValue('TileSize',TileSize);
	GameMinimap.Minimap.SetVectorParameterValue('MapOffset',MapOffset);
	GameMinimap.CompassOverlay.SetScalarParameterValue('CompassRotation',CompassRotation);
	Canvas.SetPos(MapPosition.X,MapPosition.Y);
	Canvas.DrawMaterialTile(GameMinimap.Minimap,
            MapDim,
            MapDim,
            0.0,0.0,1.0,1.0);


	Canvas.SetPos(MapPosition.X,MapPosition.Y);
	Canvas.DrawMaterialTile(GameMinimap.CompassOverlay,MapDim,MapDim,0.0,0.0,1.0,1.0);
}


defaultproperties 
{
	MapDim=180
	TileSize=0.4
	  BoxSize=12
	 MapPosition=(X=0.000000,Y=0.000000)
	clockIcon=(Texture=Texture2D'UDKHUD.Time') 
	ResolutionScale=1.0
}