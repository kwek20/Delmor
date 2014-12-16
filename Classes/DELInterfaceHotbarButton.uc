class DELInterfaceHotbarButton extends DELInterfaceButton;

function draw(DELPlayerHud hud){
	super.draw(hud);
	drawIdentifier(hud.Canvas);
}

function use(){
	super.use();
	hover();
}

DefaultProperties
{
}
