class DELItemPotionMana extends DELItem placeable;

var int manaAmount;

function onUse(DELPlayerHud hud){
	local DELPawn p;
	p = hud.getPlayer().getPawn();
	p.mana += p.mana+manaAmount >= p.manaMax ? p.manaMax-p.mana : manaAmount;
}

DefaultProperties
{
	manaAmount=10
	itemName="Mana potion"
	itemDescription="Mana powers straight from an unicorn horn"
	texture=Texture2D'DelmorHud.mana_potion'
}
