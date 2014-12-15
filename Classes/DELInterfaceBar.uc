/**
 * Interface for the quick action bar
 */
class DELInterfaceBar extends DELInterfaceInteractible;

/**
 * Size of a button, length between 2 buttons and the amount of buttons we want to draw
 */
var int squareSize, inbetween, amountBars, key;

var Texture2D glass, shadow;

function load(DELPlayerHud hud){
	local DELInterfaceButton button;
	local int i, length, startX, startY;
	local array<Texture2D> images;

	length = 5*squareSize + 6*inbetween;
	startX = hud.sizeX/2 - length/2;
	startY = hud.sizeY - squareSize*1.5;

	setPos(startX, startY, length, squareSize+2*inbetween, hud);
	images = getIcons(hud);
	for (i=1; i<=amountBars; i++){
		if(i < 4){button = Spawn(class'DELInterfaceButtonMagic');}
		else{button = Spawn(class'DELInterfaceButton');}
		button.setIdentifier(i);
		button.setPosition(startX + i*inbetween + (i-1)*squareSize, startY + inbetween, squareSize, squareSize, hud);
		button.setRun(useMagic);

		button.setTexture(glass);
		button.setTexture(images[i-1]);
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
	textures = DELPlayer(hud.getPlayer().getPawn()).grimoire.getIcons();
	textures.AddItem(Texture2D'UDKHUD.cursor_png');
	textures.AddItem(Texture2D'UDKHUD.cursor_png');
	return textures;
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

DefaultProperties
{
	key = 0;
	squareSize=40
	inbetween=10;
	amountBars=5;
	textures=(Texture2D'DelmorHud.balk_inventory')
	glass=Texture2D'DelmorHud.Glass'
	shadow=Texture2D'DelmorHud.Shadow_belowglass'
}
