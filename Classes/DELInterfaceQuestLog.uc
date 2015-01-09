/**
 * Quest log interface. 
 */
class DELInterfaceQuestLog extends DELInterfaceInteractible;

function load(DELPlayerHud hud){
	local DELInterfaceScrollbar text;
	local float x,y;

	//scale the image
	getScaledCoords(hud.SizeX, hud.SizeY, textures[0], x, y);
	//set the position
	setPosition(hud.CenterX-x/2, hud.CenterY-y/2, x, y, hud);

	//add the text, but its transparant
	text = Spawn(class'DELInterfaceQuestText');
	text.toggleTranparant();
	text.setLocked(self);

	addInteractible(text);
	super.load(hud);
}

function draw(DELPlayerHud hud){ 
	local Texture2D texture;

	foreach textures(texture){
		drawTileScaledOnCanvasCentered(hud, texture);
	}
	
	super.draw(hud);
}

DefaultProperties
{
	textures=(Texture2D'DelmorHud.Scroll_QuestLog')
	openSound=SoundCue'Delmor_sound.MapOpenenEtc_Open_Cue'
}
