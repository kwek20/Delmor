class DELHostilePawn extends DELNPCPawn abstract;

var DELWeapon sword;

simulated event PostBeginPlay(){
	super.PostBeginPlay();
	AddDefaultInventory();
}

function AddDefaultInventory()
{
	sword = Spawn(class'DELMeleeWeapon',,,self.Location);
	sword.GiveTo(Controller.Pawn);
	sword.bCanThrow = false; // don't allow default weapon to be thrown out
	Controller.ClientSwitchToBestWeapon();
}

DefaultProperties
{
}
