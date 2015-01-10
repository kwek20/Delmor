class DELGame extends UDKGame;

var String game;
var DELMinimap GameMinimap;
var private string PendingSaveGameFileName; // Pending save game state file name
var DELPlayer PendingPlayerPawn;                 // Pending player pawn for the player controller to spawn when loading a game state
var DELSaveGameState StreamingSaveGameState;   // Save game state used for when streaming levels are waiting to be loaded

function InitGame( string Options, out string ErrorMessage ){
	local DELMinimap ThisMinimap;
	Super.InitGame(Options,ErrorMessage);
	
	ConsoleCommand("DisableAllScreenMessages");

	foreach AllActors(class'Delmor.DELMinimap',ThisMinimap){
		GameMinimap = ThisMinimap;
		break;
	}

	if (HasOption(Options, "SaveGameState")){
		PendingSaveGameFileName = ParseOption(Options, "SaveGameState");
    } else {
		PendingSaveGameFileName = "";
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
	local DELSaveGameState SaveGame;
    local DELPlayerController SPlayerController;
    local name CurrentStreamingMap;

	foreach WorldInfo.AllControllers( class'DELPlayerController' , pc ){
		DELPlayerInput( pc.PlayerInput ).setBindings();
	}

    if (PendingSaveGameFileName != "") {
		// Instance the save game state
		SaveGame = new class'DELSaveGameState';

		if (SaveGame == none){
			return;
		}

		// Attempt to deserialize the save game state object from disk
		if (class'Engine'.static.BasicLoadObject(SaveGame, PendingSaveGameFileName, true, class'DELSaveGameState'.const.VERSION)){
			// Synchrously load in any streaming levels
			if (SaveGame.StreamingMapFileNames.Length > 0){
				// Ask every player controller to load up the streaming map
				foreach self.WorldInfo.AllControllers(class'DELPlayerController', SPlayerController){
					// Stream map files now
				foreach SaveGame.StreamingMapFileNames(CurrentStreamingMap){
					SPlayerController.ClientUpdateLevelStreamingStatus(CurrentStreamingMap, true, true, true);
				}

				// Block everything until pending loading is done
				SPlayerController.ClientFlushLevelStreaming();
			}

			StreamingSaveGameState = SaveGame;                              // Store the save game state in StreamingSaveGameState
			SetTimer(0.05f, true, NameOf(WaitingForStreamingLevelsTimer));  // Wait for all streaming levels to finish loading
			
			return;
		}

		// Load the game state
		SaveGame.LoadGameState();
	}

	// Send a message to all player controllers that we've loaded the save game state
	foreach self.WorldInfo.AllControllers(class'DELPlayerController', SPlayerController){
		SPlayerController.ClientMessage("Loaded save game state from " $ PendingSaveGameFileName $ ".", 'System');
	}
	}
	super.StartMatch();
}

function WaitingForStreamingLevelsTimer()
{
    local LevelStreaming Level;
    local DELPlayerController SPlayerController;

    foreach self.WorldInfo.StreamingLevels(Level){
		// If any levels still have the load request pending, then return
		if (Level.bHasLoadRequestPending)
		{
			return;
		}
    }

    ClearTimer(NameOf(WaitingForStreamingLevelsTimer)); // Clear the looping timer
    StreamingSaveGameState.LoadGameState();             // Load the save game state
    StreamingSaveGameState = none;                      // Clear it for garbage collection

    // Send a message to all player controllers that we've loaded the save game state
    foreach self.WorldInfo.AllControllers(class'DELPlayerController', SPlayerController)
    {
		SPlayerController.ClientMessage("Loaded save game state from " $ PendingSaveGameFileName $ ".", 'System');
    }

    // Start the match
    super.StartMatch();
}

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
    local DELPlayer SpawnedPawn;

    if (NewPlayer == none || StartSpot == none)
    {
	return none;
    }

    // If there's a pending player pawn, return it, but if not, spawn a new one
    SpawnedPawn = PendingPlayerPawn == none ? Spawn(class'DELPlayer',,, StartSpot.Location) : PendingPlayerPawn;
    PendingPlayerPawn = none;

    return SpawnedPawn;
}

DefaultProperties 
{
	bDelayedStart=false
    bWaitingToStartMatch=true
    HUDType=class'Delmor.DELPlayerHud'
	DefaultPawnClass = class'Delmor.DELPlayer'
	PlayerControllerClass=class'Delmor.DELPlayerController'
    DefaultInventory(0)=none
	bUseClassicHUD=true
}