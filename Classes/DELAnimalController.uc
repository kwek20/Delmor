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

	event Tick( float deltaTime ){
		if(vSize(nextLocation - self.Pawn.Location) < 100) {
			GotoState('eat');
		} else {
			moveTowardsPoint( nextLocation , deltaTime );
		}
		
		fleeFromMonsters();
	}
}

/**
 * Automaticle flee from DELHostilePawns.
 */
function fleeFromMonsters(){
	local DELHostilePawn nearbyMonster;
	nearbyMonster = getNearbyMonster();
	if ( nearbyMonster != none ){
		fleeFrom( nearbyMonster );
	}
}

/**
 * Stop fleeing
 */
function endFlee(){
	goToState( 'Eat' );
}

/**
 * The state where the goat is doing nothing but eating
 */
state eat {
	function beginState( Name previousStateName ){
		super.beginState( previousStateName );
		SetTimer(Rand(maxIdleTime)+minIdleTime, false, 'backToWalk');
	}
	event tick( float deltaTime ){
		fleeFromMonsters();
	}

	function backToWalk() {
		nextLocation = getRandomLocation();
		GotoState('walk');
	}
}

/**
 * Returns the ID of a monster that is closer to the chicken than 256.
 */
function DELHostilePawn getNearbyMonster(){
	local DELHostilePawn monster , p;
	local float smallestDistance;

	smallestDistance = 257.0;

	foreach worldInfo.AllPawns( class'DELHostilePawn' , p , pawn.Location , 256.0 ){
		if ( VSize( p.location - pawn.Location ) <= smallestDistance ){
			monster = p;
		}
	}

	return monster;
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
	return GetLocationInMoveRange();
}

function Vector GetALocation() {
	local Vector temp;
	temp.X = Self.Pawn.Location.X + lengthDirX(Rand(moveRange), Rand(360 * DegToUnrRot));
	temp.Y = Self.Pawn.Location.Y + lengthDirY(Rand(moveRange), Rand(360 * DegToUnrRot));
	temp.Z = self.Pawn.Location.Z + Rand(5000);
	return temp;
}

/**
 * Gets a random location in the moverange.
 */
function Vector GetLocationInMoveRange(){
	local Vector temp;
	temp.X = startPosition.X + lengthDirX(Rand(moveRange), Rand(360 * DegToUnrRot));
	temp.Y = startPosition.Y + lengthDirY(Rand(moveRange), Rand(360 * DegToUnrRot));
	temp.Z = startPosition.Z;// + Rand(5000);
	return temp;
}

DefaultProperties
{
	wanderRange = 2048
	moveRange = 1024
	fleeRangeToPlayer = 128
	maxIdleTime = 20
	minIdleTime = 5
}