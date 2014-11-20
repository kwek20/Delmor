class DELGame extends UTDeathMatch;

var String game;

DefaultProperties 
{
	//HUDType=class'Delmor.DELPlayerHud'
    HUDType=class'Delmor.DELPlayerHud'
	DefaultPawnClass = class'DELPawn'
	PlayerControllerClass=class'Delmor.DELPlayerController'
    DefaultInventory(0)=none
	bUseClassicHUD=false
	game='DELGame'
}
