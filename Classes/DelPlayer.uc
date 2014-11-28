class DELPlayer extends DELCharacterPawn;

var array< class<Inventory> > DefaultInventory;
var Weapon sword;

simulated function bool IsFirstPerson(){
	return false;
}

function AddDefaultInventory()
{
	sword = Spawn(class'DELMeleeWeapon',,,self.Location);
	sword.GiveTo(Controller.Pawn);
	sword.bCanThrow = false; // don't allow default weapon to be thrown out
	Controller.ClientSwitchToBestWeapon();
}


simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	AddDefaultInventory();
}

DefaultProperties
{
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
<<<<<<< HEAD
	meleeArcheType = DELMeleeWeapon'Delmor_weapons.DelMeleeWeaponArcheType'
=======
>>>>>>> 2d312dca6b5fd0a47b81d23947875be86a3354fa
	bCanBeBaseForPawn=true
}
