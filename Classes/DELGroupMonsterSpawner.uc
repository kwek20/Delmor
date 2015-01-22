/**
 * A class to spawn monsters at random place.
 * @author Bram
 */
class DELGroupMonsterSpawner extends DELSpawner
Placeable
Config(Game);

var() int spawnDelay;
var() int numberOfEasyMonster;
var() int numberOfMediumMonster;
var() int numberOfHardMonster;

/**
 * This function spawns one enemy
 */
function spawnPawn(class<DELHostilePawn> mobToSpawns, vector spawnLocation)
{
	local DELHostilePawn mobThatSpawns;
	mobThatSpawns = Spawn(mobToSpawns, self,,SpawnLocation,Self.Rotation, ,true);
	mobThatSpawns.SpawnDefaultController();
	mobThatSpawns.bBlockActors = false;
}
/**
 * Function to start the spawning of mobs
 * @param random boolean that is used to determine wether spawn a random or a specific class
 */
function startSpawn() {
	local Vector newLocation;
	local int i;

	`log( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
	`log( "Spawn monsters" );

	for(i = 0; i < numberOfEasyMonster; i++) {
		if(checkMonsterToSpawn(class'DELEasyMonsterPawn', numberOfEasyMonster)) {
			newLocation = super.getRandomLocation();
			spawnPawn(class'DELEasyMonsterPawn', newLocation);
		}
	}
	for(i = 0; i < numberOfMediumMonster; i++) {
		if(checkMonsterToSpawn(class'DELMediumMonsterPawn', numberOfMediumMonster)) {
			newLocation = super.getRandomLocation();
			spawnPawn(class'DELMediumMonsterPawn', newLocation);
		}
	}
	for(i = 0; i < numberOfHardMonster; i++) {
		if(checkMonsterToSpawn(class'DELHardMonsterSmallPawn', numberOfHardMonster)) {
			newLocation = super.getRandomLocation();
			spawnPawn(class'DELHardMonsterSmallPawn', newLocation); 
		}
	}
			
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

