/**
 * Inventory interface. <br/>
 * Manages items, size and backgorund
 */
class DELInterfaceInventory extends DELInterfaceInteractible;

/**
 * Itemslot values. <br/>
 * inbetween is the spacing between 2 slots
 * length is x and y
 * amountX and amountY are the amount of squares in each direction
 */
var() int inbetween, length, amountX, amountY;

function draw(DELPlayerHud hud){
	local DELInterfaceObject obj;
	local DELItem item;

	foreach objects(obj){
		//no itemslot? do default
		if (!obj.isA('DELInterfaceItemSlot')) continue;
		item = DELInterfaceItemSlot(obj).getItem(hud);

		//item is none?
		if (item == None) {
			//clear it when its empty
			if (DELInterfaceItemSlot(obj).isEmpty()){
				//remove it
				removeActiveItem(DELInterfaceItemSlot(obj));
			}
			continue;
		}
		//update item amount
		DELInterfaceItemSlot(obj).setText(string(item.getAmount()));
	}
	super.draw(hud);
}

/**
 * Remvoe an object.<br/>
 * This menas clear all textures, set text to empty and remove the run function
 * @param item the item to remove
 */
function removeActiveItem(DELInterfaceItemSlot item){
	item.removeTextures();
	item.setText(" ");
	item.setRun(None);
}

function load(DELPlayerHud hud){
	local DELInterfaceItemSlot button;
	local array<DELItem> items;
	local DELItem item;
	local int startX, startY, i;
	local int w, h;

	//background position, 1.5x the total itemslot size
	w = (amountX*length + amountX+2*inbetween) * 1.5;
	h = (amountY*length + amountY+2*inbetween) * 1.5;
	setPos(hud.sizeX/2 - w/2, hud.sizeY/2 - h/2, w, h, hud);

	//start positions for the left top item
	startX = hud.sizeX/2 - ((AmountX*length)+((AmountX + 1)*inbetween))/2;
	startY = hud.sizeY/2 - ((AmountY*length)+((AmountY + 1)*inbetween))/2;

	//snag all items
	items = hud.getPlayer().getPawn().UManager.UItems;

	//for every itemslot we can have
	for(i = 0; i < (amountX*amountY); i++){
		//spawn an itemslot interface, and set its location
		button = Spawn(class'DELInterfaceItemSlot');
		button.setPosition( startX + ((i % amountX + 1)*inbetween) + ((i % amountX)*length), 
							startY  + ((class'DELMath'.static.floor(i / amountX) + 1)*inbetween) 
									+ ((class'DELMath'.static.floor(i / amountX))*length),
							length, length, hud);

		//check if we have an item to fill it with
		if (items.Length > i && items[i] != None){
			//get the current item
			item = items[i];
			//add a click function
			button.setRun(button.click);
			//set the amount
			button.setText(item.getAmount()$"");
			//add the texture, and add a hovertexture if it has one
			button.setTexture(item.texture);
			if (item.hoverTexture != None)button.setHoverTexture(item.hoverTexture);
		} else {
			button.setText("");
		}

		//set hover method, identifier and add it to the list
		button.setHover(button.onHover);
		button.setIdentifier(i+1);
		addInteractible(button);
	}
	super.load(hud);
}

DefaultProperties
{
	inbetween=10
	length=100
	amountX=4
	amountY=4
	textures=(Texture2D'DelmorHud.backpack')
	openSound=SoundCue'a_interface.menu.UT3MenuScreenSpinCue'
}
