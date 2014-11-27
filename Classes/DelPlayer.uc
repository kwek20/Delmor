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
	bCanBeBaseForPawn=true
}
