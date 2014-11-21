/**
 * Extended playercontroller that changes the camera.
 * 
 * KNOWN BUGS:
 * - Fix player movement.
 * 
 * @author Anders Egberts.
 */
class DELPlayerController extends PlayerController;

simulated event postBeginPlay(){
	super.PostBeginPlay();
	`log("Post begin play" );
	setBindings();
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

	ViewRotation = Rotation;


	// Calculate Delta to be applied on ViewRotation
	DeltaRot.Yaw = PlayerInput.aTurn;
	DeltaRot.Pitch	= PlayerInput.aLookUp;

	ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
	SetRotation(ViewRotation);

	ViewShake( deltaTime );
	
	NewRotation = ViewRotation;
	NewRotation.Roll = Rotation.Roll;

    if (dPawn != none)
    {
		//Constrain the pitch of the player's camera.
        dPawn.camPitch = Clamp( dPawn.camPitch + self.PlayerInput.aLookUp , pitchClampMax , pitchClampMin );
		//dPawn.camPitch = dPawn.camPitch + self.PlayerInput.aLookUp;
    }
}

simulated exec function turnLeft(){
	`log( self$" TurnLeft" );
}

simulated exec function turnRight(){
	`log( self$" TurnRight" );
}

/**
 * Sets all keybindings for Delmor.
 */
function setBindings(){
	`log( "Set bindings" );
	//setKeyBinding( 'w' , "moveForward" );
	setKeyBinding( 'A' , "turnLeft" );
	setKeyBinding( 'D' , "turnRight" );
}
/**
 * Set a specific keybinding.
 */
function setKeyBinding( name inKey , String inCommand ){
	//local name key;
	//key = inKey;
	self.PlayerInput.SetBind( inKey , inCommand );
}

DefaultProperties
{
	InputClass=class'DELPlayerInput'
}