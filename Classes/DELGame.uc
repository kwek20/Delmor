class DELGame extends UTDeathMatch;

var String game;

DefaultProperties 
{
	//HUDType=class'Delmor.DELPlayerHud'
	DefaultPawnClass = class'DELPawn'
	PlayerControllerClass=class'Delmor.DELPlayerController'
	bUseClassicHUD=false
	game='DELGame'
}