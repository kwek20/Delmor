/**
 * A class to spawn monsters at random place.
 */
class DELMonsterSpawner extends Actor
Placeable
Config(Game);

var() class<DELCharacterPawn> mobsToSpawn;
var() bool useAll;
var() int spawnInterval, mobsPerSpawn;
var() float spawnRangeToPlayer, spawnArea;
var float distanceToPlayer;
var vector selfToPlayer;

simulated event PostBeginPlay() {
	super.PostBeginPlay();
	GotoState('idle');
}

state idle {

	function BeginState(Name PreviousStateName) {
		Super.BeginState(PreviousStateName);
	}

	event Tick(float deltaTime)
	{
		local Controller C;
		//DELPlayerController
		foreach WorldInfo.AllControllers(class'Controller', C)
		{	
			if (C.bIsPlayer && C.IsA('PlayerController'))
			{
				selfToPlayer = C.Pawn.Location - self.Location;
				distanceToPlayer = Abs(VSize(selfToPlayer));
				`log(distanceToPlayer);
				if(distanceToPlayer < spawnRangeToPlayer) {
					GotoState('Spawner');
				}
			}
		}
	}
}

state Spawner {
	function BeginState(Name PreviousStateName) {
		Super.BeginState(PreviousStateName);
	}
	event Tick(float deltaTime) {
	}
Begin: 
		`log("Test");
}

DefaultProperties
{
	spawnRangeToPlayer = 250
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Pickup'
	   HiddenGame=True
	   AlwaysLoadOnClient=False
	   AlwaysLoadOnServer=False
	End Object
  Components.Add(Sprite)

}

