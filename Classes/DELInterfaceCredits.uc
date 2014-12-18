/**
 * The credits screen
 */
class DELInterfaceCredits extends DELInterfaceInteractible;

function load(DELPlayerHud hud){
	local DELInterfaceScrollbar text;

	//take the entire screen ;)
	setPosition(0, 0, hud.SizeX, hud.SizeY, hud);
	text = Spawn(class'DELInterfaceCreditsText');

	//set scroll lock to the entire screen
	text.setLocked(self);

	addInteractible(text);
	super.load(hud);
}

function draw(DELPlayerHud hud){
	//black background
	hud.Canvas.setDrawColor(0,0,0);
	hud.Canvas.setPos(0,0);
	hud.Canvas.drawRect(hud.SizeX, hud.SizeY);
	super.draw(hud);
}

DefaultProperties
{
}
