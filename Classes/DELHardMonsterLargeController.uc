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

/**
 * Counter for said array
 */
var int _Pathnode;

/**
 * The current node the bot is moving to
 */
var Pathnode currentNode;

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
var Pathnode endNode;

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
var bool firstQuestComplete;

/*
 * =================================
 * Utility functions
 * =================================
 */

simulated function PostBeginPlay(){
	local Pathnode P;
	endNode = PathnodeList[PathnodeList.Length];
	super.PostBeginPlay();
	`log("POSTBEGINPLAY");
		foreach WorldInfo.AllActors(class 'Pathnode', P){
			PathnodeList.AddItem(P);
			`log("Node Added" $ P);
		}
}

/**
 * Gets the next node determined by state
 */
function Vector getNextNode(){
	local Vector nodeVect;
	if(GetStateName() == 'FirstQuestPathfinding'){
		if((PathnodeList[_Pathnode] != endNode) && (_Pathnode < PathnodeList.Length)){
			currentNode = PathnodeList[_Pathnode];
			`log("currentNode = " $ _Pathnode);
			_Pathnode++;
		}
	}
	nodeVect = NodeToVect(currentNode);
	`log("currentNode Vector = " $ nodeVect);
	return nodeVect;
}

/**
 * Converts pathnode to vector location
 */
function Vector NodeToVect(Pathnode N){
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


function bool FindNavMeshPath(){
			NavigationHandle.PathConstraintList = none;
			NavigationHandle.PathGoalList = none;
			class'NavMeshPath_Toward'.static.TowardGoal(NavigationHandle, Player);
			class'NavMeshGoal_At'.static.AtActor(NavigationHandle, Player, 25);
			return NavigationHandle.FindPath();
}

/*
 * =================================
 * States
 * =================================
 */

state Idle{

	event tick( float deltaTime ){
		super.tick( deltaTime );

		if( Player != none ){
			engagePlayer( Player );
		}
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
			GotoState('Idle');
		}
		else{
			self.Pawn.GroundSpeed = 400.0;
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

DefaultProperties
{
	decisionInterval = 0.5
	minimumDistance = 800
	bIsPlayer=true
	closeEnough = 200
	isAtLast = false
	bAdjustFromWalls=true
	_Pathnode = 0

}