class DELPlayerInput extends PlayerInput;

/**
 * The default rotation speed to rotate the pawn with when the player presses a or b.
 */
var float defaultRotationSpeed;
var float pawnRotationSpeed;
/**
 * An instance of DELmath. This instance will later be used to execute various mathematical functions.
 */
var DELMath math;

// Stored mouse position. Set to private write as we don't want other classes to modify it, but still allow other classes to access it.
var PrivateWrite IntPoint MousePosition; 

simulated event postBeginPlay(){
	//super.PostBeginPlay();
	`log("### Post begin play. PlayerInput: "$self );
	setBindings();
	`log( ">>>>>>>>>>>>>>>>>>>>> Spawn DELMath" );
	math = spawn( class'DELMath' );
	`log( "math: "$math );
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
 * Move in the camera's direction.
 */
simulated exec function moveForward(){
	local Vector camToPawn;
	if ( Pawn != none ){
		camToPawn = cameraToPawn( 0.0 );
		if ( !DELPawn( pawn ).bLookMode ){
			//Pawn.SetRotation( Rotator( camToPawn ) );
			rotatePawnToDirection( Rotator( camToPawn ).Yaw , 1200 );
		}
		//Pawn.Velocity = Normal( camToPawn );
	}
}
/**
 * Move right in aspect to the camera.
 */
simulated exec function moveRight(){
	local Vector camToPawn;
	if ( Pawn != none ){
		camToPawn = cameraToPawn( 90.0 );
		if ( !DELPawn( pawn ).bLookMode ){
			//Pawn.SetRotation( Rotator( camToPawn ) );
			rotatePawnToDirection( Rotator( camToPawn ).Yaw , 1200 );
		}
		//Pawn.Velocity = Normal( camToPawn );
	}
}
/**
 * Move left in aspect to the camera.
 */
simulated exec function moveLeft(){
	local Vector camToPawn;
	if ( Pawn != none ){
		camToPawn = cameraToPawn( -90.0 );
		if ( !DELPawn( pawn ).bLookMode ){
			//Pawn.SetRotation( Rotator( camToPawn ) );
			rotatePawnToDirection( Rotator( camToPawn ).Yaw , 1200 );
		}
		//Pawn.Velocity = Normal( camToPawn );
	}
}
/**
 * Move down in aspect to the camera.
 */
simulated exec function moveBackward(){
	local Vector camToPawn;
	if ( Pawn != none ){
		camToPawn = cameraToPawn( -180.0 );
		if ( !DELPawn( pawn ).bLookMode ){
			//Pawn.SetRotation( Rotator( camToPawn ) );
			rotatePawnToDirection( Rotator( camToPawn ).Yaw , 1200 );
		}
		//Pawn.Velocity = Normal( camToPawn );
	}
}

/*
 * ========================================
 * Start moving function.
 * ========================================
 */

/**
 * Goes to state movingForward
 */
exec function startMovingForward(){
	goToState( 'movingForward' );
}

/**
 * Goes to state movingLeft
 */
exec function startMovingLeft(){
	goToState( 'movingLeft' );
}

/**
 * Goes to state movingLeft
 */
exec function startMovingRight(){
	goToState( 'movingRight' );
}
/**
 * Goes to state movingBackward
 */
exec function startMovingBackward(){
	goToState( 'movingBackward' );
}

/**
 * This function should rotate the playerinput's pawn along the yaw-axis to the target-yaw.
 * @param targetYaw	    int The targetYaw in unrealDegrees.
 * @param rotationSpeed int The number of unrealdegrees to rotate per tick.
 */
function rotatePawnToDirection( int targetYaw , int rotationSpeed ){
	local int yaw;
	local rotator newRotation;

	//Spawn a math
	if ( math == none ){
		math = spawn( class'DELMath' );
	}

	yaw = pawn.Rotation.Yaw;

	if ( yaw < targetYaw - rotationSpeed || yaw > targetYaw + rotationSpeed ){
        yaw += math.sign( math.modulo( ( ( targetYaw - math.modulo( yaw , 360 * DegToUnrRot ) ) + 540 * DegToUnrRot ) , 360 * DegToUnrRot ) - 180 * DegToUnrRot ) * rotationSpeed;
	}
    else{
        yaw = targetYaw;
    }

	newRotation.Pitch = pawn.Rotation.Pitch;
	newRotation.Roll = pawn.Rotation.Roll;
	newRotation.Yaw = yaw;

	pawn.SetRotation( newRotation );
}

/**
 * Calculates a vector based on the pawn's location and the player's camera's location.
 * Additionally you can set an offset.
 */
function vector cameraToPawn( float offSet ){
	local vector camPositionPlusOffset;

	camPositionPlusOffset.X = Pawn.Location.X + lengthDirX( 80 , - ( Rotation.Yaw + offset * DegToUnrRot ) );
	camPositionPlusOffset.Y = Pawn.Location.Y + lengthDirY( 80 , - ( Rotation.Yaw + offset * DegToUnrRot ) );
	camPositionPlusOffset.Z = Pawn.Location.Z;

	return camPositionPlusOffset - Pawn.location;
}

/**
 * This function calculates a new x based on the given direction.
 * @param   dir Float   The direction in UnrealDegrees.
 */
private function float lengthDirX( float len , float dir ){
	local float Radians;
	Radians = UnrRotToRad * dir;

	return len * cos( Radians );

}

/**
 * This function calculates a new y based on the given direction.
 * @param   dir Float   The direction in UnrealDegrees.
 */
private function float lengthDirY( float len , float dir ){
	local float Radians;
	Radians = UnrRotToRad * dir;

	return len * -sin( Radians );

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
	//Pawn.SetDesiredRotation( newRotation );
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
	//goToState( 'idle' );
}

exec function openInventory() {
	DELPlayerController(Pawn.Controller).openInventory();
}

exec function closeHud() {
	DELPlayerController(Pawn.Controller).closeHud();
}

state movingForward{
	event tick( float deltaTime ){
		moveForward();
	}
	/**
	 * Exits the movingForward state.
	 */
	exec function stopMovingForward(){
		goToState( 'idle' );
	}
}
state movingBackward{
	event tick( float deltaTime ){
		moveBackward();
	}
	/**
	 * Exits the movingBackward state.
	 */
	exec function stopMovingBackward(){
		goToState( 'idle' );
	}
}

state movingLeft{
	event tick( float deltaTime ){
		moveLeft();
	}
	/**
	 * Exits the movingLeft state.
	 */
	exec function stopMovingLeft(){
		goToState( 'idle' );
	}
}

state movingRight{
	event tick( float deltaTime ){
		moveRight();
	}
	/**
	 * Exits the movingRight state.
	 */
	exec function stopMovingRight(){
		goToState( 'idle' );
	}
}

exec function numberPress(name inKey){
	DELPlayerController(Pawn.Controller).onNumberPress(int(string(inKey)));
}

/**
 * Sets all keybindings for Delmor.
 */
function setBindings(optional name inKey, optional String inCommand, optional bool change){
	`log( "Set bindings" );
	if(!change) {
		setKeyBinding( 'W' , "startMovingForward | Axis aBaseY Speed=1.0 | OnRelease stopMovingForward" );
		setKeyBinding( 'A' , "startMovingLeft | Axis aBaseY Speed=1.0 | OnRelease stopMovingLeft" );
		setKeyBinding( 'D' , "startMovingRight | Axis aBaseY Speed=1.0 | OnRelease stopMovingRight" );
		setKeyBinding( 'S' , "startMovingBackward | Axis aBaseY Speed=1.0 | OnRelease stopMovingBackward" );
		setKeyBinding( 'MiddleMouseButton' , "StartLookMode | OnRelease EndLookMode" );
		setKeyBinding( 'I' , "openInventory" );
		setKeyBinding('Escape', "closeHud");

		setKeyBinding('one', "numberPress 1");
		setKeyBinding('two', "numberPress 2");
		setKeyBinding('three', "numberPress 3");
		setKeyBinding('four', "numberPress 4");
		setKeyBinding('five', "numberPress 5");
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
	defaultRotationSpeed = 300.0
}
