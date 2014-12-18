class DELItemInteractible extends DELItem abstract;

var() bool restrictUse;

function bool canUse(DELPlayerHud hud);

function onUse(DELPlayerHud hud);

function use(DELPlayerHud hud){
	if (!usable(hud)) return;
	setAmount(getAmount()-1);
	if (getAmount() == 0){
		hud.getPlayer().getPawn().UManager.remove(self);
	}
	onUse(hud);
}

function bool usable(DELPlayerHud hud){
	return (!restrictUse || restrictUse && canUse(hud));
}



DefaultProperties
{
	restrictUse=true
}
