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
	if (DElPlayer(hud.getPlayer().getPawn()).Grimoire == none) return;
	bLastClicked = identifiedBy(DElPlayer(hud.getPlayer().getPawn()).Grimoire.getActiveNumber());
	if(bLastClicked) drawGoldenEdge(hud.Canvas);

}

public function drawGoldenEdge(Canvas c){
		c.SetDrawColor(clickedColor.R,clickedColor.G,clickedColor.B,clickedColor.A);
		c.SetPos(position.X-5,position.Y-5,position.Z);
		c.DrawBox(position.W + 2*5 , position.Z + 2*5); 
}


DefaultProperties
{
}
