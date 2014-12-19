class DELInterfaceMap extends DELInterfaceTexture;

function load(DELPlayerHud hud){setCenter(hud);}

function draw(DELPlayerHud hud){
	local texture2d tex;
	foreach textures(tex){
		drawTileScaledOnCanvasCentered(hud, tex);
	}
}

DefaultProperties
{
	textures=(Texture2D'DelmorHud.Map')
}
