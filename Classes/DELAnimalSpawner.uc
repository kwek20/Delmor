/**
 * A class to spawn monsters at random place.
 * @author Bram
 */
class DELAnimalSpawner extends Actor
Placeable
Config(Game);

var() int spawnDelay;
var() float spawnArea;
var() int numberOfChickens;
var() int numberOfCows;
var() int numberOfGoats;
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
function spawnPawn(class<DELAnimalPawn> mobToSpawns, vector spawnLocation)
{
	local DELAnimalPawn mobThatSpawns;
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
	for(i = 0; i < numberOfChickens; i++) {
		if(checkAnimalsToSpawn(class'DELChickenPawn', numberOfChickens)) {
			newLocation = getRandomLocation();
			spawnPawn(class'DELChickenPawn', newLocation);
		}
	}
	for(i = 0; i < numberOfCows; i++) {
		if(checkAnimalsToSpawn(class'DELCowPawn', numberOfCows)) {
			newLocation = getRandomLocation();
			spawnPawn(class'DELCowPawn', newLocation);
		}
	}
	for(i = 0; i < numberOfCows; i++) {
		if(checkAnimalsToSpawn(class'DELGoatPawn', numberOfGoats)) {
			newLocation = getRandomLocation();
			spawnPawn(class'DELGoatPawn', newLocation);
		}
	}
			
}

function Vector getRandomLocation() {
	local Vector tempLocation;
	tempLocation.X = self.Location.X  + (Rand(2 * SpawnArea) - SpawnArea);
	tempLocation.Y = self.Location.Y  + (Rand(2 * SpawnArea) - SpawnArea);
	tempLocation.Z = 10;
	return tempLocation;
}   

function bool checkAnimalsToSpawn(class<DELAnimalPawn> monsterToCheck, int MaxNumberOfClass) {
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

