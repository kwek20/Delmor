/**
 * Controller voor de guard.
 * @author Bram Arts
 */
class DELGuardController extends DELNPCController;

/** 
 *  Event that is called when the goad is spawned
 *  @param inPawn
 *  @param bVehicleTransition
 */
event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    Pawn.SetMovementPhysics();
}

DefaultProperties
{
}
