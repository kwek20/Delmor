class DELPlayerHud extends UDKHUD;

var CanvasIcon clockIcon;
var float clock; 

simulated event PostBeginPlay() {
	Super.PostBeginPlay();
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
   drawHealthBar();
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

defaultproperties {
 clockIcon=(Texture=Texture2D'UDKHUD.Time')  
}
