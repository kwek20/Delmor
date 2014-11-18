class DELPlayerController extends PlayerController;

/**
 * When the player moves the mouse. The camera will update.
 * @author Anders Egberts
 */
function UpdateRotation(float DeltaTime)
{
    local DELPawn dPawn;
	local float pitchClamp;
	pitchClamp = 10000.0;

    super.UpdateRotation(DeltaTime);

    dPawn = DELPawn(self.Pawn);

    if (dPawn != none)
    {
		//Constrain the pitch of the player's camera.
        dPawn.camPitch = Clamp( dPawn.camPitch + self.PlayerInput.aLookUp , -pitchClamp , pitchClamp );
    }
}

DefaultProperties
{
}
