class DELGame extends UTDeathMatch;

var String game;

/**
 * Extended the startMatch function. The game will now search for DELPlayerInput
 * And make it execute the setBindings() function so that we have the special Delmor
 * keybindings.
 */
function startMatch(){
	//Get the player input
	local DELPlayerController pc;

	super.StartMatch();

	foreach WorldInfo.AllControllers( class'DELPlayerController' , pc ){
		`log( "pc.playerInput: "$pc.PlayerInput );
		DELPlayerInput( pc.PlayerInput ).setBindings();
	}
}

DefaultProperties 
{
	//HUDType=class'Delmor.DELPlayerHud'
    HUDType=class'Delmor.DELPlayerHud'
	DefaultPawnClass = class'DELPlayer'
	PlayerControllerClass=class'Delmor.DELPlayerController'
    DefaultInventory(0)=none
	bUseClassicHUD=false
	game='DELGame'
}
