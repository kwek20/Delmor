class DELInterfaceItemSlot extends DELInterfaceButton;

var Texture2D default_bg;
var Color bgColor;

function draw(DELPlayerHud hud){
	drawStandardbackground(hud.Canvas);

	if (textures.Length > 0){
		super.draw(hud);
		drawText(hud.Canvas);
	}
}

function onHover(DELPlayerHud hud, bool enter){
	drawName(hud);
}

function click(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject button){
	local DELItem item;
	item = getItem(hud);
	hud.getPlayer().showSubtitle(item.getDescription());
}

function drawStandardbackground(Canvas c){
	local int col;
	col =  isHover ? 255 : 0;
	c.SetPos(position.X, position.Y);
	drawCTile(c, default_bg, position.Z, position.W, 0, col, 0, 255);
}

function drawName(DELPlayerHud hud){
	local float Xstring, Ystring;
	local DELItem item;

	item = getItem(hud);
	if (item == none) return;
	hud.Canvas.Font = class'Engine'.static.GetMediumFont();    
	hud.Canvas.TextSize(item.getName() $ "", Xstring, Ystring);

	hud.Canvas.SetPos(position.X + position.Z/2 - Xstring/2, position.Y - Ystring);
	hud.Canvas.SetDrawColorStruct(bgColor);
	hud.Canvas.DrawRect(Xstring, Ystring);

	hud.Canvas.SetPos(position.X + position.Z/2 - Xstring/2, position.Y - Ystring);
	hud.Canvas.SetDrawColor(255,255,255);
	hud.Canvas.DrawText(item.getName());
}

function DELItem getItem(DELPlayerHud hud){
	if (hud.getPlayer().getPawn().UManager.UItems.Length < identifierKey) return none;
	return hud.getPlayer().getPawn().UManager.UItems[identifierKey-1];
}

DefaultProperties
{
	default_bg=Texture2D'DelmorHud.Glass'
	textures=(Texture2D'DelmorHud.Glass')
	textOffset=(X=0.8, Y=0.8)
	color=(R=255,G=50,B=255,A=200)
	bgColor=(R=50,G=50,B=50,A=150)
	displaySec=1
}
