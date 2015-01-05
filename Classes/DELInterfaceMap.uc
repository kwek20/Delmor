class DELInterfaceMap extends DELInterfaceTexture;

function load(DELPlayerHud hud){setCenter(hud);}

function draw(DELPlayerHud hud){
	local texture2d tex;
	foreach textures(tex){
		drawTileScaledOnCanvasCentered(hud, tex);
	}

	//hud.Canvas.setPos(0,0);
	//hud.Canvas.DrawMaterialTile(hud.RenderTexture, hud.RenderTexture.GetSurfaceWidth(), hud.RenderTexture.GetSurfaceHeight());
}

DefaultProperties
{
	textures=(Texture2D'DelmorHud.Map')
}
