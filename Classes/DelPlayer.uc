class DELPlayer extends DELCharacterPawn;


simulated function bool IsFirstPerson(){
	return false;
}
function AddDefaultInventory()
{
    //InvManager.CreateInventory(class'Delmor.DELMeleeWeapon');
	InvManager.CreateInventory(class'UTGame.UTWeap_LinkGun');
	`log("Weapon added to pawn");
}


simulated event PostBeginPlay()
{
	local Weapon NewWeapon;
	super.PostBeginPlay();

	//NewWeapon = Spawn(Class 'DELMeleeWeapon');
	//NewWeapon.GiveTo(Self);

	`log("IK BEN GEBIN. mijn taak is het uimoorden van het menselijk ras");
}

DefaultProperties
{
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
}
