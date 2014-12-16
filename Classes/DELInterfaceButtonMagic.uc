class DELInterfaceButtonMagic extends DELInterfaceHotbarButton;

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
