class DELItemInteractible extends DELItem abstract;

function use(DELPlayerHud hud){
	setAmount(getAmount()-1);
	if (getAmount() == 0){
		hud.getPlayer().getPawn().UManager.remove(self);
	}
	onUse(hud);
}

function onUse(DELPlayerHud hud);

DefaultProperties
{
}
