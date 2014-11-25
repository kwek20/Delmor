class DELPlayer extends DELCharacterPawn;

simulated event PostBeginPlay()
{
	local Weapon NewWeapon;
	super.PostBeginPlay();

	NewWeapon = Spawn(Class 'DELMeleeWeapon');
	NewWeapon.GiveTo(Self);

	`log("IK BEN GEBIN. mijn taak is het uimoorden van het menselijk ras");
}

DefaultProperties
{
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
}
