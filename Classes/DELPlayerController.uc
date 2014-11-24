/**
 * Extended playercontroller that changes the camera.
 * 
 * KNOWN BUGS:
 * - Fix player movement.
 * 
 * @author Anders Egberts.
 */
class DELPlayerController extends PlayerController;

var SoundCue soundSample; 
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

DefaultProperties
{
	InputClass=class'DELPlayerInput'
}