/**
 * An itemslot iterface. Used in DELInterfaceInventory
 */
class DELInterfaceItemSlot extends DELInterfaceButton;

/**
 * The backgorund color when you hover
 */
var Color bgColor;

function draw(DELPlayerHud hud){
	if (textures.Length > 0){
		//first draw, then add text
		super.draw(hud);
		drawText(hud.Canvas);
	}
}

/**
 * Default use check. Left pressed
 */
function bool requiresUse(DELInputMouseStats stats){
	return stats.PendingLeftReleased || stats.PendingRightReleased;
}

/**
 * Override default text draw.<br/>
 * draws the number instead<br/>
 * Does not hing when isEmpty() returns true
 */
function drawText(Canvas c){
	if (isEmpty()) return;
	drawNumber(c, position.Z * textOffset.X, position.W * textOffset.Y , getText(), 6);
}

/**
 * Checks if the button is active
 * @return true if its empty
 */
function bool isEmpty(){return text==""||text==" ";}

/**
 * onhover function. Draws the name above it
 */
function onHover(DELPlayerHud hud, bool enter){
	drawName(hud);
}

/**
 * Removes all teh textures but the first
 */
function removeTextures(){
	textures.Length = 1;
}

/**
 * onclick function. Draws item description in a subtitle
 * @param hud
 * @param stats
 * @param button
 */
function click(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject button){
	local DELItem item;
	if (isEmpty()) return;
	item = getItem(hud);
	if (item == None) return;

	if (stats.PendingLeftReleased || DELItemInteractible(item) == none){
		hud.getPlayer().showSubtitle(item.getDescription());
	} else if (stats.PendingRightReleased){
		DELItemInteractible(item).use(hud);
	}
}

/**
 * draws the name above the itemslot.
 */
function drawName(DELPlayerHud hud){
	local float Xstring, Ystring;
	local DELItem item;
	if (isEmpty()) return;
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

/**
 * Get the item this itemslot is associated with
 */
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
