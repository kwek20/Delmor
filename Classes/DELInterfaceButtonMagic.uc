/**
 * A magic button for the hotbar interface
 */
class DELInterfaceButtonMagic extends DELInterfaceHotbarButton;

/**
 * Can only be used if its not used previous
 */
function use(){
	if (bLastClicked) return;
	super.use();
}

public function draw(DELPlayerHud hud){
	super.draw(hud);
	bLastClicked = identifiedBy(DElPlayer(hud.getPlayer().getPawn()).Grimoire.getActiveNumber());
}


DefaultProperties
{
}
