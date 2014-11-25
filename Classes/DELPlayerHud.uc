class DELPlayerHud extends UDkHUD
	config(game);

var CanvasIcon clockIcon;
var float clock; 

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
   clock = 30;
}

function PlayerOwnerDied(){
	log("died");
	//show death screen
}

function DisplayHit(vector HitDir, int Damage, class<DamageType> damageType)
{
	log("damage: " $ Damage $ " Type: " $ damageType);
}


simulated event Tick(float DeltaTime){
	Super.Tick(DeltaTime);
	clock-=0.1;

   if(clock <= 0) {     
      clock = 30;
   }
}

function DrawHUD() {
   super.DrawHUD();    
   //drawCrossHair();
   //drawHealthBar();
	DrawCompass();
    MPosXMap = Canvas.OrgX + 30;
    MPosYMap = Canvas.ClipY/1.6;
}

function drawHealthBar() {
   //Canvas.DrawIcon(clockIcon, 0, 0);     

   Canvas.Font = class'Engine'.static.GetLargeFont();      
   Canvas.SetDrawColor(255, 255, 255); // White

   if(clock < 10) {
     Canvas.SetDrawColor(255, 0, 0); // Red
   } else if (clock < 20) {
     Canvas.SetDrawColor(255, 255, 0); // Yellow
   } else {
     Canvas.SetDrawColor(0, 255, 0); // Green
   }
 
   Canvas.SetPos(200, 15);   
   Canvas.DrawRect(20 * clock, 30); 
}


function drawCrossHair() {
	local float CrosshairSize;

	Canvas.SetDrawColor(0,255,0);

	CrosshairSize = 4;

	Canvas.SetPos(CenterX - CrosshairSize, CenterY);
	Canvas.DrawRect(2*CrosshairSize + 1, 1);

	Canvas.SetPos(CenterX, CenterY - CrosshairSize);
	Canvas.DrawRect(1, 2*CrosshairSize + 1);
}

function log(String text){
	class'WorldInfo'.static.GetWorldInfo().Game.Broadcast(getPlayer(), text);
}

function PlayerController getPlayer(){
	return PlayerOwner;
}

/*-----------------------------------------------------------
 * COMPASS
 *-----------------------------------------------------------*/

function float getRadianHeading(){
	local Vector v;
	local rotator r;
	local float f;

	r.Yaw = PlayerOwner.Pawn.Rotation.Yaw;
	v = vector(r);
	f = GetHeadingAngle(v);
	f = UnwindHeading(f);

	while(f < 0){
		f += PI*2.0f;
	}

	return f;
}


function float GetPlayerHeading(){
	local Vector v;
	local Rotator r;
	local float f;

	r.Yaw = PlayerOwner.Pawn.Rotation.Yaw;
	v = vector(r);
	f = GetHeadingAngle(v);
	f = UnwindHeading(f);

	while(f < 0){
		f += PI * 2.0f;
	}

	return f;
}

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
	ActualMapRange = FMax(GameMinimap.MapRangeMax.X - GameMinimap.MapRangeMin.X, GameMinimap.MapRangeMax.Y - GameMinimap.MapRangeMin.Y);
	`log("actualmaprangeXmax: "$ GameMinimap.MapRangeMax.X);
	`log("actualMaprangeYmax: "$ GameMinimap.MapRangeMax.Y);
	`log("actualmaprangeXmin: "$ GameMinimap.MapRangeMin.X);
	`log("actualMaprangeYmin: "$ GameMinimap.MapRangeMin.Y);
	`log("MAPPOSX: "$ MapPosition.X);
	`log("MAPPOSY: "$ MapPosition.Y);
