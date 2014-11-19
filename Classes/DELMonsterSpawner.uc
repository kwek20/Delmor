/**
 * A class to spawn monsters at random place.
 */
class DELMonsterSpawner extends Actor
Placeable
Config(Game);

var() class<DELCharacterPawn> mobsToSpawn;
var() bool useAll;
var() int mobsPerSpawn;
var() float spawnRangeToPlayer, spawnArea;
var float distanceToSpawner;
var int mobsSpawned, spawnTimeBetweenMobs;
var vector selfToPlayer;
var DELPawn player;

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
		`log("test spawner");
		mobsSpawned = 0;
		for(i = 0; i < mobsPerSpawn; i++) {
			if(checkSpawnedMobsStillAlive() <= mobsPerSpawn) {
				startSpawn();
			}
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
	mobThatSpawns = Spawn(mobsToSpawn, self,,SpawnLocation, self.Rotation);
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
	`log("test");
	SpawnPawn();
}

DefaultProperties
{
	mobsToSpawn = class'DELEasyMonsterPawn'
	spawnRangeToPlayer = 500
	spawnArea = 500
	mobsPerSpawn = 3
	spawnTimeBetweenMobs = 1;
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Pickup'
	End Object
	Components.Add(Sprite)
}

