/**
 * This controller controls the hard enemy. This enemy will try to attack the player
 * when there are not too many smaller enemies nearby.
 * If there's too many smaller enemies the hard monster will keep a safe distance between him and the player.
 * 
 * @author Anders Egberts
 */
class DELHardMonsterLargeController extends DELHostileController;

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
var Actor Player;
var int minimumDistance;
var Pathnode endNode;
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

	}
		
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


state RegularPathfinding{
	local int minimumDistance;
	local Vector tempDest;
	local Actor Player;
	local Vector selfToPlayer;

	function beginState( name previousStateName ){

	Player = GetALocalPlayerController().Pawn;
	`log( "Finding  path" );
	}

Begin:
		`log('ROBROBROBROB');
	if(FindNavMeshPath(tempDest) && (calcPlayerDist(selfToPlayer) <= minimumDistance)){
		selfToPlayer = self.Pawn.Location - Player.Location;
		tempDest = getNextNode();
		NavigationHandle.SetFinalDestination(tempDest);
		FlushPersistentDebugLines();
		NavigationHandle.DrawPathCache(,true);
			if(NavigationHandle.GetNextMoveLocation(tempDest, Pawn.GetCollisionRadius())){
				DrawDebugLine(Pawn.location,tempDest,0,255,0,true);
				DrawDebugSphere(tempDest,16,20,0,255,0,true);
				MoveTo(tempDest, Player);
			}
		if(calcPlayerDist(selfToPlayer) > minimumDistance){
			`log('Jews');
			Goto 'Begin';
		}
		else{
			GotoState('Attack');
		}
	}
}



auto state FirstQuestPathfinding{
	local Vector tempDest;
	local float selfToPlayer;

	function beginState( name previousStateName ){
	`log( "Finding  path" );
	_Pathnode = 0;
	endNode = PathnodeList[PathnodeList.Length];
	}

	event Tick(float deltaTime){
		Player = GetALocalPlayerController().Pawn;
		selfToPlayer = Abs(VSize(self.Pawn.Location - Player.Location));
	}


Begin:
	
	if(FindNavMeshPath(tempDest)){
		`log("MinimumDist ="$minimumDistance);
		`log("tempdest ="$ tempDest);
		`log("selfToPlayer = "$selfToPlayer);
		if((selfToPlayer <= minimumDistance) && (PathnodeList[_Pathnode] == endNode)){
			GotoState('Attack');
		}
		else {
			`log("_Pathnode ="$_Pathnode);
			tempDest = getNextNode();
		}
		NavigationHandle.SetFinalDestination(tempDest);
		FlushPersistentDebugLines();
		NavigationHandle.DrawPathCache(,true);
			if(NavigationHandle.GetNextMoveLocation(tempDest, Pawn.GetCollisionRadius())){
				DrawDebugLine(Pawn.location,tempDest,0,255,0,true);
				DrawDebugSphere(tempDest,16,20,0,255,0,true);
				MoveTo(tempDest, Player);
			}
		Goto 'Begin';
	}
}


simulated function PostBeginPlay(){
	local Pathnode P;
	super.PostBeginPlay();
		foreach WorldInfo.AllActors(class 'Pathnode', P){
			PathnodeList.AddItem(P);
			`log("Node Added" $ P);
		}
}

function Vector getNextNode(){
	local Vector nodeVect;
	if(GetStateName() == 'FirstQuestPathfinding'){
		if(PathnodeList[_Pathnode] != endNode){
			currentNode = PathnodeList[_Pathnode];
			_Pathnode++;
			`log("currentNode = " $ _Pathnode);
		}
	}
	else if(GetStateName() == 'RegularPathfinding'){
			if(_Pathnode <= PathnodeList.Length){
				_Pathnode++;
			currentNode = PathnodeList[Rand(PathnodeList.Length)];
			`log("current (RANDOM) Node = " $ _Pathnode);
		}
		if(_Pathnode == PathnodeList.Length){
			_Pathnode = 0;
		}
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

function bool FindNavMeshPath(Vector tempDest){
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;
    class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle,tempDest);
    class'NavMeshGoal_At'.static.AtLocation(NavigationHandle, tempDest,32 );
    return NavigationHandle.FindPath();
}

DefaultProperties
{
	decisionInterval = 0.5
	minimumDistance = 300
	bIsPlayer=true
	closeEnough = 200
	isAtLast = false
	bAdjustFromWalls=true
	_Pathnode = 0;
}