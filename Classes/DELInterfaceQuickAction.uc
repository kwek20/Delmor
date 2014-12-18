/**
 * The quick action interface.<br/>
 * Used for the health and mana potion
 */
class DELInterfaceQuickAction extends DELInterfaceHotbarButton;

/**
 * The item this interface is focussing on
 */
var class<DELItem> focusItem;

/**
 * The texture we add when this action is empty/out
 */
var Texture2D empty;

/**
 * private var to chck if we added the empty texture
 */
var private bool added;

/**
 * prevent use when were not active
 */
function use(){
	if (!isActive()) return;
	super.use();
}

function bool isActive(){
	return !added;
}

function draw(DELPlayerHud hud){
	//do we still have this item?
	if (!hud.getPlayer().getPawn().UManager.hasItem(focusItem)){
		//We dont, have we allready added the empty texture?
		if (!added){
			added = true;
			setTexture(empty);
		}
	} else if (added){
		//remove it again
		textures.Length = textures.Length-1;
		added = false;
	}
	super.draw(hud);
	//if this action is active, draw the amount we have
	if (isActive())drawNumber(hud.Canvas, position.Z, position.W, string(hud.getPlayer().getPawn().UManager.getAmount(focusItem)));
}

/**
 * Sets the item were focussing on.<br/>
 * Also adds the texture.<br/>
 * Make sure to add it in the correct order
 * @param hud
 * @param focusItem The item class we will be  focussing on
 */
function setFocus(DELPlayerHud hud, class<DELItem> focusItem){
	self.focusItem = focusItem;
	setTexture(Spawn(focusItem).texture);
}

DefaultProperties
{
	added = false
	empty=Texture2D'EditorMaterials.Cross'
}
