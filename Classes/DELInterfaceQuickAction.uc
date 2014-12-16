class DELInterfaceQuickAction extends DELInterfaceHotbarButton;

var class<DELItem> focusItem;

var Texture2D empty;
var private bool added;

function use(){
	if (!isActive()) return;
	super.use();
}

function load(DELPlayerHud hud){
	super.load(hud);
}

function bool isActive(){
	return !added;
}

function draw(DELPlayerHud hud){
	if (!hud.getPlayer().getPawn().UManager.hasItem(focusItem)){
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
	if (isActive())drawNumber(hud.Canvas, position.Z, position.W, string(hud.getPlayer().getPawn().UManager.getAmount(focusItem)));
}

function setFocus(DELPlayerHud hud, class<DELItem> focusItem){
	self.focusItem = focusItem;
	setTexture(Spawn(focusItem).texture);
}

DefaultProperties
{
	added = false
	empty=Texture2D'EditorMaterials.Cross'
}
