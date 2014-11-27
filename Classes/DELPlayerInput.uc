class DELPlayerInput extends PlayerInput;

/**
 * The default rotation speed to rotate the pawn with when the player presses a or b.
 */
var float defaultRotationSpeed;
var float pawnRotationSpeed;

// Stored mouse position. Set to private write as we don't want other classes to modify it, but still allow other classes to access it.
var PrivateWrite IntPoint MousePosition; 

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

/**
 * Sets all keybindings for Delmor.
 */
function setBindings(optional name inKey, optional String inCommand, optional bool change){
	`log( "Set bindings" );
	if(!change) {
		setKeyBinding( 'A' , "turnLeft | onrelease resetRotationSpeed" );
		setKeyBinding( 'D' , "turnRight | onrelease resetRotationSpeed" );
		setKeyBinding( 'MiddleMouseButton' , "StartLookMode | OnRelease EndLookMode" );
		setKeyBinding( 'I' , "openInventory" );
		setKeyBinding('Escape', "closeHud");
	} else {
		setKeyBinding(inKey, inCommand);
	}
}

function setMousePos(int x, int y){
	// Add the aMouseX to the mouse position and clamp it within the viewport width
    MousePosition.X = Clamp(x, 0, myHUD.SizeX); 
    // Add the aMouseY to the mouse position and clamp it within the viewport height
    MousePosition.Y = Clamp(y, 0, myHUD.SizeY); 
}

event PlayerInput(float DeltaTime){
  // Handle mouse 
  // Ensure we have a valid HUD
  if (myHUD != None) {
    // Add the aMouseX to the mouse position and clamp it within the viewport width
    MousePosition.X = Clamp(MousePosition.X + aMouseX, 0, myHUD.SizeX); 
    // Add the aMouseY to the mouse position and clamp it within the viewport height
    MousePosition.Y = Clamp(MousePosition.Y - aMouseY, 0, myHUD.SizeY); 
  }

  Super.PlayerInput(DeltaTime);
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
