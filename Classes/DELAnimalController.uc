/**
 * Controller of all animals.
 * @author Bram
 */

class DELAnimalController extends DELNpcController abstract;
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
 * temp value that is used to calculate the distance between the Goat and the player
 */
var float distanceToPlayer;
/**
 * a Vector where the distance is calculated between the player and Goat in vector
 */
var vector selfToPlayer;

var float fleeRangeToPlayer;
var DELPlayer player;
var float moveRange;
var int maxIdleTime;
var int minIdleTime;


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

auto state Idle {
	event Tick(float DeltaTime) {
		if(self.Pawn != none) {
			startPosition = self.Pawn.Location;
			GotoState('walk');
		}
	}
}

/**
 * state where the goat is walking to a random player
 */
state walk {
	local Vector targetLocation;
	local bool playerIsSeen;
	function beginState( Name previousStateName ){
		super.beginState( previousStateName );
		nextLocation = getRandomLocation();
		playerIsSeen = false;
	}	

	event SeePlayer(Pawn p) {
		if(p.IsA('DELPlayer')) {
			selfToPlayer = p.Location - self.Pawn.Location;
			distanceToPlayer = Abs(VSize(selfToPlayer));
			if(distanceToPlayer < fleeRangeToPlayer) {
				player = DELPlayer(p);
				targetLocation.X =  self.player.Location.X + lengthDirX(fleeRangeToPlayer, (Rotator(selfToPlayer).Yaw + 90.0) * DegToUnrRot );
				targetLocation.Y =  self.player.Location.Y + lengthDirY(fleeRangeToPlayer, (Rotator(selfToPlayer).Yaw + 90.0) * DegToUnrRot );
				targetLocation.Z = self.Pawn.Location.Z;
				playerIsSeen = true;
			}
		}
	}
	
Begin:
	sleep(0.05);
		if(vSize(targetLocation - self.Pawn.Location) < 100) {
			playerIsSeen = false;
		} else if(vSize(nextLocation - self.Pawn.Location) < 100) {
				GotoState('eat');
		} else {
			if(distanceToPlayer < fleeRangeToPlayer && playerIsSeen) {
				moveTo(targetLocation);
			} else if(NavigationHandle.PointReachable(nextLocation))
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
				nextLocation = getRandomLocation();
				GotoState('walk');
			}
		}
	//}
		
	sleep(0.1);
	goto 'Begin';
}

state flee {
	
	local rotator direction;
	local Controller C;
	local Vector targetLocation;
	function beginState( Name previousStateName ){
		super.beginState( previousStateName );
		targetLocation.X =  self.player.Location.X + lengthDirX(fleeRangeToPlayer, (Rotator(selfToPlayer).Yaw + 90.0) * DegToUnrRot );
		targetLocation.Y =  self.player.Location.Y + lengthDirY(fleeRangeToPlayer, (Rotator(selfToPlayer).Yaw + 90.0) * DegToUnrRot );
		targetLocation.Z = self.Pawn.Location.Z;
	}
}
/**
 * The state where the goat is doing nothing but eating
 */
state eat {
	function beginState( Name previousStateName ){
		super.beginState( previousStateName );
		SetTimer(Rand(maxIdleTime)+minIdleTime, false, 'backToWalk');
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
	temp = GetALocation();
	while(VSize(temp - startPosition) > wanderRange) {
		temp = GetALocation();
	}
	return temp;
}

function Vector GetALocation() {
	local Vector temp;
	temp.X = Self.Pawn.Location.X + lengthDirX(Rand(moveRange), Rand(360 * DegToUnrRot));
	temp.Y = Self.Pawn.Location.Y + lengthDirY(Rand(moveRange), Rand(360 * DegToUnrRot));
	temp.Z = self.Pawn.Location.Z;
	return temp;
}

DefaultProperties
{
	wanderRange = 2048
	moveRange = 1024
	fleeRangeToPlayer = 128
	maxIdleTime = 55
	minIdleTime = 5
}