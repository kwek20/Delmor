class DELItemPotionMana extends DELItemInteractible placeable;

var int manaAmount;

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
		StaticMesh=StaticMesh'delmor_items.Meshes.sk_ManaPotion'
		HiddenGame=false
		HiddenEditor=false
	End Object

	Mesh=manahPotion
	Components.Add(manaPotion);
}
