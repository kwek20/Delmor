class DELInterfaceButtonMain extends DELInterfaceButton;

function load(DELPlayerHud hud){
	position.Z = hoverTextures[0].SizeX;
	position.W = hoverTextures[0].SizeY/2;
}

function draw(DELPlayerHud hud){
	super.draw(hud);
}

DefaultProperties
{
	hoverTextures=(Texture2D'DelmorHud.Balk_menu')
}
