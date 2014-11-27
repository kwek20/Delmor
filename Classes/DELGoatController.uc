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

var Vector nextLocation;

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    Pawn.SetMovementPhysics();
	startPosition = self.Pawn.Location;
}

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

function bool FindNavMeshPath(Vector goal)
{
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;
    class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle,goal);
    class'NavMeshGoal_At'.static.AtLocation(NavigationHandle, goal,32 );
    return NavigationHandle.FindPath();
}

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
