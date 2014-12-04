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
	addButton(button);
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

function exit(DELPlayerHud hud, bool mouseClicked, DELInterfaceButton btn){
	ConsoleCommand("exit");
}

DefaultProperties
{
	inbetween=10
	buttonHeight=30
	buttonAmount=4
	backgroundDimensionWidth=0.4

	buttonColor=(R=255,G=255,B=255,A=255)
}
