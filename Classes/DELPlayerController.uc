/**
 * Extended playercontroller that changes the camera.
 *
 * KNOWN BUGS:
 * - Fix player movement.
 *
 * @author Anders Egberts.
 */
class DELPlayerController extends PlayerController dependson(DELInterface)
	config(Game);

var SoundCue soundSample;
var() bool canWalk, drawDefaultHud, drawBars, drawSubtitles, hudLoaded;

var() private string subtitle;
var() int subtitleTime, currentTime;

var name previousState;

// Mouse event enum
enum EMouseEvent {
	LeftMouseButton,
	RightMouseButton,
	MiddleMouseButton,
	ScrollWheelUp,
	ScrollWheelDown,
};

/*##########
 * STATES
 #########*/

function BeginState(Name PreviousStateName){
	super.BeginState(PreviousStateName);
	self.showSubtitle("Old: " $ PreviousStateName $ " | New: " $ GetStateName());
}

auto state PlayerWalking {
Begin:
	Sleep(0.1); swapState('MainMenu');
}

state Playing extends PlayerWalking{
	function BeginState(Name PreviousStateName){
		canWalk = true;
		drawDefaultHud = true;
		drawBars = true;
		drawSubtitles = true;
		checkHuds();
		self.showSubtitle("Old: " $ PreviousStateName $ " | New: " $ GetStateName());
	}

Begin:
}

state BaseState {

}

state MouseState extends BaseState{
	function UpdateRotation(float DeltaTime);
	exec function StartFire(optional byte FireModeNum);
	exec function StopFire(optional byte FireModeNum);

	function BeginState(Name PreviousStateName){
		super.BeginState(PreviousStateName);
		canWalk=false;
		drawDefaultHud=true;
		drawBars = false;
		drawSubtitles = true;
		addInterfacePriority(class'DELInterfaceMouse', HIGH);
	}

Begin:
}

state MainMenu extends MouseState {
	function BeginState(Name PreviousStateName){
		super.BeginState(PreviousStateName);
		drawDefaultHud = false;
		drawSubtitles = false;
		addInterface(class'DELInterfaceMainMenu');
		checkHuds();

		SetPause(true);
	}

	function goToPreviousState(){}
}

state Pauses extends MouseState{

	function BeginState(Name PreviousStateName){
		super.BeginState(PreviousStateName);
		addInterface(class'DELInterfacePause');
		checkHuds();
	}

Begin:
}

state Questlog extends MouseState{
	function BeginState(Name PreviousStateName){
		super.BeginState(PreviousStateName);
		drawDefaultHud = false;
		addInterface(class'DELInterfaceQuestLog');
		checkHuds();
	}

Begin:
}

state Map extends MouseState{
	function BeginState(Name PreviousStateName){
		super.BeginState(PreviousStateName);
		drawDefaultHud = false;
		addInterface(class'DELInterfaceMap');
		checkHuds();
	}

Begin:
}

state Credits extends BaseState{
	function BeginState(Name PreviousStateName){
		super.BeginState(PreviousStateName);
		drawDefaultHud = false;
		canWalk=false;
		addInterface(class'DELInterfaceCredits');
		checkHuds();
	}
}

state End extends MouseState{
	
}

state Inventory extends MouseState{

	function BeginState(Name PreviousStateName){
		super.BeginState(PreviousStateName);
		drawBars = true;
		addInterface(class'DELInterfaceInventory');
		checkHuds();
	}

Begin:
}

