/**
 * Interface for the quick action bar
 */
class DELInterfaceBar extends DELInterfaceInteractible;

/**
 * Size of a button, length between 2 buttons and the amount of buttons we want to draw
 */
var int squareSize, inbetween, amountBars, key;

/**
 * Array of textures linked to the buttons
 */
var array<Texture2D> textures;

/**
 * Array of delegate functions
 */
var array< delegate<action> > actions;

delegate action(DELPlayerHud hud);

function load(DELPlayerHud hud){
	local DELInterfaceButton button;
	local int i, length, startX, startY;

	length = 5*squareSize + 6*inbetween;
	startX = hud.sizeX/2 - length/2;
	startY = hud.sizeY - squareSize*1.5;

	for (i=1; i<=amountBars; i++){
		button = Spawn(class'DELInterfaceButton');
		button.setIdentifier(i);
		button.setPosition(startX + i*inbetween + (i-1)*squareSize, startY + inbetween, squareSize, squareSize, hud);
		button.setRun(useMagic);
		button.setTexture(textures[i-1]);
		addInteractible(button);
	}
	super.load(hud);
}


function useMagic(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject button){
	hud.getPlayer().getPawn().magicSwitch(DELInterfaceButton(button).identifierKey);
}

function draw(DELPlayerHud hud){
	local int length, startX, startY;
	local DELPawn pawn;
	
	pawn = hud.getPlayer().getPawn();
	if (pawn == None || pawn.Health <= 0)return;
	
	//Code for the box behind the buttons
	length = 5*squareSize + 6*inbetween;
	startX = hud.sizeX/2 - length/2;
	startY = hud.sizeY - squareSize*1.5;

	hud.Canvas.SetDrawColor(0, 0, 0); // black
	hud.Canvas.SetPos(startX, startY);   
	hud.Canvas.DrawRect(length, squareSize+inbetween*2); 

	super.draw(hud);
}

DefaultProperties
{
	key = 0;
	squareSize=40
	inbetween=5;
	amountBars=4;

	textures = (Texture2D'UDKHUD.cursor_png', Texture2D'UDKHUD.cursor_png', Texture2D'UDKHUD.cursor_png', Texture2D'UDKHUD.cursor_png')
}
