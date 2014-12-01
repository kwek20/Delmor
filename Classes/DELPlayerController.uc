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


var M5InvDisplay M5InvDisplay;
var bool bShowInventory;
var ScriptedTexture  scriptex;
var MaterialInstanceConstant MaterialWrapper;

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
	function UpdateRotation(float DeltaTime);

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
	
	//Temp inventory load
	showInventory();
    
}

function showInventory(){


if(M5InvDisplay!=none)
	{
		bShowInventory= !bShowInventory;
		return;
	}

	loginternal("  -- spawning M5InvDisplay");
	if(Pawn.InvManager==none){
		loginternal("  -- Pawn.InvManager null, cannot spawn");
		return;
	}
	M5InvDisplay=Spawn(class'M5InvDisplay',self); 
	M5InvDisplay.SetInventoryManager(Pawn.InvManager);

	// Now force some random objects to be in inventory. Tweak as you like...
	// But dont forget that you need to set up icons or materials for display,
	class'M5Inventory'.static.NewM5Item(Pawn,StaticMesh'Misa500.objects48.blockDiamond_48');
	class'M5Inventory'.static.NewM5Item(Pawn,StaticMesh'Misa500.objects48.blockEmerald_48');
	class'M5Inventory'.static.NewM5Item(Pawn,StaticMesh'Misa500.objects48.blockGold_48');
	class'M5Inventory'.static.NewM5Item(Pawn,StaticMesh'Misa500.objects48.brick_48');

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

	pitchClampMax = -15000.0;
	pitchClampMin = 4500.0;

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

// These four use override bindings in UDKGame/Config/DefaultInput.ini
// For the Up/Down/Left/Right arrows.
// Trouble is.. while left/right is unique, Up/Down is shared by w/s bindings
// Just override all four in that section, commenting out the old ones.
exec function M5_Moveup()
{
		WorldInfo.Game.Broadcast (self, "M5PlayerController.UP called");
		M5InvDisplay.CursorUp();
}
exec function M5_Movedown()
{
		WorldInfo.Game.Broadcast (self, "M5PlayerController.DOWN called");
		M5InvDisplay.CursorDown();
}
exec function M5_Moveleft()
{
		WorldInfo.Game.Broadcast (self, "M5PlayerController.LEFT called");
		M5InvDisplay.CursorLeft();
}
exec function M5_Moveright()
{
		WorldInfo.Game.Broadcast (self, "M5PlayerController.RIGHT called");
		M5InvDisplay.CursorRight();
}
/** 
 * "There are many other DrawHUD functions, (in this game, even!)
 *   but this one is mine"
 */
function DrawHUD(HUD H)
{
	local Canvas C;
	local int invsizex,invsizey, offsetx, offsety;
	// DrawHUD gets called on every frame refresh . SO dont debugspam.
	//loginternal("M5PlayerController: DrawHUD called (which prompts Player.DrawHUD)");
	Super.DrawHUD(H);
	
	if(M5InvDisplay==none){
		return;
	}
	
	if(bShowInventory==false){
		return;
	}

	/*I really dont want to do this MaterialInstance wrapper junk. But doing a straight
	 * DrawTile(scriptex, ...)
	 * Just doesnt seem to show anything!!
	 */

	if(MaterialWrapper==none){
		scriptex=M5InvDisplay.CanvasTexture;
		MaterialWrapper=new Class'MaterialInstanceConstant';
		
		// No visible difference. but Emissive, Unlit has a few less instructions so use that.
		//MaterialWrapper.SetParent(Material'Bolthole.Materials.MaterialBase_Emissive_Nondirectional');
		MaterialWrapper.SetParent(Material'Bolthole.Materials.MaterialBase_Emissive_Unlit');
		MaterialWrapper.SetTextureParameterValue('Texture', scriptex);	
	}

	invsizex=M5InvDisplay.WindowSizeX;
	invsizey=M5InvDisplay.WindowSizeY;
	C=H.Canvas;
	
	if((invsizex<C.Sizex) && (invsizey<C.SizeY))
	{
		offsetx=invsizex/2;
		offsety=invsizey/2;
		C.SetPos(C.Sizex/2 -offsetx, C.Sizey/2 - offsety);
		C.DrawMaterialTile(MaterialWrapper, invsizex,invsizey);
	} else {
		C.SetPos(0,0);
		C.DrawMaterialTile(MaterialWrapper, C.SizeX, C.SizeY);
	}
	
	//C.DrawTile(M5InvDisplay.CanvasTexture, invsize, invsize, 0,0, 500,500);
}


DefaultProperties
{
	InputClass=class'DELPlayerInput'
	subtitleTime=5
}
