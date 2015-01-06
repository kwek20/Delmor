/**
 * This controller controls the boss during the first quest
 * 
 * @author Jesse Linders
 */
class DELFirstQuestHardMonsterController extends DELHostileController;

 
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
 * Vector of the last pathnode
 **/
var Vector endVect;

/**
 * Boss' speed
 **/
var() float botSpeed;

/*
 * ===============================================
 * Utility functions
 * ===============================================
 */

simulated function PostBeginPlay(){
	local DELFirstQuestPathnodes P;
	super.PostBeginPlay();
		foreach WorldInfo.AllActors(class 'DELFirstQuestPathnodes', P){
			PathnodeList.AddItem(P);
			}
		endNode = PathnodeList[PathnodeList.Length];
		endVect = NodeToVect(endNode);
}

/**
 * Gets the next node determined by state
 */
function Vector getNextNode(){
	local Vector nodeVect;
	local Pawn Player;
	Player = GetALocalPlayerController().Pawn;
		if(_Pathnode != PathnodeList.Length){
			currentNode = PathnodeList[_Pathnode];
			_Pathnode++;
			nodeVect = NodeToVect(currentNode);
		}
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
 * @param vector tempDest The temporary destination
 */
function bool FindNavMeshPathVect(Vector tempDest){
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;
    class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle,tempDest);
    class'NavMeshGoal_At'.static.AtLocation(NavigationHandle, tempDest,32 );
    return NavigationHandle.FindPath();
}

/**
 * Checks the minimum distance between the player and pawn
 * @param int minDist The minimal distance 
 **/
function bool withinMinDist(int minDist){
	local float selfToPlayer;
	local Pawn BotPawn;
	local Pawn Player;
	Player = GetALocalPlayerController().Pawn;
	BotPawn = self.Pawn;
	selfToPlayer = Abs(VSize(BotPawn.Location - Player.Location));
	if(selfToPlayer <= minDist){
		return true;
	} else {
		return false;
	}
}


/**
 * Standardized function to check if there is a path to the goal
 **/
function bool findNavMeshPath(){
	//Clear cache and constraints
	NavigationHandle.PathConstraintList = none;
	NavigationHandle.PathGoalList = none;

	//Create constraints (a.k.a. set player as goal)
	class'NavMeshPath_Toward'.static.TowardGoal(NavigationHandle, Player);
	class'NavMeshGoal_At'.static.AtActor(NavigationHandle, Player, 25);

	//Find path
	return NavigationHandle.FindPath();
}


auto state Idle{
		local Pawn Player;
	simulated event beginstate(name previousStateName){
		Player = GetALocalPlayerController().Pawn;
	}


	event tick( float deltaTime ){
		super.tick( deltaTime );
	}

	simulated event SeePlayer (Pawn Seen){
						Player = Seen;
			if(withinMinDist(minimumDistance)){
				super.SeePlayer(Seen);

			GotoState('FirstQuestPathfinding');
			}
	}
}


state FirstQuestPathfinding{
	local Pawn Player;
	local Vector tempDest;
	
	function beginState( name previousStateName ){
	Player = GetALocalPlayerController().Pawn;
	}

	event Tick (float deltaTime){
		super.Tick(deltaTime);
		if(self.Pawn.Location == endVect || _Pathnode == PathnodeList.Length){
			self.Pawn.GroundSpeed = 0.0;
			engagePlayer(Player);
			stopPawn();
		}
	}


Begin:
	
		if(findNavMeshPathVect(tempDest)){
		self.Pawn.GroundSpeed = 500.0;
		tempDest = getNextNode();
		NavigationHandle.SetFinalDestination(tempDest);
		FlushPersistentDebugLines();
			if(NavigationHandle.GetNextMoveLocation(tempDest, Pawn.GetCollisionRadius())){
				MoveTo(tempDest);
			}
		}
		Goto 'Begin';
}


DefaultProperties
{
	minimumDistance = 800
	bIsPlayer=true
	bAdjustFromWalls=true
	_Pathnode = 0
	atEnd = false
}
