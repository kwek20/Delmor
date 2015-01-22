class DELVillagerSpawner extends DELSpawner
Placeable
Config(Game);

var() float spawnRangeToPlayer;
var float distanceToSpawner;
var vector selfToPlayer;
var vector selfToPathnode;
var DELPawn player;
var bool bCanSpawn;


function spawnPawn(vector spawnLocation)
{
	local DELVillagerPawn mobsToSpawn;
	mobsToSpawn = Spawn(class'DELVillagerPawn', self,,SpawnLocation,Self.Rotation, ,true);
	mobsToSpawn.SpawnDefaultController();
	mobsToSpawn.bBlockActors = false;

}

function startSpawn() {
	local DELVillagerSpawnNode C;
	local Vector newLocation;
	foreach WorldInfo.AllNavigationPoints(class'DELVillagerSpawnNode', C) {
		selfToPathnode = C.Location - self.Location;
		distanceToSpawner = Abs(VSize(selfToPathnode));
		`log("Ik BEN " $ distanceToSpawner $ "verwijderd van dat ding");
		`log("Spawnarea" $ spawnarea);
		if(distanceToSpawner < spawnArea) {
			newLocation = C.Location;
			newLocation = super.getFloorLocation( newLocation );
			spawnPawn(newLocation); 
		}
	}
}

DefaultProperties
{
	spawnDelay = 120
	bCanSpawn = true
	bHidden = true
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Pickup'
	End Object
	Components.Add(Sprite)
}
