class DELGame extends UDKGame;

var String game;
var DELMinimap GameMinimap;

function InitGame( string Options, out string ErrorMessage )
{
	local DELMinimap ThisMinimap;
	Super.InitGame(Options,ErrorMessage);
	
	foreach AllActors(class'Delmor.DELMinimap',ThisMinimap){
	GameMinimap = ThisMinimap;
	break;
	}
	
}


DefaultProperties 
{
	//HUDType=class'Delmor.DELPlayerHud'
    HUDType=class'Delmor.DELPlayerHud'
	DefaultPawnClass = class'Delmor.DELPawn'
	PlayerControllerClass=class'Delmor.DELPlayerController'
    DefaultInventory(0)=None;
	bUseClassicHUD=true
	game='DELGame'
}
