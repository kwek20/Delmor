/**
 * Abstract class meant for use in the hotbar<br/>
 * Adds a default identifier draw and a hover flash when you use it
 */
class DELInterfaceHotbarButton extends DELInterfaceButton abstract;

function draw(DELPlayerHud hud){
	super.draw(hud);
	drawIdentifier(hud.Canvas);
}

/**
 * Show feedback when you use it
 */
function use(){
	super.use();
	hover();
}

DefaultProperties
{
}
