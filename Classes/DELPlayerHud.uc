class DELPlayerHud extends UTHUD;

var CanvasIcon clockIcon;
var int clock; 

event PostBeginPlay() {
   SetTimer( 1, true );
   clock = 30;
}

function Timer() {
  clock--;

  if(clock <= 0) {     
     clock = 30;
  }
}

function DrawHUD() {
   super.DrawHUD();    

   Canvas.DrawIcon(clockIcon, 0, 0);     

   Canvas.Font = class'Engine'.static.GetLargeFont();      
   Canvas.SetDrawColor(255, 255, 255); // White
   Canvas.SetPos(70, 15);
   
   Canvas.DrawText(clock);

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

defaultproperties {
 clockIcon=(Texture=Texture2D'UDKHUD.Time')  
}
