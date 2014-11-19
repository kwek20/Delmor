/**
 * A class to spawn monsters at random place.
 * @autor Bram
 */
class DELMonsterSpawner extends Actor
Placeable
Config(Game);

var() class<DELCharacterPawn> mobsToSpawn;
var() bool useAll;
var() int mobsPerSpawn, spawnDelay;
var() float spawnRangeToPlayer, spawnArea;
var float distanceToSpawner;
var int mobsSpawned;
var vector selfToPlayer;
var DELPawn player;
var bool bCanSpawn;

event PostBeginPlay ()
{
    Super.PostBeginPlay();
}

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

state Spawner {

	local Controller C;
	local int i;
	function BeginState(Name PreviousStateName) {
		Super.BeginState(PreviousStateName);
		mobsSpawned = 0;
		if(bCanSpawn) {
			if(!useAll) {
				for(i = 0; i < mobsPerSpawn; i++) {
					if(checkSpawnedMobsStillAlive() <= mobsPerSpawn) {
						startSpawn();
					}
				}
			} else {
				for(i = 0; i < mobsPerSpawn; i++) {
					if(checkSpawnedMobsStillAlive() <= mobsPerSpawn) {
						startSpawnRandom();
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

function startSpawnRandom() {
	local vector SpawnLocation;
	local vector temp;
	local DELCharacterPawn mobThatSpawns;
	temp.x = rand(spawnArea*2) - spawnArea;
	temp.y = rand(spawnArea*2) - spawnArea;
	SpawnLocation = self.Location + temp;

	mobThatSpawns = Spawn(mobsToSpawn, self,,SpawnLocation, rotator(selfToPlayer));
	mobThatSpawns.SpawnDefaultController();
}


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
function startSpawn() {
	SpawnPawn();
}

function preventFromSpawningAfterSpawn() {
	bCanSpawn = false;
	SetTimer(spawnDelay, false, 'resetCooldown');
}

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

