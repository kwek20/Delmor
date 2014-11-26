class DELPlayer extends DELCharacterPawn;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	//self.InvManager.DiscardInventory();         Zou de boel moeten removen.
	`log("IK BEN GEBIN");
}

DefaultProperties
{
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
	
}
