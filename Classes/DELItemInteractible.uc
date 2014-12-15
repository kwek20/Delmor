class DELItemInteractible extends DELItem abstract;

function use(DELPlayerHud hud){
	if (getAmount() > 1){
		setAmount(getAmount()-1);
	} else {
		//remove
		`log("We should remove " @ self);
		hud.getPlayer().getPawn().UManager.remove(self);
	}
	onUse(hud);
}

function onUse(DELPlayerHud hud);

DefaultProperties
{
}
