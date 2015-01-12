/**
 * The pause menu
 */
class DELInterfacePause extends DELInterfaceInteractible;

var() int inbetween, buttonHeight, buttonAmount;
var() float backgroundDimensionWidth;
var() Color buttonColor;

function load(DELPlayerHud hud){
	local DELInterfaceButton button;
	local int length, startX, startY;

	length = hud.sizeX*backgroundDimensionWidth - 2*inbetween;
	startX = hud.sizeX/2 - hud.sizeX*backgroundDimensionWidth/2 + inbetween;
	startY = hud.sizeY/2 - (buttonHeight*buttonAmount + inbetween*(buttonAmount+2))/2 + inbetween;

	//Resume button
	button = Spawn(class'DELInterfaceButton');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(resume);
	button.setText("Resume");
	button.setColor(buttonColor);
	addInteractible(button);

	//save button
	startY+=buttonHeight+inbetween;
	button = Spawn(class'DELInterfaceButton');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(saveGame);
	button.setText("Save");
	button.setColor(buttonColor);
	addInteractible(button);

	//load button
	startY+=buttonHeight+inbetween;
	button = Spawn(class'DELInterfaceButton');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(loadGame);
	button.setText("Load");
	button.setColor(buttonColor);
	addInteractible(button);

	//credits button
	startY+=buttonHeight+inbetween;
	button = Spawn(class'DELInterfaceButton');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(credits);
	button.setText("Credits");
	button.setColor(buttonColor);
	addInteractible(button);

	//exit button
	startY+=buttonHeight+inbetween;
	button = Spawn(class'DELInterfaceButton');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(exit);
	button.setText("Exit");
	button.setColor(buttonColor);
	addInteractible(button);

	super.load(hud);
}

function draw(DELPlayerHud hud){
	local int startX, startY;
	//Code for the box behind the buttons
	startX = hud.sizeX/2 - hud.sizeX*backgroundDimensionWidth/2;
	startY = hud.sizeY/2 - (buttonHeight*buttonAmount + inbetween*(buttonAmount+2))/2;

	hud.Canvas.SetDrawColor(20, 20, 20, 200); // semi-transparant grey
	hud.Canvas.SetPos(startX, startY);   
	hud.Canvas.DrawRect(hud.sizeX*backgroundDimensionWidth, buttonHeight*buttonAmount + inbetween*(buttonAmount+1)); 
	super.draw(hud);
}

function resume(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	hud.getPlayer().swapState('Playing');
}

function saveGame(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	
}

function loadGame(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	
}

function credits(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	hud.getPlayer().swapState('Credits');
}

function exit(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	hud.getPlayer().swapState('MainMenu');
}

DefaultProperties
{
	inbetween=10
	buttonHeight=30
	buttonAmount=5
	backgroundDimensionWidth=0.4

	buttonColor=(R=255,G=255,B=255,A=255)
}
