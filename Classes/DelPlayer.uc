class DELPlayer extends DELCharacterPawn;

var array< class<Inventory> > DefaultInventory;
var Weapon sword;


simulated function bool IsFirstPerson(){
	return false;
}

function AddDefaultInventory()
{
	//sword = Spawn(Class 'DELMeleeWeapon');
	sword = Spawn(Class 'UTWeap_LinkGun');
	self.InvManager.DiscardInventory();
	self.InvManager.AddInventory(sword);
	`log("Weapon added to pawn");
}


simulated event PostBeginPlay()
{
	super.PostBeginPlay();


	`log("IK BEN GEBIN. mijn taak is het uimoorden van het menselijk ras");
}

DefaultProperties
{
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
}
