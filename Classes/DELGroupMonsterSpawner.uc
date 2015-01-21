/**
 * A class to spawn monsters at random place.
 * @author Bram
 */
class DELGroupMonsterSpawner extends Actor
Placeable
Config(Game);

var() int spawnDelay;
var() float spawnArea;
var() int numberOfEasyMonster;
var() int numberOfMediumMonster;
var() int numberOfHardMonster;
var bool bCanSpawn;

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
		if(bCanSpawn) {
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
 * This function spawns one enemy
 */
function spawnPawn(class<DELHostilePawn> mobToSpawns, vector spawnLocation)
{
	local DELHostilePawn mobThatSpawns;
	mobThatSpawns = Spawn(mobToSpawns, self,,SpawnLocation,Self.Rotation, ,true);
	mobThatSpawns.SpawnDefaultController();
}
/**
 * Function to start the spawning of mobs
 * @param random boolean that is used to determine wether spawn a random or a specific class
 */
function startSpawn() {
	local Vector newLocation;
	local int i;
	for(i = 0; i < numberOfEasyMonster; i++) {
		if(checkMonsterToSpawn(class'DELEasyMonsterPawn', numberOfEasyMonster)) {
			newLocation = getRandomLocation();
			spawnPawn(class'DELEasyMonsterPawn', newLocation);
		}
	}
	for(i = 0; i < numberOfMediumMonster; i++) {
		if(checkMonsterToSpawn(class'DELMediumMonsterPawn', numberOfMediumMonster)) {
			newLocation = getRandomLocation();
			spawnPawn(class'DELMediumMonsterPawn', newLocation);
		}
	}
	for(i = 0; i < numberOfHardMonster; i++) {
		if(checkMonsterToSpawn(class'DELHardMonsterSmallPawn', numberOfHardMonster)) {
			newLocation = getRandomLocation();
			spawnPawn(class'DELHardMonsterSmallPawn', newLocation); 
		}
	}
			
}

function Vector getRandomLocation() {
	local Vector tempLocation;
	tempLocation.X = self.Location.X  + (Rand(2 * SpawnArea) - SpawnArea);
	tempLocation.Y = self.Location.Y  + (Rand(2 * SpawnArea) - SpawnArea);
	tempLocation.Z = Location.Z;

	tempLocation = getFloorLocation( tempLocation );

	return tempLocation;
}   

/**
 * Returns the location of the ground beneath the given location.
 */
function vector getFloorLocation( vector l ){
	local vector groundLocation , hitNormal , traceStart , traceEnd;

	traceStart = l;
	traceStart.Z = l.Z + 512.0;

	traceEnd.X = location.x;
	traceEnd.Y = location.y;
	traceEnd.Z = location.z - 512.0;

	//Trace and get a ground location, that way the smoke will be placed on the ground and not the air.
	Trace( groundLocation , hitNormal , traceEnd , traceStart , false );

	return groundLocation;
}

function bool checkMonsterToSpawn(class<DELHostilePawn> monsterToCheck, int MaxNumberOfClass) {
	local Actor C;
	local int mobsFoundedInrange;
	local float distanceToSpawner;
	local vector selfToEnemy;

	foreach WorldInfo.AllActors(monsterToCheck, C) {
		selfToEnemy = C.Location - self.Location;
		distanceToSpawner = Abs(VSize(selfToEnemy));
		if(distanceToSpawner < spawnArea) {
			mobsFoundedInRange++;
		}
	}
	if(mobsFoundedInrange < MaxNumberOfCLass) {
		return true;
	} else {
		return false;
	}
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
	spawnArea = 1024
	spawnDelay = 120
	bCanSpawn = true
	bHidden = true
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Pickup'
	End Object
	Components.Add(Sprite)
}

