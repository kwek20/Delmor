class DELItemInteractible extends DELItem abstract;

var() bool restrictUse;

function bool canUse(DELPlayerHud hud);

function onUse(DELPlayerHud hud);

function use(DELPlayerHud hud){
	if (restrictUse && !canUse(hud)) return;
	setAmount(getAmount()-1);
	if (getAmount() == 0){
		hud.getPlayer().getPawn().UManager.remove(self);
	}
	onUse(hud);
}



DefaultProperties
{
	restrictUse=true
}
