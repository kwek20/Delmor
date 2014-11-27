class DELPlayerInput extends PlayerInput;

/**
 * The default rotation speed to rotate the pawn with when the player presses a or b.
 */
var float defaultRotationSpeed;
var float pawnRotationSpeed;
var bool isPaused;
simulated event postBeginPlay(){
	//super.PostBeginPlay();
	`log("### Post begin play. PlayerInput: "$self );
	setBindings();
}

/**
 * Turns the player's pawn left if not in look mode.
 * 
 * TODO:
 * Strafe when in look mode.
 */
simulated exec function turnLeft(){
	if ( !DELPawn( pawn ).bLookMode ){
		pawnRotationSpeed = -defaultRotationSpeed;
	}
}

/**
 * Turns the player's pawn right if not in look mode.
 * 
 * TODO:
 * Strafe when in look mode.
 */
simulated exec function turnRight(){
	if ( !DELPawn( pawn ).bLookMode ){
		pawnRotationSpeed = defaultRotationSpeed;
	}
}

/**
 * Perform rotation in tick event.
 */
event Tick( float deltaTime ){
	if ( pawnRotationSpeed != 0.0 ){
		rotatePawn( pawnRotationSpeed );
	}
}

/**
 * Rotates the pawn along the yaw
 * @param degrees   float   The number of unreal degrees to rotate.
 */
function rotatePawn( float degrees ){
	local Rotator newRotation;

	`log( "Rotate Pawn. Degrees: "$degrees$". Pawn.Rotation.Yaw: "$Pawn.Rotation.Yaw );

	newRotation.Roll = Pawn.Rotation.Roll;
	newRotation.Pitch = Pawn.Rotation.Pitch;
	newRotation.Yaw = Pawn.Rotation.Yaw + int( degrees );

	Pawn.SetRotation( newRotation );
	Pawn.SetDesiredRotation( newRotation );
}

/**
 * Set pawnRotationSpeed to 0.0
 */
exec function resetRotationSpeed(){
	pawnRotationSpeed = 0.0;
}

/**
 * Starts the look mode in the pawn. When in lookMode, the player can rotate the view and the pawn with the mouse.
 */
exec function startLookMode(){
	DELPawn( Pawn ).bLookMode = true;
}

/**
 * Ends the look mode.
 */
exec function endLookMode(){
	DELPawn( Pawn ).bLookMode = false;
}

exec function openInventory() {
	DELPlayerController(Pawn.Controller).openInventory();
}

exec function closeHud() {
	DELPlayerController(Pawn.Controller).closeHud();
}

exec function startSprint() {
	DelPlayer(Pawn).StartSprint();
}

exec function stopSprint(){
	DelPlayer(Pawn).StopSprint();
}
/*
exec function togglePause(){
	if(isPaused == false){
	SetPause(true);

	openInventory();
	isPaused = !isPaused;
	}
	else if(isPaused==true)
	{
		SetPause(false);
		isPaused = !isPaused;
		closeHud();
	}
}*/

exec function blockInput(){
//blockblockblock
}

/**
 * Sets all keybindings for Delmor.
 */
//Right mouse button = magix
//1,2,3 switch magic spells

function setBindings(optional name inKey, optional String inCommand, optional bool change){
	`log( "Set bindings" );
	if(!change) {
		setKeyBinding( 'A' , "turnLeft | onrelease resetRotationSpeed" );
		setKeyBinding( 'D' , "turnRight | onrelease resetRotationSpeed" );
		setKeyBinding( 'MiddleMouseButton' , "StartLookMode | OnRelease EndLookMode" );
		setKeyBinding( 'I' , "openInventory" );
		setKeyBinding('Escape', "closeHud");
		setKeyBinding('LeftShift', "startSprint | onrelease stopSprint");
		setKeyBinding('F', "blockInput");
		setKeyBinding('E', "blockInput");
		setKeyBinding('LeftControl', "blockInput");
		setKeyBinding('Spacebar', "blockInput");

	} else {
		setKeyBinding(inKey, inCommand);
	}
}
/**
 * Set a specific keybinding.
 */
function setKeyBinding( name inKey , String inCommand ){
	//local name key;
	//key = inKey;
	SetBind( inKey , inCommand );
	`log( GetBind( inKey ) );
}

DefaultProperties
{
	defaultRotationSpeed = 600.0
}
