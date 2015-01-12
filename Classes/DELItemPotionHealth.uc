class DELItemPotionHealth extends DELItemInteractible placeable;

var int healingAmount;
var StaticMeshComponent healthPotion;

event Destroyed (){
	//super().invAdd.AddInventory(class'DELItemOre', 1);
	`log("HealPotion BOOOOM");
	
}

function pickup()
{
	`log("Test Pickup!!!");
	    //REMOVE MESH COMMAND HERE //
	Destroy();
}

function bool canUse(DELPlayerHud hud){
	return hud.getPlayer().getPawn().health < hud.getPlayer().getPawn().healthMax;
}

function onUse(DELPlayerHud hud){
	hud.getPlayer().getPawn().heal(healingAmount);
}

DefaultProperties
{
	healingAmount=10
	itemName="Health potion"
	itemDescription="Made from beating child hearts!"
	texture=Texture2D'DelmorHud.health_potion'

	Begin Object Class=StaticMeshComponent Name=healthPotion
		StaticMesh=StaticMesh'Delmor_test.Meshes.Potion_Health'
		HiddenGame=false
		HiddenEditor=false
	End Object

	bCollideActors=true
	bBlockActors=false

	Mesh=healthPotion
	Components.Add(healthPotion);
	//Components.Remove(healthPotion);
}