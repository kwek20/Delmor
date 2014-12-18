/**
 * This controller controls the small version of the hard enemy. This enemy will evade the player.
 * Will transform in a large version later.
 * 
 * @author Anders Egberts
 */
class DELHardMonsterSmallController extends DELHostileController;


/**
 * Array keeping track of pathnodes
 */
var array<DELFirstQuestPathnodes> PathnodeList;

/**
 * Counter for said array
 */
var int _Pathnode;

/**
 * The current node the bot is moving to
 */
var DELFirstQuestPathnodes currentNode;

/**
 * Temporary destination
 */
var Vector tempDest;

/**
 * The player pawn
 */
var DELPawn Player;

/**
 * Minimum distance for triggering new state
 */
var int minimumDistance;

/**
 * Node the bot will end at
 */
var DELFirstQuestPathnodes endNode;

/**
 * Distance from bot to player
 */
var float selfToPlayer;

/**
 * Range to next pathnode
 */
var int closeEnough;

/**
 * Bool to check wether 1st quest is compelted or not
 */
var() bool firstQuestComplete;


/*
 * ===============================================
 * Utility functions
 * ===============================================
 */

simulated function PostBeginPlay(){
	local DELFirstQuestPathnodes P;
	super.PostBeginPlay();
			`log("POSTBEGINPLAY");
		foreach WorldInfo.AllActors(class 'DELFirstQuestPathnodes', P){
			PathnodeList.AddItem(P);
			`log("Node Added" $ P);
		}

	if(firstQuestComplete == false){
		GotoState('FirstQuestPathfinding');
	}
	else{
		GotoState('Idle');
	}

}

/**
 * Gets the next node determined by state
 */
function Vector getNextNode(){
	local Vector nodeVect;
	if(GetStateName() == 'FirstQuestPathfinding'){
		if((PathnodeList[_Pathnode] != endNode) && (_Pathnode < PathnodeList.Length)){
			`log("currentNode = " $ _Pathnode);
			currentNode = PathnodeList[_Pathnode];
			nodeVect = NodeToVect(currentNode);
			_Pathnode++;
		}
	}
	`log("currentNode Vector = " $ nodeVect);
	return nodeVect;
}

/**
 * Converts pathnode to vector location
 */
function Vector NodeToVect(DELFirstQuestPathnodes N){
	local Vector V;
	V.X = N.Location.X;
	V.Y = N.Location.Y;
	V.Z = N.Location.Z;
	return V;
}

/**
 * Function to determine wether or not a destination is reachable
 */
function bool FindNavMeshPathVect(Vector tempDest){
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;
    class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle,tempDest);
    class'NavMeshGoal_At'.static.AtLocation(NavigationHandle, tempDest,32 );
    return NavigationHandle.FindPath();
}

/*
 * ===============================================
 * Action functions
 * ===============================================
 */

/*
 * ===============================================
 * States functions
 * ===============================================
 */

state Idle{

	event tick( float deltaTime ){
		super.tick( deltaTime );
	}

	event SeePlayer (Pawn Seen){
		local Pawn Player;
		super.SeePlayer(Seen);
		//De speler is gezien
		Player = Seen;

		if( Player != none ){
			engagePlayer( Player );
		}
	}
}


/**
 * Flocks with the commander
 */
state Flock{

	event Tick( float deltaTime ){
		local vector targetLocation;

		super.Tick( deltaTime );
		
//		targetLocation = cohesion( commander );
		if ( self.distanceToPoint( targetLocation ) < pawn.GroundSpeed * deltaTime + 1 ){
			stopPawn();
		} else {
			moveTowardsPoint( targetLocation , deltaTime );
		}

//		if ( commander == none ){
//			commanderDied();
//		}
		
	}

	/**
	 * Overriden so that the pawn will no longer attack the player one sight.
	 */
	event SeePlayer( Pawn p ){
	}

	event commanderDied(){
		changeState( 'Flee' );
	}
}


auto state FirstQuestPathfinding{

	function beginState( name previousStateName ){
	`log( "Finding  path" );


	}

	event Tick(float deltaTime){
		local Pawn Player;
		Player = GetALocalPlayerController().Pawn;
		selfToPlayer = Abs(VSize(self.Pawn.Location - Player.Location));

	}


Begin:
	
	if(FindNavMeshPathVect(tempDest)){
		if(((selfToPlayer < minimumDistance) && (PathnodeList[_Pathnode] == endNode))){
			self.Pawn.GroundSpeed = 85.0;
			firstQuestComplete = true;
			GotoState('Idle');
		} else {
			self.Pawn.GroundSpeed = 400.0;
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
/*
 * ================================================
 * Common events
 * ================================================
 */

/**
 * Called when the pawn's hitpoints are less than 50% of the max value.
 */
event hitpointsBelowHalf(){
	DELHardMonsterSmallPawn( pawn ).transform(); //Transform into the hard monster.
}

/**
 * When the minions are dead, the commander will attack. Also the hard monster should transform and join the fight.
 */
event commanderOrderedAttack(){
	DELHardMonsterSmallPawn( pawn ).transform(); //Transform into the hard monster.
}

DefaultProperties
{
	minimumDistance = 800
	bIsPlayer=true
	closeEnough = 200
	isAtLast = false
	bAdjustFromWalls=true
	_Pathnode = 0
	firstQuestComplete = false
}
