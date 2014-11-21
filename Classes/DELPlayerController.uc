class DELPlayerController extends PlayerController
	config(Game);

var() bool canWalk, drawDefaultHud, drawBars, drawSubtitles, hudLoaded;
var() private string subtitle;
var() int subtitleTime, currentTime;

/*##########
 * STATES
 #########*/

function BeginState(Name PreviousStateName){
	self.showSubtitle("Old: " $ PreviousStateName $ " | New: " $ GetStateName());
}

auto state PlayerWaiting {
Begin:
      gotoState('Playing');
}

state Playing {
Begin:
	canWalk = true;
	drawDefaultHud = true;
	drawBars = true;
	drawSubtitles = true;
	checkHuds();
}

state End {
Begin:
	canWalk = false;
	drawDefaultHud = false;
	drawBars = false;
	drawSubtitles = true;
	checkHuds();
}

state Inventory {
 Begin:
	canWalk = false;
	drawDefaultHud = false;
	drawBars = false;
	drawSubtitles = true;
	checkHuds();
}

function swapState(name StateName){
	if (StateName == GetStateName()) return;
	gotoState(StateName);
}

/*#####################
 * Button press events
 ####################*/

exec function openInventory(){
	`log("openInventory");
	swapState('Inventory');
}

exec function closeHud(){
	`log("closeHud");
	swapState('Playing');
}

/*################
 * HUD functions
 ###############*/

function checkHuds(){
	if (getHud() == None)return;

	//`log(GetStateName() $ ":" @ canWalk @ drawDefaultHud @ drawBars @ drawSubtitles);
	getHud().interfaces.Length = 0;
	if (drawDefaultHud){
		//addInterface(class'DELInterfaceSpells');
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
	`log("Added interface " $ interface);
	getHud().interfaces.AddItem(Spawn(interface, self));
}

public function showSubtitle(string text){
	subtitle = text;
	currentTime = getSeconds();
}

/*################
 * Util functions
 ###############*/

/**
 * When the player moves the mouse. The camera will update.
 * @author Anders Egberts
 */
function UpdateRotation(float DeltaTime){
    local DELPawn dPawn;
	local float pitchClampMin , pitchClampMax;

	`log("UpdateRotation");

	if (canWalk){
		pitchClampMax = -10000.0;
		pitchClampMin = -500.0;

		super.UpdateRotation(DeltaTime);
		dPawn = DELPawn(self.Pawn);

		if (dPawn != none){
			//Constrain the pitch of the player's camera.
			dPawn.camPitch = Clamp( dPawn.camPitch + self.PlayerInput.aLookUp , pitchClampMax , pitchClampMin );
			//dPawn.camPitch = dPawn.camPitch + self.PlayerInput.aLookUp;
		}
	} else {
		//Mouse event
		`log("mouse event");
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
	subtitleTime=5
}
