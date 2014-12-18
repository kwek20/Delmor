/**
 * Interface for the health and mana bar
 */
class DELInterfaceHealthBars extends DELInterfaceTexture;

/**
 * The height of a bar.<br/>
 * The length is calculated from the (screen width / 5)
 */
var() int barSize;

function load(DELPlayerHud hud){
	setPos(0,hud.SizeY/36,hud.SizeX/3, hud.SizeY/6, hud);
	super.load(hud);
}

simulated function draw(DELPlayerHud hud){
	local int length, startX, startY;
	local DELPawn pawn;
	
	pawn = hud.getPlayer().getPawn();
	if (pawn == None || pawn.Health <= 0)return;
	super.draw(hud);

	length = position.Z/2;
	startX = position.Z-length;
	startY = barSize;

	//health bar
	hud.Canvas.SetDrawColor(255, 0, 0); // Red
	hud.Canvas.SetPos(startX, startY);   
	hud.Canvas.DrawRect(length * (float(pawn.Health) / float(pawn.HealthMax)), barSize); 

	//mana bar
	if (pawn.mana > 0){
		hud.Canvas.SetDrawColor(0, 0, 255); // blue
		hud.Canvas.SetPos(startX, startY+barSize);   
		hud.Canvas.DrawRect(length * (float(pawn.mana) / float(pawn.manaMax)), barSize); 
	}
}

DefaultProperties
{
	textures=(Texture2D'DelmorHud.balk_kompass');
	barSize=23;
}
