class DELPlayerController extends PlayerController;

var() string subtitle;

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

public function drawSubtitle(string action){
	subtitle = action;
}

DefaultProperties
{
}
