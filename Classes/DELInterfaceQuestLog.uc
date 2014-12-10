class DELInterfaceQuestLog extends DELInterfaceInteractible;

function load(DELPlayerHud hud){
	local DELInterfaceScrollbar text;
	local float x,y;

	getScaledCoords(hud.SizeX, hud.SizeY, texture, x, y);
	setPosition(hud.CenterX-x/2, hud.CenterY-y/2, x, y, hud);

	text = Spawn(class'DELInterfaceQuestText');
	text.toggleTranparant();
	text.setLocked(self);

	addInteractible(text);
	super.load(hud);
}

function draw(DELPlayerHud hud){ 
	drawTileScaledOnCanvasCentered(hud, texture);
	//(hud.Canvas, texture, hud.Canvas.SizeX, hud.Canvas.SizeY);
	super.draw(hud);
}

DefaultProperties
{
	texture=Texture2D'DelmorHud.questlog'
}
