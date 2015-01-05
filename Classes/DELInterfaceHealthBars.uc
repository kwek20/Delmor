/**
 * Interface for the health and mana bar
 */
class DELInterfaceHealthBars extends DELInterfaceTexture;

/**
 * The height of a bar.<br/>
 * The length is calculated from the (screen width / 5)
 */
var() int barSize;

var() Texture2D healthBar, manaBar, edge;

function load(DELPlayerHud hud){
	local float yStart, xStart;
	yStart = hud.SizeY/36;
	xStart = hud.SizeY/36;

	setPos(xStart,yStart,hud.SizeX/3, hud.SizeY/7, hud);
	barSize = position.W / 4;
	super.load(hud);
}

simulated function draw(DELPlayerHud hud){
	local int length, startX, startY;
	local DELPawn pawn;
	
	pawn = hud.getPlayer().getPawn();
	if (pawn == None || pawn.Health <= 0)return;
	super.draw(hud);

	length = position.Z/2.3;
	startX = position.X+position.Z/2;
	startY = position.Y + position.W/4 - barSize/2;

	//health bar
	hud.Canvas.SetDrawColor(255, 0, 0); // Red
	hud.Canvas.SetPos(startX, startY);   
	drawTile(hud.Canvas, healthBar, length * (float(pawn.Health) / float(pawn.HealthMax)), barSize);
	hud.Canvas.SetPos(startX-1, startY-1);   
	drawTile(hud.Canvas, edge, length*1.15, barSize*1.6+2);

	//mana bar
	if (pawn.mana > 0){
		hud.Canvas.SetDrawColor(0, 0, 255); // blue
		hud.Canvas.SetPos(startX, startY+position.W/2);   
		drawTile(hud.Canvas, manaBar, length * (float(pawn.mana) / float(pawn.manaMax)), barSize); 
		hud.Canvas.SetPos(startX-1, startY+position.W/2-1);   
		drawTile(hud.Canvas, edge, length*1.15, barSize*1.6+2); 
	}
}

DefaultProperties
{
	textures=(Texture2D'DelmorHud.balk_kompass');
	healthBar=Texture2D'DelmorHud.health_balk'
	manaBar=Texture2D'DelmorHud.mana_balk'
	edge=Texture2D'DelmorHud.bar_edge'
}
