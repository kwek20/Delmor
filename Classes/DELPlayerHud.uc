class DELPlayerHud extends UDKHUD;

var array< DELInterface > interfaces;

simulated event PostBeginPlay() {
	Super.PostBeginPlay();

	`log("PostBeginPlay HUD"); 
}

function PlayerOwnerDied(){
	local DELPlayerController PC;
    PC = getPlayer();
	PC.gotoState('End');
}

simulated event Tick(float DeltaTime){
	Super.Tick(DeltaTime);
}

function PostRender(){
	local DELInterface interface;
	super.PostRender();

	foreach interfaces(interface){
		interface.draw(self);
	}
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

}
