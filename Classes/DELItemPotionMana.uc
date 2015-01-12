class DELItemPotionMana extends DELItemInteractible placeable;

var int manaAmount;

event Destroyed (){
	//super().invAdd.AddInventory(class'DELItemOre', 1);
	`log("manaPotion BOOOOM");
	
}

function pickup()
{
	`log("Test Pickup!!!");
	    //REMOVE MESH COMMAND HERE //
	Destroy();
}


function bool canUse(DELPlayerHud hud){
	return hud.getPlayer().getPawn().mana < hud.getPlayer().getPawn().manaMax;
}

function onUse(DELPlayerHud hud){
	local DELPawn p;
	p = hud.getPlayer().getPawn();
	p.mana += p.mana+manaAmount >= p.manaMax ? p.manaMax-p.mana : manaAmount;
}

DefaultProperties
{
	manaAmount=10
	itemName="Mana potion"
	itemDescription="Mana powers straight from a unicorn horn"
	texture=Texture2D'DelmorHud.mana_potion'

	Begin Object Class=StaticMeshComponent Name=manaPotion
		StaticMesh=StaticMesh'Delmor_test.Meshes.Potion_Mana'
		HiddenGame=false
		HiddenEditor=false
	End Object

	Mesh=manahPotion
	Components.Add(manaPotion);
}
