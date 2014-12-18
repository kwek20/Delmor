class DELItemPotionHealth extends DELItemInteractible placeable;

var int healingAmount;

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
}