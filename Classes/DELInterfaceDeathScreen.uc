class DELInterfaceDeathScreen extends DELInterfaceInteractible;

var Color bgColor, textColor;
var Texture2D deathImage;

var array<Texture2D> buttonTextures;

var float backgroundDimensionWidth, inbetween;

var int buttonAmount;

function load(DELPlayerHud hud){
	local DELInterfaceButtonMain button;
	local DELInterfaceTexture interface;
	local int length, startX, startY;
	local float buttonHeight;

	setPos(0,0,hud.SizeX,hud.SizeY,hud);

	interface = Spawn(class'DELInterfaceTexture');
	interface.setTexture(deathImage);
	interface.setPos(hud.CenterX-deathImage.SizeX/2, hud.CenterY-deathImage.SizeY/2, deathImage.SizeX, deathImage.SizeY, hud);
	addInteractible(interface);

	button = Spawn(class'DELInterfaceButtonMain');
	buttonHeight = button.hoverTextures[0].SizeY/2;

	length = hud.sizeX*backgroundDimensionWidth - 2*inbetween;
	startX = hud.sizeX-button.hoverTextures[0].SizeX*0.75;
	startY = hud.sizeY/2 - (buttonHeight*buttonAmount + inbetween*(buttonAmount+2))/2 + inbetween;

	//play button
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(play);
	button.setHoverTexture(buttonTextures[0]);
	button.setTexture(buttonTextures[0]);
	addInteractible(button);

	//load button
	startY+=buttonHeight+inbetween;
	button = Spawn(class'DELInterfaceButtonMain');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(loadGame);
	button.setHoverTexture(buttonTextures[1]);
	button.setTexture(buttonTextures[1]);
	addInteractible(button);

	//exit button
	startY+=buttonHeight+inbetween;
	button = Spawn(class'DELInterfaceButtonMain');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(exit);
	button.setHoverTexture(buttonTextures[2]);
	button.setTexture(buttonTextures[2]);
	addInteractible(button);
}

function play(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	start(hud.getPlayer());
}

function loadGame(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	hud.getPlayer().LoadGameState("DelmorSave");;
	start(hud.getPlayer());
}

function exit(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	hud.getPlayer().swapState('MainMenu');
}

function start(DELPlayerController c){
	c.startOver();
	c.swapState('Playing');
}

function draw(DELPlayerHud hud){
	//black background
	hud.Canvas.setDrawColor(0,0,0);
	hud.Canvas.setPos(0,0);
	hud.Canvas.drawRect(hud.SizeX, hud.SizeY);
	super.draw(hud);
}

DefaultProperties
{
	color=(R=0,G=0,B=0,A=0)
	bgColor=(R=20,G=20,B=20,A=200)
	textColor=(R=255,G=50,B=255,A=200)\

	deathImage=Texture2D'DelmorHud.DeathScreen'

	inbetween=20
	buttonAmount=3
	backgroundDimensionWidth=0.4

	buttonTextures=(Texture2D'DelmorHud.play', Texture2D'DelmorHud.load', Texture2D'DelmorHud.exit')
}
