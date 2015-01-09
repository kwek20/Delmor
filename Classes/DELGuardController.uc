/**
 * @author Jesse Linders
 * Default controller for the guard. Contains state to make them patrol between 2 or more nodes.
 * extends DELNPCController
 */

class DELGuardController extends DELNpcController;

var array <PathNode> nodeList;
var int lastNode;
var int actualNode;
var int firstNode;
var DELGuardPawn guardPawn;
var DELGuardPawn thisPawn;
var DELGuardController C;

simulated function PostBeginPlay(){
	super.PostBeginPlay();
	getPawn();
}

/**
 * Function to get the pawn corresponding with this controller
 * (made because of strange glitch because the controller didnt seem to have a pawn)
 */
function getPawn()
{
    foreach WorldInfo.AllActors (class'DELGuardPawn', thisPawn)
    {
        self.Pawn = thisPawn;
		guardPawn = thisPawn;
    }
}


simulated event Possess(Pawn inPawn, bool bVehicleTransition){
		thisPawn = DELGuardPawn(inPawn);
		C.Possess(thisPawn, false);
		super.Possess(inPawn, bVehicleTransition);
		thisPawn.SetMovementPhysics();
}

/**
 * Function to convert a pathnode location to a vector.
 * Used for pathfinding with Navmeshes.
 * Usage: NodeToVect(pathnode)
 * Returns the pathnode vector
 **/
function Vector NodeToVect(Pathnode P){
	local Vector V;
	V.X = P.Location.X;
	V.Y = P.Location.Y;
	V.Z = P.Location.Z;
	return V;
}

auto state Idle{
	local int i;

	simulated event beginState(name PreviousStateName){
			actualNode = 0;
			for(i = 0; i <= guardPawn.pathNodeList.Length; i++){
				nodeList.AddItem(guardPawn.pathNodeList[i]);
			}
			lastNode = nodeList.Length-1;


			if(guardPawn.patrollingLine){
				GotoState('PatrolLine');
			}
		}
	
}

state PatrolLine{
	local Vector tempDest;
	local PathNode tempNode;
	local bool bAtLast;

	simulated function beginState(name PreviousStateName){
		//increase guard yaw rotation speed, makes turning look more natural
		guardPawn.RotationRate.Yaw = 40000;
	}

Begin:


	if(nodeList.Length != 0){
		//If pawn is at the last node in the array, OR he's at the first node in the array and has been at the last one. 
		if(actualNode == lastNode || (actualNode == firstNode && bAtLast == true)){
			bAtLast = !bAtLast;
		}
		if(bAtLast == false){
			actualNode++;
			if(actualNode == lastNode){
				bAtLast = true;
			}
		}
		if(bAtLast == true){
			actualNode--;
		}
			tempNode = nodeList[actualNode];
			tempDest = NodeToVect(tempNode);

		if(tempNode != none){
		MoveTo(tempDest, tempNode);
		Sleep(3);
		}
	}
	Goto 'Begin';
}


DefaultProperties
{
	actualNode = 0
	firstNode = 0
	i = 0
	DefaultPawnClass=class'Delmor.DELGuardPawn'
}

DefaultProperties
{
}
