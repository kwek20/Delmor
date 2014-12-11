class DELInterfaceCredits extends DELInterfaceInteractible;

function load(DELPlayerHud hud){
	local DELInterfaceScrollbar text;

	setPosition(0, 0, hud.SizeX, hud.SizeY, hud);
	text = Spawn(class'DELInterfaceCreditsText');
	text.setLocked(self);

	addInteractible(text);
	super.load(hud);
}

function draw(DELPlayerHud hud){
	hud.Canvas.setDrawColor(0,0,0);
	hud.Canvas.setPos(0,0);
	hud.Canvas.drawRect(hud.SizeX, hud.SizeY);
	super.draw(hud);
}

DefaultProperties
{
}