function swapState(name StateName){
	if (StateName == GetStateName()) {
		if (StateName == 'Playing') {
			StateName = 'Pauses';
		} else {
			StateName = 'Playing';
		}
	}
	`log("-- Switching state to "$StateName$"--");
	getHud().clearInterfaces();

	previousState = getStateName();
	GotoState(StateName);
}

function goToPreviousState(){
	swapState(previousState);
}

/*#####################
 * Button press events
 ####################*/

exec function openInventory(){
	swapState('Inventory');
}

exec function closeHud(){
	if (previousState == 'PlayerWalking') return;
	swapState('Playing');
}

public function onNumberPress(int key){
	local DELinterface interface;
	local array<DELInterface> interfaces;

	interfaces = getHud().getInterfaces();
	foreach interfaces(interface){
		if (DELInterfaceInteractible(interface) != None){
			DELInterfaceInteractible(interface).onKeyPress(getHud(), key);
		}
	}
}

public function onMouseUse(DELInputMouseStats stats){
	local DELinterface interface;
	local array<DELInterface> interfaces;

	interfaces = getHud().getInterfaces();
	foreach interfaces(interface){
		if (DELInterfaceInteractible(interface) != None){
			DELInterfaceInteractible(interface).onMouseUse(getHud(), stats);
		}
	}
}

/*################
 * HUD functions
 ###############*/

function checkHuds(){
	if (getHud() == None)return;

	if (drawDefaultHud){
		addInterface(class'DELInterfaceBar');
		addInterface(class'DELInterfaceCompass');
	}
	if (drawSubtitles){
		addInterfacePriority(class'DELInterfaceSubtitle', HIGH);
	}
	if (drawbars){
		addInterface(class'DELInterfaceHealthBars');
		addInterfacePriority(class'DELInterfaceHealthBarFloating', LOW);
	}
	hudLoaded = true;
}

function addInterface(class<DELInterface> interface){
	addInterfacePriority(interface, NORMAL);
}

function addInterfacePriority(class<DELInterface> interface, EPriority priority){
	local DELInterface delinterface;

	if (getHud() == None){`log("HUD IS NONE! check bUseClassicHud"); return;}
	`log("Added interface"@interface);

	delinterface = Spawn(interface, self);
	getHud().addInterface(delinterface, priority);
}

public function showSubtitle(string text){
	subtitle = text;
	currentTime = getSeconds();
}

/*################
 * Util functions
 ###############*/

simulated function PostBeginPlay() {

	super.PostBeginPlay();
}

/**
 * Overriden function from PlayerController. In this version the pawn will not rotate with
 * the camera. However when the player moves the mouse, the camera will rotate.
 * @author Anders Egberts
 */
function UpdateRotation(float DeltaTime){
    local DELPlayer dPawn;
	local float pitchClampMin , pitchClampMax;
	local Rotator	DeltaRot, newRotation, ViewRotation;

	if ( pawn == none ) return;

	pitchClampMax = -15000.0;
	pitchClampMin = 4500.0;

    //super.UpdateRotation(DeltaTime);

    dPawn = DELPlayer( pawn );

	if (canWalk){
		ViewRotation = Rotation;

		// Calculate Delta to be applied on ViewRotation
		DeltaRot.Yaw	= PlayerInput.aTurn;
		DeltaRot.Pitch	= PlayerInput.aLookUp;

		ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
		SetRotation(ViewRotation);

		ViewShake( deltaTime );

		NewRotation = ViewRotation;
		NewRotation.Roll = Rotation.Roll;

		if (dPawn != none){
			//Constrain the pitch of the player's camera.
			dPawn.camPitch = Clamp( dPawn.camPitch + self.PlayerInput.aLookUp , pitchClampMax , pitchClampMin );
			//dPawn.camPitch = dPawn.camPitch + self.PlayerInput.aLookUp;
		}
	} else {
		//Mouse event
	}
}

/*##########
 * Getters
 #########*/

function DELPlayerHud getHud(){
	return DELPlayerHud(myHUD);
}

function DELPawn getPawn(){
	return DELPawn(self.Pawn);
}

public function String getSubtitle(){
	local int totalTime;
	if (subtitle == "" || currentTime == 0) return "";

	totalTime = currentTime+subtitleTime;

	//time less then seconds or time after the 59 seconds, so check adding+60 starting from 0
	if (totalTime <= getSeconds() + (totalTime > 59 && getSeconds() < currentTime) ? 60 : 0){
		subtitle = "";
		currentTime = 0;
	}

	return subtitle;
}

public function int getSeconds(){
	local int sec, a;
	GetSystemTime(a,a,a,a,a,a,sec,a);
	return sec;
}

exec function AddItem(string item, int amount){
	AddToInventory(item, amount);
}

function AddToInventory(string item, int amount) {
    if (amount > 20) {
		`log("Amount to big");
    } else {
		switch (item) {
			case "herb":
				addHerb(amount);
			break;

			case "ore":
				addOre(amount);
			break;

			default:
			break;
			}
	}
}

