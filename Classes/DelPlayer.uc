class DELPlayer extends DELCharacterPawn;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	`log("IK BEN GEBIN");
}

DefaultProperties
{
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
}
