class DELInterfaceBar extends DELInterfaceInteractible;

var int squareSize, inbetween, amountBars;
var array<String> textures;

function load(DELPlayerHud hud){
	local DELInterfaceButton button;
	local int i, length, startX, startY;

	//Code for the box behind the buttons
	length = 5*squareSize + 6*inbetween;
	startX = hud.sizeX/2 - length/2;
	startY = hud.sizeY - squareSize*1.5;

	for (i=1; i<=amountBars; i++){
		button = Spawn(class'DELInterfaceButton');
		button.setIdentifier(i);
		button.setPosition(startX + i*inbetween + (i-1)*squareSize, startY + inbetween, squareSize, squareSize, hud);
		button.setRun(useMagic);
		addButton(button);
	}
}

function useMagic(DELPlayerHud hud){
	hud.log("RAN useMagic");
}

function draw(DELPlayerHud hud){
	local int length, startX, startY;
	local DELPawn pawn;
	
	pawn = DELPawn(hud.getPlayer().getPawn());
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
	squareSize=40
	inbetween=5;
	amountBars=5;

	textures = ("1", "2", "3", "4", "5")
}
