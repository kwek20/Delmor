/**
 * Interface for the health and mana bar
 */
class DELInterfaceHealthBars extends DELInterface;

var() Texture2D bg; 

/**
 * The height of a bar.<br/>
 * The length is calculated from the (screen width / 5)
 */
var() int barSize;

simulated function draw(DELPlayerHud hud){
	local int length, startX, startY;
	local DELPawn pawn;
	
	pawn = hud.getPlayer().getPawn();
	if (pawn == None || pawn.Health <= 0)return;
	

	hud.Canvas.Font = class'Engine'.static.GetLargeFont();   
	length = bg.SizeX/4;
	startX = bg.SizeX/4-barSize/2;
	startY = bg.SizeY/6-barSize;

	hud.Canvas.SetPos(0,0);
	drawTile(hud.Canvas, bg, bg.SizeX/2, bg.SizeY/2);

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
	bg=Texture2D'DelmorHud.combars'
	barSize=23;
}
