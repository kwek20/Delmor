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
var DelPlayer Player;
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


/*
 * =================================
 * States
 * =================================
 */

state Idle{

	event tick( float deltaTime ){
		super.tick( deltaTime );
	

		if( player != none ){
			engagePlayer( player );
		}
	}
}

auto state RegularPathfinding{
	local int minimumDistance;
	local Vector tempDest;
	local float selfToPlayer;

	function beginState( name previousStateName ){
	selfToPlayer = Abs(VSize(self.Pawn.Location - Player.Location));
	`log( "Finding  path" );
	}

Begin:

		if(selfToPlayer <= minimumDistance){
			engagePlayer(Player);
		}
			else if(FindNavMeshPath(tempDest)){
				tempDest = getNextNode();
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



state FirstQuestPathfinding{
	local Vector tempDest;
	local float selfToPlayer;

	function beginState( name previousStateName ){
	`log( "Finding  path" );
	_Pathnode = 0;
	endNode = PathnodeList[PathnodeList.Length];
	}

	event Tick(float deltaTime){
		selfToPlayer = Abs(VSize(self.Pawn.Location - Player.Location));
	}


Begin:
	
	if(FindNavMeshPath(tempDest)){
		if((selfToPlayer <= minimumDistance) && (PathnodeList[_Pathnode] == endNode)){
			engagePlayer( player );
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
	//	Player = Player.Pawn;
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
			currentNode = PathnodeList[Rand(PathnodeList.Length)];
			_Pathnode++;
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