//	`log("resoscale: "$ResolutionScale);
	MapDim = MapDim * ResolutionScale;

	PlayerPos.X = (GetALocalPlayerController().Pawn.Location.Y - GameMinimap.MapCenter.Y) / ActualMapRange;
	PlayerPos.Y = (GameMinimap.MapCenter.X - GetALocalPlayerController().Pawn.Location.X) / ActualMapRange;
	`log("MAPDIM " $ MapDim);
	`log("DPC.Pawn.Location.Y " $ GetALocalPlayerController().Pawn.Location.Y);
	`log("ActualMapRange: " $ ActualMapRange);
	`log("PlayerposX " $PlayerPos.X);
	`log("PlayerposY " $PlayerPos.Y);

	ClampedPlayerPos.X = FClamp(   PlayerPos.X,
            -0.5 + (TileSize / 2.0),
            0.5 - (TileSize / 2.0));
	ClampedPlayerPos.Y = FClamp(   PlayerPos.Y,
            -0.5 + (TileSize / 2.0),
            0.5 - (TileSize / 2.0));

	`log("ClampedPlayerPos.X: "$ ClampedPlayerPos.X);
	`log("ClampedPlayerPos.Y: "$ ClampedPlayerPos.Y);
	TrueNorth = GameMinimap.GetRadianHeading();
	Playerheading = GetPlayerHeading();

	`log("TRUENORTH : "$ TrueNorth);
	if(GameMinimap.bForwardAlwaysUp)
	{
		MapRotation = PlayerHeading;
		`log("Maprotation" $ MapRotation);
		CompassRotation = PlayerHeading - TrueNorth;
		`log("CompassRotation"$ CompassRotation);
	}
	else
	{
		MapRotation = PlayerHeading - TrueNorth;
		`log("Maprotation" $ MapRotation);
		CompassRotation = MapRotation;
		`log("CompassRotation"$ CompassRotation);
	}
	DisplayPlayerPos.X = VSize(PlayerPos) * Cos( ATan(PlayerPos.X) - MapRotation);
	DisplayPlayerPos.Y = VSize(PlayerPos) * Sin( ATan(PlayerPos.Y) - MapRotation);
  
	`log("DIsplayplayerPos.X: "$DisplayPlayerPos.X);
	`log("DIsplayplayerPos.Y: "$DisplayPlayerPos.Y);

	RotPlayerPos.X = VSize(ClampedPlayerPos) * Cos( ATan2(ClampedPlayerPos.Y, ClampedPlayerPos.X) - MapRotation);
	RotPlayerPos.Y = VSize(ClampedPlayerPos) * Sin( ATan2(ClampedPlayerPos.Y, ClampedPlayerPos.X) - MapRotation);

	`log("RotPlayerPos.X: " $ RotPlayerPos.X);
	`log("RotPlayerPos.Y: "$ RotPlayerPos.Y);

	StartPos.X = FClamp(RotPlayerPos.X + (0.5 - (TileSize / 2.0)),0.0,1.0 - TileSize);
	StartPos.Y = FClamp(RotPlayerPos.Y + (0.5 - (TileSize / 2.0)),0.0,1.0 - TileSize);
	StartPos.X = FClamp(DisplayPlayerPos.X + (0.5 - (TileSize / 2.0)),TileSize/-2,1.0 - TileSize/2);
    StartPos.Y = FClamp(DisplayPlayerPos.Y + (0.5 - (TileSize / 2.0)),TileSize/-2,1.0 - TileSize/2);

	`log("StartPos.Y: " $ StartPos.Y);
	`log("Startpos.X: "$ StartPos.X);

	MapOffset.R =  FClamp(-1.0 * RotPlayerPos.X,
          -0.5 + (TileSize / 2.0),
          0.5 - (TileSize / 2.0));
	`log("Mapoffset.R: "$ MapOffset.R );
	MapOffset.G =  FClamp(-1.0 * RotPlayerPos.Y,
          -0.5 + (TileSize / 2.0),
          0.5 - (TileSize / 2.0));
	MapOffset.R =  FClamp(-1.0 * DisplayPlayerPos.X,-0.5,0.5);
	MapOffset.G =  FClamp(-1.0 * DisplayPlayerPos.Y,-0.5,0.5);
	`log("Mapoffset.G: "$ MapOffset.G );
	`log("Tilesize "$ TileSize);
	GameMinimap.Minimap.SetScalarParameterValue('MapRotation',MapRotation);
	GameMinimap.Minimap.SetScalarParameterValue('TileSize',TileSize);
	GameMinimap.Minimap.SetVectorParameterValue('MapOffset',MapOffset);
	GameMinimap.CompassOverlay.SetScalarParameterValue('CompassRotation',CompassRotation);
	Canvas.SetPos(MapPosition.X,MapPosition.Y);
	Canvas.DrawMaterialTile(GameMinimap.Minimap,
            MapDim,
            MapDim,
            StartPos.X,
            StartPos.Y,
            TileSize,
         TileSize );
	Canvas.SetPos(MapPosition.X + MapDim * (((DisplayPlayerPos.X + 0.5) - StartPos.X) / TileSize) - (BoxSize / 2),MapPosition.Y + MapDim * (((DisplayPlayerPos.Y + 0.5) - StartPos.Y) / TileSize) - (BoxSize / 2));
	Canvas.DrawBox(BoxSize,BoxSize);

	Canvas.SetPos(MapPosition.X,MapPosition.Y);
	Canvas.DrawMaterialTile(GameMinimap.CompassOverlay,MapDim,MapDim,0.0,0.0,1.0,1.0);
}


defaultproperties 
{
	MapDim=256
	TileSize=0.4
	  BoxSize=12
	 MapPosition=(X=0.000000,Y=0.000000)
	clockIcon=(Texture=Texture2D'UDKHUD.Time') 
	ResolutionScale=1.0
}
