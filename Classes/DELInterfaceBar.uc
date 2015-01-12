/**
 * Interface for the quick action bar
 */
class DELInterfaceBar extends DELInterfaceInteractible;

/**
 * Size of a button, length between 2 buttons and the amount of buttons we want to draw
 */
var int squareSize, inbetween, amountBars, key;

/**
 * The texture of a display character on a action spot, with its shadow and a dirt speck
 */
var Texture2D glass, shadow, vlekje;

/**
 * The possible hotbar items
 */
var array< class<DELItem> > hotbarItems;

function load(DELPlayerHud hud){
	local DELInterfaceButton button;
	local int i, length, startX, startY;
	local array<Texture2D> images;

	length = 5*squareSize + 6*inbetween;
	startX = hud.sizeX/2 - length/2;
	startY = hud.sizeY - (squareSize+2*inbetween) - inbetween/2;

	setPos(startX, startY, length, squareSize+2*inbetween, hud);
	images = getIcons(hud);

	for (i=1; i<=amountBars; i++){
		//load magic spells, then quick action items
		if(i <= images.Length){button = Spawn(class'DELInterfaceButtonMagic');}
		else{button = Spawn(class'DELInterfaceQuickAction');}

		//set key and poistion
		button.setIdentifier(i);
		button.setPosition(startX + i*inbetween + (i-1)*squareSize, startY + inbetween, squareSize, squareSize, hud);

		//set glass texture
		button.setTexture(glass);

		//set textures and run functions
		if (images.Length>=i){
			button.setTexture(images[i-1]);
			button.setRun(useMagic);
		} else if (hotbarItems.Length >=i-images.Length){
			DELInterfaceQuickAction(button).setFocus(hud, hotbarItems[i-images.Length-1]);
			button.setRun(usePotion);
		}

		//add a speck to the first button
		if (i==0)button.setTexture(vlekje);

		//add shadow texture as last, then add it
		button.setTexture(shadow);
		addInteractible(button);
	}
	super.load(hud);
}

/**
 * gets the icons from the items themselves
 * !has magic number in the place for potions
 * @param hud the hud where the interface belongs to
 * @author harmen wiersma
 */
function array<Texture2D> getIcons(DELPlayerHud hud){
	local array<Texture2D> textures;
	return DELPlayer(hud.getPlayer().getPawn()).grimoire != none ? DELPlayer(hud.getPlayer().getPawn()).grimoire.getIcons() : textures;
}

/**
 * lets the magical items be actually used
 * @author harmen wiersma, brood van wierst
 * @param hud the hud this thing belongs to
 * @param stats stats of the mouse that activated the use of this function
 * @param button button the mouse clicked
 */
function useMagic(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject button){
	hud.getPlayer().getPawn().magicSwitch(DELInterfaceButton(button).identifierKey);
}

/**
 * Use a potion
 * @param hud the hud this thing belongs to
 * @param stats stats of the mouse that activated the use of this function
 * @param button button the mouse clicked
 */
function usePotion(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject button){
	local DELItem item;
	if (!button.isA('DELInterfaceQuickAction') || !DELInterfaceQuickAction(button).isActive()) return;
	item = hud.getPlayer().getPawn().UManager.getFirst(DELInterfaceQuickAction(button).focusItem);
	if (!item.isA('DELItemInteractible')) return;
	DELItemInteractible(item).use(hud);
}

DefaultProperties
{
	key = 0;
	squareSize=40
	inbetween=15;
	amountBars=5;
	textures=(Texture2D'DelmorHud.balk_inventory')
	glass=Texture2D'DelmorHud.Glass'
	shadow=Texture2D'DelmorHud.Shadow_belowglass'
	vlek=Texture2D'DelmorHud.vlekje2'

	hotbarItems=(class'DELItemPotionHealth', class'DELItemPotionMana')
}
