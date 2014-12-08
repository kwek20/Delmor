/**
 * This controller controls the hard enemy. This enemy will try to attack the player
 * when there are not too many smaller enemies nearby.
 * If there's too many smaller enemies the hard monster will keep a safe distance between him and the player.
 * 
 * @author Anders Egberts
 */
class DELHardMonsterController extends DELHostileController;

/**
 * The interval at which the monster makes a decision like: HealPawn or GiveOrderToPawn.
 */
var float decisionInterval;

/**
 * The distance to keep from the player.
 */
var float distanceToPlayer;

/**
 * Array keeping track of pathnodes
 */
var array<Pathnode> PathnodeList;
var int _Pathnode;
var Pathnode currentNode;
var Vector tempDest;
/**
 * Range to next pathnode
 */
var int closeEnough;

/**
 * Bool to check wether 1st quest is compelted or not
 */
var bool firstQuestComplete;

/*
 * =================================
 * Utility functions
 * =================================
 */

/**
 * Gets the number of easypawns and mediumpawns near the player.
 * @return int.
 */
private function int nPawnsNearPlayer(){
	local DELEasyMonsterController ec;
	local DELMediumMonsterController mc;
	local int nPawns;
	/**
	 * The distance at wich a pawn is considered near the player.
	 */
	local float nearDistance;

	nPawns = 0;
	nearDistance = 192.0;

	//Count the easyminions
	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , ec ){
		if ( VSize( ec.Pawn.Location - attackTarget.Location ) <= nearDistance ){
			nPawns ++;
		}
	}
	//Count the mediumminions
	foreach WorldInfo.AllControllers( class'DELMediumMonsterController' , mc ){
		if ( VSize( mc.Pawn.Location - attackTarget.Location ) <= nearDistance ){
			nPawns ++;
		}
	}

	return nPawns;
}

/*
 * =================================
 * States
 * =================================
 */

state attack{
	/**
	 * Timer for decisions.
	 */
	local float timer;

	function beginState( name previousStateName ){
		super.beginState( previousStateName );

		timer = 0.0;
	}

	event tick( float deltaTime ){
		super.Tick( deltaTime );

		timer -= deltaTime;

		if ( timer <= 0.0 ){
			`log( self$" It is time to make a decision" );

			//Wait till the player has killed the easypawns before attacking
			if ( nPawnsNearPlayer() > 4 ){
				goToState( 'maintainDistanceFromPlayer' );
			}

			//Reset the timer
			timer = decisionInterval;
		}
	}
}

/**
 * In this state the mediumMonster will stay a few meters away from the player as long as there's easypawns nearby the player.
 */
state maintainDistanceFromPlayer{

	/**
	 * When the number of easymonsterpawns is smaller than this number, the medium pawn should attack.
	 */
	local int maximumPawnsNearPlayer;
	local float timer;

	function beginState( name previousStateName ){
		distanceToPlayer = 384.0;
		maximumPawnsNearPlayer = 5;
		timer = decisionInterval;

		`log( "Maintain your distance" );
	}
	
	event tick( float deltaTime ){
		local vector selfToPlayer;

		timer -= deltaTime;

		//Calculate direction
		selfToPlayer = pawn.Location - attackTarget.location;

		//Move away
		if ( calcPlayerDist(selfToPlayer) < distanceToPlayer ){
			moveInDirection( selfToPlayer , deltaTime );
			pawn.SetRotation( rotator( attackTarget.location - pawn.Location ) );
		}
		else{
			stopPawn();
		}

		//Return to the fight when the easy pawns have died.
		if ( timer <= 0.0 ){
			if ( nPawnsNearPlayer() <= maximumPawnsNearPlayer ){
				goToState( 'attack' );
			}

			//Reset timer
			timer = decisionInterval;
		}
	}

}

auto state Pathfinding{
	local int minimumDistance;
	local Vector tempDest;
	local Actor Player;
	local Vector selfToPlayer;

Begin:
	Player = GetALocalPlayerController().Pawn;
	selfToPlayer = self.Pawn.Location - Player.Location;
	if(FindNavMeshPath() && calcPlayerDist(selfToPlayer) <= minimumDistance){
		tempDest = getNextNode();
		if(calcPlayerDist(selfToPlayer) <= minimumDistance){
			NavigationHandle.SetFinalDestination(tempDest);
			FlushPersistentDebugLines();
			NavigationHandle.DrawPathCache(,true);
				if(NavigationHandle.GetNextMoveLocation(tempDest, Pawn.GetCollisionRadius())){
				DrawDebugLine(Pawn.location,tempDest,0,255,0,true);
				DrawDebugSphere(tempDest,16,20,0,255,0,true);
				MoveTo(tempDest, Player);
				}
		}
	}
	if(calcPlayerDist(selfToPlayer) <= minimumDistance && _Pathnode != PathnodeList.Length){
		Goto('Begin');
	}
	else{
		GotoState('Attack');
	}
}

simulated function PostBeginPlay(){
	local Pathnode P;
	_Pathnode = 0;
	super.PostBeginPlay();
		foreach WorldInfo.AllActors(class 'Pathnode', P){
			PathnodeList.AddItem(P);
			`log("Node Added" $ P);
		}
}

function Vector getNextNode(){
	local Vector nodeVect;
	if(_Pathnode <= PathnodeList.Length){
		currentNode = PathnodeList[_Pathnode];
		`log("currentNode = " $ _Pathnode);
	}
	nodeVect = NodeToVect(currentNode);
	`log("currentNode Vector = " $ nodeVect);
	return nodeVect;
}

function Vector NodeToVect(Pathnode N){
	local Vector V;
	V.X = N.Location.X;
	V.Y = N.Location.Y;
	V.Z = N.Location.Z;
	return V;
}


function float calcPlayerDist(Vector selfToPlayer){
	local float distanceToPlayer;
		distanceToPlayer = Abs(VSize(selfToPlayer));
	return distanceToPlayer;
}

function bool FindNavMeshPath(){
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;
    class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle,tempDest);
    class'NavMeshGoal_At'.static.AtLocation(NavigationHandle, tempDest,32 );
    return NavigationHandle.FindPath();
}

DefaultProperties
{
	decisionInterval = 0.5
	minimumDistance = 500
	bIsPlayer=true
	closeEnough = 200
	isAtLast = false
}