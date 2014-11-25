class DELInterfaceHealthBars extends DELInterface;

var() int barSize;

simulated function draw(DELPlayerHud hud){
	local int length, startX, startY;
	local DELPawn pawn;
	
	pawn = DELPawn(hud.getPlayer().getPawn());
	if (pawn == None || pawn.Health <= 0)return;
	

	hud.Canvas.Font = class'Engine'.static.GetLargeFont();   
	length = hud.SizeX/5;
	startX = 30;
	startY = 15;

	hud.Canvas.SetDrawColor(255, 0, 0); // Red
	hud.Canvas.SetPos(startX, startY);   
	hud.Canvas.DrawRect(length * (float(pawn.Health) / float(pawn.HealthMax)), barSize); 

	if (pawn.mana > 0){
		hud.Canvas.SetDrawColor(0, 0, 255); // blue
		hud.Canvas.SetPos(startX, startY+barSize);   
		hud.Canvas.DrawRect(length * (float(pawn.mana) / float(pawn.manaMax)), barSize); 
	}
}

DefaultProperties
{
	barSize=30;
}
