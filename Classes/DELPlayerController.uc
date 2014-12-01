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

/*##########
 * STATES
 #########*/

function BeginState(Name PreviousStateName){
	super.BeginState(PreviousStateName);
	self.showSubtitle("Old: " $ PreviousStateName $ " | New: " $ GetStateName());
}

auto state PlayerWalking {
	function swap(){
		gotoState('Playing');
	}

Begin:
	SetTimer(FInterpTo(1, 3 ,WorldInfo.DeltaSeconds,0.1), false, 'swap'); 
	//cheating way to make the canvas load properly before loading interfaces
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
	function UpdateRotation(float DeltaTime);   

	exec function StartFire(optional byte FireModeNum){}

	simulated function StopFire(optional byte FireModeNum ){
		local DELPlayerInput input;
		input = DELPlayerInput(getHud().PlayerOwner.PlayerInput);

		if(FireModeNum == 0){
			//Left
			onMousePress(input.MousePosition);
		} else if(FireModeNum == 1){
			//Right
			onMousePress(input.MousePosition);
		}
	}

	function load(){
		canWalk=false;
		drawDefaultHud=true;
		addInterfacePriority(class'DELInterfaceMouse', HIGH);
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
	`log("-- Switching state to "$StateName$"--");
	getHud().clearInterfaces();
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

public function onMousePress(IntPoint pos){
	local DELinterface interface;
	local array<DELInterface> interfaces;

	interfaces = getHud().getInterfaces();
	foreach interfaces(interface){
		if (DELInterfaceInteractible(interface) != None){
			DELInterfaceInteractible(interface).onClick(getHud(), pos);
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
	addInterfacePriority(interface, NORMAL);
}

function addInterfacePriority(class<DELInterface> interface, EPriority priority){
	local DELInterface delinterface;

	if (getHud() == None){`log("HUD IS NONE! check bUseClassicHud"); return;}
	`log("Added interface"@interface);
	
	delinterface = Spawn(interface, self);
	getHud().addInterface(delinterface, priority);
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

	pitchClampMax = -10000.0;
	pitchClampMin = -500.0;

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
