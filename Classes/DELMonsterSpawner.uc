/**
 * A class to spawn monsters at random place.
 * @autor Bram
 */
class DELMonsterSpawner extends Actor
Placeable
Config(Game);
/**
 * The class that will be spawned
 */
var() class<DELCharacterPawn> mobsToSpawn;

/**
 * a boolean that is used to set 1 class or random mobs
 */
var() bool useAll;

/**
 * the mobsPerSpawn will be used to spawn an x amount of enemies
 */
var() int mobsPerSpawn;
/**
 * SpawnDelay is used to respawn only after the amount in seconds.
 */
var() int spawnDelay;

/**
 * spawnRangeToPlayer is used to spawn only within that range.
 */
var() float spawnRangeToPlayer;
/**
 * SpawnArea is used to spawn an enemy within this area.
 */
var() float spawnArea;
/**
 * temp value that is used to calculate the distance between the spawner and the player
 */
var float distanceToSpawner;
/**
 * a Vector where the distance is calculated between the player and spawner in vector
 */
var vector selfToPlayer;
/**
 *  the player
 */
var DELPawn player;
/**
 * a bool to check weither the mobs can be spawned (cooldown)
 */
var bool bCanSpawn;


/**
 * standard event that is called when the game is started
 */
event PostBeginPlay ()
{
    Super.PostBeginPlay();
}

/**
 * This is the auto state of the spawner. It checks every tick for the player is in range or not
 */
auto state Idle {

	function BeginState(Name PreviousStateName) {
		Super.BeginState(PreviousStateName);
	}

	event Tick(float deltaTime)
	{
		local Controller C;
		//DELPlayerController
		foreach WorldInfo.AllControllers(class'Controller', C)
		{	
			if (C.IsA('DELPlayerController'))
			{
				selfToPlayer = C.Pawn.Location - self.Location;
				distanceToSpawner = Abs(VSize(selfToPlayer));
				if(distanceToSpawner < spawnRangeToPlayer) {
					GotoState('Spawner');
				}
			}
		}
	}
	
	Begin:
}

/**
* This state is used when the player is in range and will spawn enemies (till the max amount of enemies is reached)
*/
state Spawner {

	local Controller C;
	local int i;
	function BeginState(Name PreviousStateName) {
		Super.BeginState(PreviousStateName);
		if(bCanSpawn) {
			if(!useAll) {
				for(i = 0; i < mobsPerSpawn; i++) {
					if(checkSpawnedMobsStillAlive() <= mobsPerSpawn) {
						SpawnPawn();
					}
				}
			} else {
				for(i = 0; i < mobsPerSpawn; i++) {
					if(checkSpawnedMobsStillAlive() <= mobsPerSpawn) {
						SpawnPawn();
					}
				}
			}
			preventFromSpawningAfterSpawn();
		}
	}



	event Tick(float deltaTime) {
		foreach WorldInfo.AllControllers(class'Controller', C)
		{	
			if (C.IsA('DELPlayerController'))
			{
				selfToPlayer = C.Pawn.Location - self.Location;
				distanceToSpawner = Abs(VSize(selfToPlayer));
				if(distanceToSpawner > spawnRangeToPlayer) {
					GotoState('Idle');
				}
			}
		}
	}
}
/**
 * This function spawns one enemy
 */
function SpawnPawn()
{
	local vector SpawnLocation;
	local vector temp;
	local DELCharacterPawn mobThatSpawns;
	temp.x = rand(spawnArea*2) - spawnArea;
	temp.y = rand(spawnArea*2) - spawnArea;
	SpawnLocation = self.Location + temp;

	mobThatSpawns = Spawn(mobsToSpawn, self,,SpawnLocation, rotator(selfToPlayer));
	mobThatSpawns.SpawnDefaultController();
}
/**
 * this function calculates the amount of enemies that are alive.
 * @return the amount of living enemies
 */
function int checkSpawnedMobsStillAlive() {
	local int tempMobsSpawned;
	local Controller C;
	foreach WorldInfo.AllControllers(class'Controller', C) {
		selfToPlayer = C.Pawn.Location - self.Location;
		distanceToSpawner = Abs(VSize(selfToPlayer));
		if(distanceToSpawner < spawnArea) {
			tempMobsSpawned++;
		}
	}
	return tempMobsSpawned;
}


/*function startSpawn() {
	SpawnPawn();
}*/
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
	mobsToSpawn = class'DELEasyMonsterPawn'
	spawnRangeToPlayer = 500
	spawnArea = 500
	mobsPerSpawn = 3
	spawnDelay = 120
	bCanSpawn = true
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Pickup'
	End Object
	Components.Add(Sprite)
}

