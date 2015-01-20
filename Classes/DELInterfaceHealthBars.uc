/**
 * Interface for the health and mana bar
 */
class DELInterfaceHealthBars extends DELInterfaceTexture;

/**
 * The height of a bar.<br/>
 * The length is calculated from the (screen width / 5)
 */
var() int barSize;

var() Texture2D healthBar, healthBarEdge;
var() Texture2D manaBar, manaBarEdge;
var() Texture2D edge;

function load(DELPlayerHud hud){
	local float yStart, xStart;
	yStart = hud.SizeY/36;
	xStart = hud.SizeY/36;

	setPos(xStart,yStart,hud.SizeX/3, hud.SizeY/7, hud);
	barSize = position.W / 4;
	super.load(hud);
}

simulated function draw(DELPlayerHud hud){
	local float length, totalLength, factor, startX, startY;
	local DELPawn pawn;
	
	pawn = hud.getPlayer().getPawn();
	if (pawn == None || pawn.Health <= 0)return;
	super.draw(hud);

	length = position.Z/2.3;
	startX = position.X+position.Z/2;
	startY = position.Y + position.W/4 - barSize/2;

	totalLength = length * (float(pawn.Health) / float(pawn.HealthMax));
	factor = totalLength / length;

	//health bar
	hud.Canvas.SetDrawColor(255, 0, 0); // Red
	drawBar(hud.Canvas, healthBar, healthBarEdge, edge, length, float(pawn.Health), float(pawn.HealthMax), startX, startY);

	//mana bar
	if (pawn.mana >= 0){
		hud.Canvas.SetDrawColor(0, 0, 255); // blue
		drawBar(hud.Canvas, manaBar, manaBarEdge, edge, length, 
			float(pawn.Mana), float(pawn.manaMax), 
			startX, startY+position.W/2);
	}
}

/**
 * Draws a bar based on values
 * @param c The canvas
 * @param texture The main texture
 * @param tEdge The edge from the main texture
 * @param edge The edge around it
 * @param length The maximum length
 * @param currentVar The current value from the bar were drawing
 * @param maxVar The maximum the value can have
 * @param startX The starting x position we're drawing from
 * @param startY The starting y position we're drawing from
 */
function drawBar(Canvas c, Texture2D texture, Texture2D tEdge, Texture2D edge, float length, float currentVar, float maxVar, float startX, float startY){
	local float totalLength, factor;

	if ( maxVar == 0.0 ) return;
	//total length of the bar
	totalLength = length * (currentVar / maxVar);
	//calculate factor for image scaling
	factor = totalLength / length;

	c.SetPos(startX, startY);  
	//draw tile based on length and factor
	c.DrawTile(texture, totalLength, barSize, 0.f, 0.f, texture.SizeX*factor, texture.SizeY);
	
	//if the bar is smaller then the tEdge
	if (length-totalLength>barSize/3){
		//set pos limited on max
		c.SetPos(startX + (barSize/2 > length ? totalLength-barSize : totalLength), startY); 
		//draw tile limited on the total length of the health
		c.DrawTile(tEdge, totalLength < barSize/2 ? int(totalLength) : barSize/2, barSize, 0.f, 0.f, tEdge.SizeX, tEdge.SizeY);
	}
	
	//draw the edge around it
	c.SetPos(startX-1, startY-1);   
	drawTile(c, edge, length*1.15, barSize*1.6+2);
}

DefaultProperties
{
	textures=(Texture2D'DelmorHud.balk_kompass');
	healthBar=Texture2D'DelmorHud.health_balk'
	healthBarEdge=Texture2D'DelmorHud.health_balk_bol'
	manaBar=Texture2D'DelmorHud.mana_balk'
	manaBarEdge=Texture2D'DelmorHud.mana_balk_bol'
	edge=Texture2D'DelmorHud.bar_edge'
}
