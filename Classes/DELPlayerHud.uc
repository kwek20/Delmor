class DELPlayerHud extends UDKHUD;

var CanvasIcon clockIcon;
var float clock; 

simulated event PostBeginPlay() {
	Super.PostBeginPlay();
   clock = 30;
}

function PlayerOwnerDied(){
	local DELPlayerController PC;
    PC = getPlayer();

	PC.drawSubtitle("You have died!");
}

simulated event Tick(float DeltaTime){
	Super.Tick(DeltaTime);
	clock-=0.1;

   if(clock <= 0) {     
      clock = 30;
   }
}

function DrawHUD() {
   local DELPlayerController PC;
   super.DrawHUD();
   
   PC = getPlayer();

   //drawCrossHair();

   if (!PlayerOwner.IsDead()){
		drawHealthBar();
		DrawSubtitle(PC.subtitle);
   } else {
		//dead
   }
  
}

function drawHealthBar() {
   Canvas.DrawIcon(clockIcon, CenterX, CenterY);     

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

function DrawSubtitle(string StringMessage){
	local int X, Y;
	local float Xstring, Ystring;
	
	X = CenterX-Len(StringMessage);
	Y = SizeY/10*9;

	Canvas.TextSize(StringMessage, Xstring, Ystring);
	
	Canvas.SetPos(X, Y);
	Canvas.SetDrawColor(0, 0, 0, 120);
	
	Canvas.DrawRect(Xstring, Ystring);
	
	Canvas.SetPos(X, Y);
	Canvas.SetDrawColor(255, 255, 255, 255);
	
	Canvas.DrawText(StringMessage);
}

function log(String text){
	class'WorldInfo'.static.GetWorldInfo().Game.Broadcast(getPlayer(), text);
}

function DELPlayerController getPlayer(){
	return DELPlayerController(PlayerOwner);
}

defaultproperties {
 clockIcon=(Texture=Texture2D'UDKHUD.Time')  
}