function addHerb(int amount) {
	getPawn().UManager.AddInventory(class'DELItemHerb', amount);
}

function addOre(int amount) {
	getPawn().UManager.AddInventory(class'DELItemOre', amount);
}

exec function SaveGame(string FileName)
{
    local DELSaveGameState GameSave;

    // Instance the save game state
    GameSave = new class'DELSaveGameState';

    if (GameSave == None)
    {
		return;
    }

    ScrubFileName(FileName);    // Scrub the file name
    GameSave.SaveGameState();   // Ask the save game state to save the game

    // Serialize the save game state object onto disk
    if (class'Engine'.static.BasicSaveObject(GameSave, FileName, true, class'DELSaveGameState'.const.VERSION))
    {
        // If successful then send a message
		ClientMessage("Saved game state to " $ FileName $ ".", 'System');
    }
}

exec function LoadGame(string FileName)
{
    local DELSaveGameState GameSave;

    // Instance the save game state
    GameSave = new class'DELSaveGameState';

    if (GameSave == None)
    {
		return;
    }

    // Scrub the file name
    ScrubFileName(FileName);

    // Attempt to deserialize the save game state object from disk
    if (class'Engine'.static.BasicLoadObject(GameSave, FileName, true, class'DELSaveGameState'.const.VERSION))
    {
        // Start the map with the command line parameters required to then load the save game state
		ConsoleCommand("start " $ GameSave.PersistentMapFileName $ "?Game=DELSaveGameState.DELGame?DELSaveGameState=" $ FileName);
    }
	GameSave.LoadGameState();
}

function ScrubFileName(out string FileName)
{
    // Add the extension if it does not exist
    if (InStr(FileName, ".sav",, true) == INDEX_NONE)
    {
		FileName $= ".sav";
    }

    FileName = Repl(FileName, " ", "_");                            // If the file name has spaces, replace then with under scores
    FileName = class'DELSaveGameState'.const.SAVE_LOCATION $ FileName; // Prepend the filename with the save folder location

	`log(FileName);
}


///////////////////////////////////////////////////
///////////////////////////////////////////////////
/**
 * This exec function will save the game state to the file name provided.
 *
 * @param      FileName      File name to save the SaveGameState to
 */
exec function SaveGameState(string FileName)
{
  local DELSaveGameState SaveGameState;

  // Instance the save game state
  SaveGameState = new () class'DELSaveGameState';
  if (SaveGameState == None)
  {
    return;
  }

  // Scrub the file name
  ScrubFileName(FileName);

  // Ask the save game state to save the game
  SaveGameState.SaveGameState();

  // Serialize the save game state object onto disk
  if (class'Engine'.static.BasicSaveObject(SaveGameState, FileName, true, class'DELSaveGameState'.const.VERSION))
  {
    // If successful then send a message
    ClientMessage("Saved game state to "$FileName$".", 'System');
  }
}

/**
 * This exec function will load the game state from the file name provided
 *
 * @param    FileName    File name of load the SaveGameState from
 */
exec function LoadGameState(string FileName)
{
  local DELSaveGameState SaveGameState;


  // Instance the save game state
  SaveGameState = new () class'DELSaveGameState';
  if (SaveGameState == None)
  {
    return;
  }

  // Scrub the file name
  ScrubFileName(FileName);

  // Attempt to deserialize the save game state object from disk
  if (class'Engine'.static.BasicLoadObject(SaveGameState, FileName, true, class'DELSaveGameState'.const.VERSION))
  {
  }

  SaveGameState.LoadGameState();
}



DefaultProperties
{
	InputClass=class'DELPlayerInput'
	subtitleTime=5
}
