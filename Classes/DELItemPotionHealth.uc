class DELItemPotionHealth extends DELItemPotion placeable;

var int healingAmount;
var StaticMeshComponent healthPotion;

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
	amount=1

	Begin Object Class=StaticMeshComponent Name=healthPotion
		StaticMesh=StaticMesh'delmor_items.Meshes.sk_HealthPotion'
		HiddenGame=false
		HiddenEditor=false
		Scale=2.0
	End Object

	bCollideActors=true
	bBlockActors=false

	Mesh=healthPotion
	Components.Add(healthPotion);
	//Components.Remove(healthPotion);
}