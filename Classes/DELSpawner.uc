class DELSpawner extends Actor
	abstract;

var() int spawnDelay;
var() float spawnArea;
var bool bCanSpawn;
/**
 * Spawn only when the player is this close to the spawner.
 */
var() int spawnDistance;

/**
 * standard event that is called when the game is started
 */
event PostBeginPlay ()
{
    Super.PostBeginPlay();
	GotoState('Spawner');
}

state Idle {
	function BeginState(Name PreviousStateName) {
		Super.BeginState(PreviousStateName);
	}

	event Tick(float DeltaTime) {
		if( bCanSpawn /*&& Abs( VSize( GetALocalPlayerController().Pawn.Location - location ) ) < Abs( spawnDistance + spawnArea ) */) {
			GotoState('Spawner');
		}
	}
}

/**
* This state is used to spawn enemies
*/
state Spawner {
	function BeginState(Name PreviousStateName) {
		Super.BeginState(PreviousStateName);
			startSpawn();
			preventFromSpawningAfterSpawn();
			GotoState('Idle');
	}
}

/**
 * Fill this up in a sub-class to add business logic.
 */
function startSpawn(){
}

function Vector getRandomLocation() {
	local Vector tempLocation;
	tempLocation.X = self.Location.X  + (Rand(2 * SpawnArea) - SpawnArea);
	tempLocation.Y = self.Location.Y  + (Rand(2 * SpawnArea) - SpawnArea);
	tempLocation.Z = location.Z;

	tempLocation = getFloorLocation( tempLocation );

	return tempLocation;
}

/**
 * Returns the location of the ground beneath the given location.
 */
function vector getFloorLocation( vector l ){
	local vector groundLocation , hitNormal , traceStart , traceEnd;

	traceStart = l;
	traceStart.Z = l.Z + 256.0;

	traceEnd.X = location.x;
	traceEnd.Y = location.y;
	traceEnd.Z = location.z - 512.0;

	//Trace and get a ground location, that way the smoke will be placed on the ground and not the air.
	Trace( groundLocation , hitNormal , traceEnd , traceStart , false );

	return groundLocation;
}

/**
 * this function will prevent the spawner to spawn till the cooldown has been reached.
 */
function preventFromSpawningAfterSpawn() {
	bCanSpawn = false;
	SetTimer(spawnDelay, false, 'resetCooldown');
}

/**
 * this function resets the cooldown.
 */
function resetCooldown() {
	bCanSpawn = true;
}

DefaultProperties
{
	spawnDistance = 5120.0
}
