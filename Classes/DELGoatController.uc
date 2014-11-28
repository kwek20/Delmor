/**
 * Controller of the goat
 * @author Bram
 */
class DELGoatController extends DELAnimalController;
/**
 *  the range in which the goat will wander arount his start position
 */
var int wanderRange;
/**
 * the start position van the goat.
 */
var Vector startPosition;
/**
 * A position in which the goat must walk to get to his final position.
 */
var Vector tempDest;
/**
 * Location where the goat should walk next to
 */
var Vector nextLocation;
/** 
 *  Event that is called when the goad is spawned
 *  @param inPawn
 *  @param bVehicleTransition
 */
event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    Pawn.SetMovementPhysics();
	startPosition = self.Pawn.Location;
}
/**
 * state where the goat is walking to a random player
 */
auto state walk {
	function beginState( Name previousStateName ){
		super.beginState( previousStateName );
		nextLocation = getRandomLocation();
	}
	//event Tick(float DeltaTime) {
	
Begin:
	sleep(0.05);
		if(vSize(nextLocation - self.Pawn.Location) < 100) {
				GotoState('eat');
		} else {
			if(NavigationHandle.PointReachable(nextLocation))
			{
				moveTo(nextLocation);
			} else if( FindNavMeshPath(nextLocation) ){
				NavigationHandle.SetFinalDestination(nextLocation);
				FlushPersistentDebugLines();
				if( NavigationHandle.GetNextMoveLocation(tempDest, Pawn.GetCollisionRadius()))
				{
					MoveTo(tempDest);
				}
			} else {
				`log(self $ 'NEE zelfs dat  gaat nu niet meer');
				nextLocation = getRandomLocation();
				GotoState('walk');
			}
		}
	//}
		
	sleep(0.1);
	goto 'Begin';
}
/**
 * The state where the goat is doing nothing but eating
 */
state eat {
	function beginState( Name previousStateName ){
		super.beginState( previousStateName );
		SetTimer(Rand(10), false, 'backToWalk');
	}
	function backToWalk() {
		nextLocation = getRandomLocation();
		GotoState('walk');
	}
}
/**
 * A function for A* to get a next path to the goal
 * @param goal the location where the goat should walk to.
 */
function bool FindNavMeshPath(Vector goal)
{
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;
    class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle,goal);
    class'NavMeshGoal_At'.static.AtLocation(NavigationHandle, goal,32 );
    return NavigationHandle.FindPath();
}
/**
 * A function to get a random location around its start position.
 * @return a Vector location
 */
function Vector getRandomlocation() {
	local Vector temp;
	temp.X = Rand(wanderRange*2) - wanderRange;
	temp.Y = Rand(wanderRange*2) - wanderRange;
	temp = temp + startPosition;
	return temp;
}

DefaultProperties
{
	wanderRange = 2048
}
