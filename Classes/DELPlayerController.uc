/**
 * Extended playercontroller that changes the camera.
 * 
 * KNOWN BUGS:
 * - Fix player movement.
 * 
 * @author Anders Egberts.
 */
class DELPlayerController extends PlayerController
	config(Game);

var SoundCue soundSample; 
var() bool canWalk, drawDefaultHud, drawBars, drawSubtitles, hudLoaded;
var() private string subtitle;
var() int subtitleTime, currentTime;
/*##########
 * STATES
 #########*/

function BeginState(Name PreviousStateName){
	super.BeginState(PreviousStateName);
	self.showSubtitle("Old: " $ PreviousStateName $ " | New: " $ GetStateName());
}

auto state PlayerWalking {
Begin:
      gotoState('Playing');
}

state Playing extends PlayerWalking{
	function BeginState(Name PreviousStateName){
		self.showSubtitle("Old: " $ PreviousStateName $ " | New: " $ GetStateName());
	}

Begin:
	canWalk = true;
	drawDefaultHud = true;
	drawBars = true;
	drawSubtitles = true;
	checkHuds();
}

state MouseState {
	function UpdateRotation(float DeltaTime){
		//draw mouse
	}

	function load(){
		canWalk=false;
		drawDefaultHud=true;
		addInterface(class'DELInterfaceMouse');
	}
}

state End extends MouseState{

Begin:
	load();
	drawBars = false;
	drawSubtitles = true;
	checkHuds();
}

state Inventory extends MouseState{

 Begin:
	load();
	drawBars = true;
	drawSubtitles = true;
	checkHuds();
}

function swapState(name StateName){
	if (StateName == GetStateName()) {
		if (StateName == 'Playing') return;
		StateName = 'Playing';
	}
	getHud().interfaces.Length = 0;
	ClientGotoState(StateName);
}

/*#####################
 * Button press events
 ####################*/

exec function openInventory(){
	swapState('Inventory');
}

exec function closeHud(){
	swapState('Playing');
}

/*################
 * HUD functions
 ###############*/

function checkHuds(){
	if (getHud() == None)return;

	if (drawDefaultHud){
		addInterface(class'DELInterfaceBar');
		//addInterface(class'DELInterfaceCompass');
	}
	if (drawSubtitles){
		addInterface(class'DELInterfaceSubtitle');
	}
	if (drawbars){
		addInterface(class'DELInterfaceHealthBars');
	}
	hudLoaded = true;
}

function addInterface(class<DELInterface> interface){
	local DELInterface delinterface;

	if (getHud() == None){`log("HUD IS NONE! check bUseClassicHud"); return;}
	`log("Added interface"@interface);
	
	delinterface = Spawn(interface, self);
	getHud().interfaces.AddItem(delinterface);
	delinterface.load(getHud());
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
function UpdateRotation(float DeltaTime)
{
    local DELPawn dPawn;
	local float pitchClampMin , pitchClampMax;
	local Rotator	DeltaRot, newRotation, ViewRotation;

	pitchClampMax = -15000.0;
	pitchClampMin = 2000.0;

    //super.UpdateRotation(DeltaTime);

    dPawn = DELPawn(self.Pawn);

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

function Pawn getPawn(){
	return self.Pawn;
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

DefaultProperties
{
	InputClass=class'DELPlayerInput'
	subtitleTime=5
}
