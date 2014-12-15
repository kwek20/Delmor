class DELItemPotionHealth extends DELItemInteractible placeable;

var int healingAmount;

function onUse(DELPlayerHud hud){
	hud.getPlayer().getPawn().heal(healingAmount);
}

DefaultProperties
{
	healingAmount=10
	itemName="Health potion"
	itemDescription="Made from beating child hearths!"
	texture=Texture2D'DelmorHud.health_potion'
}
