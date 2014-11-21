class DELPlayerInput extends PlayerInput;

/**
 * The default rotation speed to rotate the pawn with when the player presses a or b.
 */
var float defaultRotationSpeed;
var float pawnRotationSpeed;

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
DefaultProperties
{
	defaultRotationSpeed = 600.0
}
