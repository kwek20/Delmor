class DELInterfaceBar extends DELInterfaceInteractible;

var int sqaureSize, inbetween, amountBars;

simulated function draw(DELPlayerHud hud){
	local int length, startX, startY, i;
	local DELPawn pawn;
	
	pawn = DELPawn(hud.getPlayer().getPawn());
	if (pawn == None || pawn.Health <= 0)return;
	

	//hud.Canvas.Font = class'Engine'.static.GetLargeFont();   
	length = 5*sqaureSize + 6*inbetween;
	startX = hud.sizeX/2 - length/2;
	startY = hud.sizeY - sqaureSize*1.5;

	hud.Canvas.SetDrawColor(0, 0, 0); // black
	hud.Canvas.SetPos(startX, startY);   
	hud.Canvas.DrawRect(length, sqaureSize+inbetween*2); 

	hud.Canvas.SetDrawColor(20, 20, 20); // grey
	startY+=inbetween;

	for (i=1; i<=amountBars; i++){
		hud.Canvas.SetPos(startX + i*inbetween + (i-1)*sqaureSize, startY);   
		hud.Canvas.DrawRect(sqaureSize, sqaureSize); 
	}
}

DefaultProperties
{
	sqaureSize=40
	inbetween=5;
	amountBars=5;
}
