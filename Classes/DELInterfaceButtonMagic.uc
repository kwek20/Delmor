class DELInterfaceButtonMagic extends DELInterfaceButton;

public function draw(DELPlayerHud hud){
	super.draw(hud);
	bLastClicked = identifiedBy(DElPlayer(hud.getPlayer().getPawn()).Grimoire.getActiveNumber());
}


DefaultProperties
{
}
