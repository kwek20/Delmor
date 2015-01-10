class DELInterfaceMainMenu extends DELInterfaceInteractible;

var() int inbetween, buttonAmount;
var float backgroundDimensionWidth;

var array<Texture2D> buttonTextures;
var Texture2D logo;

function load(DELPlayerHud hud){
	local DELInterfaceButtonMain button;
	local DELInterfaceTexture interface;
	local int length, startX, startY;
	local float buttonHeight;

	interface = Spawn(class'DELInterfaceTexture');
	interface.setTexture(logo);
	interface.setPos(50,50,hud.SizeX/5,logo.SizeY/(logo.SizeX/(hud.SizeX/5)), hud);
	addInteractible(interface);

	button = Spawn(class'DELInterfaceButtonMain');

	setPos(0,0,hud.SizeX,hud.SizeY,hud);
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

	//options button
	startY+=buttonHeight+inbetween;
	button = Spawn(class'DELInterfaceButtonMain');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(options);
	button.setHoverTexture(buttonTextures[2]);
	button.setTexture(buttonTextures[2]);
	addInteractible(button);

	//credits button
	startY+=buttonHeight+inbetween;
	button = Spawn(class'DELInterfaceButtonMain');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(credits);
	button.setHoverTexture(buttonTextures[3]);
	button.setTexture(buttonTextures[3]);
	addInteractible(button);

	//exit button
	startY+=buttonHeight+inbetween;
	button = Spawn(class'DELInterfaceButtonMain');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(exit);
	button.setHoverTexture(buttonTextures[4]);
	button.setTexture(buttonTextures[4]);
	addInteractible(button);
	super.load(hud);
}

function play(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	start(hud.getPlayer());
}

function loadGame(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	hud.getPlayer().LoadGameState("DelmorSave");;
	start(hud.getPlayer());
}

function options(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	
}

function credits(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	//hud.getPlayer().swapState('Credits');
	hud.ConsoleCommand("movietest credits");
}

function exit(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	ConsoleCommand("quit");
}

function start(DELPlayerController c){
	c.swapState('Playing');
	c.SetPause(false);
}

DefaultProperties
{
	inbetween=20
	backgroundDimensionWidth=0.4

	buttonAmount=5
	textures=(Texture2D'DelmorHud.startscherm_v3')
	openSound=none
	logo=Texture2D'DelmorHud.logo_menu'
	buttonTextures=(Texture2D'DelmorHud.play', Texture2D'DelmorHud.load', Texture2D'DelmorHud.options', Texture2D'DelmorHud.credits', Texture2D'DelmorHud.exit')
}
