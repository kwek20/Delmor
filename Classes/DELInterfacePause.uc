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

	button = Spawn(class'DELInterfaceButton');
	button.setPosition(startX, startY, length, buttonHeight, hud);
	button.setRun(exit);
	button.setText("Exit");
	button.setColor(buttonColor);
	addInteractible(button);

	button = Spawn(class'DELInterfaceButton');
	button.setPosition(startX, startY+buttonHeight+inbetween, length, buttonHeight, hud);
	button.setRun(credits);
	button.setText("Credits");
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
	hud.Canvas.DrawRect(hud.sizeX*backgroundDimensionWidth, buttonHeight*buttonAmount + inbetween*(buttonAmount+2)); 
	super.draw(hud);
}

function credits(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	hud.getPlayer().swapState('Credits');
}

function exit(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	ConsoleCommand("quit");
}

DefaultProperties
{
	inbetween=10
	buttonHeight=30
	buttonAmount=4
	backgroundDimensionWidth=0.4

	buttonColor=(R=255,G=255,B=255,A=255)
}
