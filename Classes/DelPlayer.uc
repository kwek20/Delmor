class DELPlayer extends DELPawn;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	`log("IK BEN GEBIN");
}

DefaultProperties
{
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
}
