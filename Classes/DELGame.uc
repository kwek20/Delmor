class DELGame extends UTDeathMatch;

var String game;

DefaultProperties 
{
	HUDType=class'Delmor.DELPlayerHud'
	//DefaultPawnClass = class'Delmor.DELPawn'
	PlayerControllerClass=class'Delmor.DELPlayerController'
    //DefaultInventory(0)=None
	bUseClassicHUD=true
}
