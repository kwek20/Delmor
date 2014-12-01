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
	DefaultPawnClass = class'Delmor.DELPlayer'
	PlayerControllerClass=class'Delmor.DELPlayerController'
    DefaultInventory(0)=none
	bUseClassicHUD=true
}
