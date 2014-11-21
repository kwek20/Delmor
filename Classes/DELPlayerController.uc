class DELPlayerController extends PlayerController;

var() bool canWalk, drawDefaultHud, drawBars, hudLoaded;
var() private string subtitle;
var() int subtitleTime, currentTime;

function checkHuds(){
	if (getHud() == None)return; 

	`log(GetStateName() $ ": " $ canWalk $ " " $ drawDefaultHud $ " " $ drawBars);
	getHud().interfaces.Length = 0;
	if (drawDefaultHud){
		addInterface(class'DELInterfaceSubtitle');
	}
	if (drawbars){
		addInterface(class'DELInterfaceHealthBars');
	}
	hudLoaded = true;
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
	checkHuds();
}

function addInterface(class<DELInterface> interface){
	`log("Added interface " $ interface);
	getHud().interfaces.AddItem(Spawn(interface, self));
}

function DELPlayerHud getHud(){
	return DELPlayerHud(myHUD);
}

function Pawn getPawn(){
	return self.Pawn;
}

/**
 * When the player moves the mouse. The camera will update.
 * @author Anders Egberts
 */
function UpdateRotation(float DeltaTime)
{
    local DELPawn dPawn;
	local float pitchClampMin , pitchClampMax;
	pitchClampMax = -10000.0;
	pitchClampMin = -500.0;

    super.UpdateRotation(DeltaTime);
    dPawn = DELPawn(self.Pawn);

    if (dPawn != none){
		//Constrain the pitch of the player's camera.
        dPawn.camPitch = Clamp( dPawn.camPitch + self.PlayerInput.aLookUp , pitchClampMax , pitchClampMin );
		//dPawn.camPitch = dPawn.camPitch + self.PlayerInput.aLookUp;
    }
}        

public function showSubtitle(string text){
	subtitle = text;
	currentTime = getSeconds();
}

public function String getSubtitle(){
	if (subtitle == "" || currentTime == 0) return "";

	if (currentTime + subtitleTime < getSeconds()){
		subtitle = "";
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
