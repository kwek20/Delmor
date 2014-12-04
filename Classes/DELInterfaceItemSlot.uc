class DELInterfaceItemSlot extends DELInterfaceButton;

var int displaySec;

var Texture2D default_bg;
var Color bgColor;

function draw(DELPlayerHud hud){
	drawStandardbackground(hud);

	if (texture != None){
		super.draw(hud);
		drawText(hud);
	}
}

function click(DELPlayerHud hud, bool mouseClicked, DELInterfaceButton button){

}

function hover(DELPlayerHud hud, bool enter){
	drawDescription(hud);
}

function drawStandardbackground(DELPlayerHud hud){
	hud.Canvas.SetPos(position.X, position.Y);
	drawTile(hud.Canvas, default_bg, position.Z, position.W);
}

function drawDescription(DELPlayerHud hud){
	local float Xstring, Ystring;
	local U_Items item;

	item = getItem(hud);
	if (item == none) return;
	hud.Canvas.Font = class'Engine'.static.GetMediumFont();    
	hud.Canvas.TextSize(item.getDescription() $ "", Xstring, Ystring);

	hud.Canvas.SetPos(position.X + position.Z/2 - Xstring/2, position.Y - Ystring);
	hud.Canvas.SetDrawColorStruct(bgColor);
	hud.Canvas.DrawRect(Xstring, Ystring);

	hud.Canvas.SetPos(position.X + position.Z/2 - Xstring/2, position.Y - Ystring);
	hud.Canvas.SetDrawColor(255,255,255);
	hud.Canvas.DrawText(item.getDescription());
}

function U_Items getItem(DELPlayerHud hud){
	if (hud.getPlayer().getPawn().UManager.UItems.Length < identifierKey) return none;
	return hud.getPlayer().getPawn().UManager.UItems[identifierKey-1];
}

DefaultProperties
{
	default_bg=Texture2D'DelmorHud.empty_item_bg'
	texture=Texture2D'DelmorHud.empty_item_bg'
	textOffset=(X=0.8, Y=0.8)
	color=(R=255,G=50,B=255,A=200)
	bgColor=(R=50,G=50,B=50,A=150)
	displaySec=1
}
