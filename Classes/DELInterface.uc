/**
 * DELInterface base class.<br/>
 * This class is intended for extension and used in the PlayerHUD.
 */
class DELInterface extends Actor
	config(Game)
	abstract;

/**
 * Interface load priority
 */
enum EPriority {
	LOWEST, LOW, NORMAL, HIGH, HIGHEST
};

/**
 * The sound you hear when this interface is loaded
 */
var() SoundCue openSound;

/**
 * Load method gets called upon adding a new DELInterface
 */
function load(DELPlayerHud hud){
	if (openSound != None)PlaySound( openSound );
}

/**
 * Unload function. <br/>
 * Gets called when the interface gets removed
 */
function unload(DELPlayerHud hud){

}

/**
 * Redraws the canvas objects for this Interface.
 */
function draw(DELPlayerHud hud);

/**
 * Lets this interface check on its own for updates.<br/>
 * When update returns true, draw(Canvas) will be called.
 */
function bool update();

/**
 * Draws a texture on the current position
 * Default colors will be used. Stretch from the entire image.
 */
function drawTile(Canvas c, Texture2D texture, float XL, float YL, optional float U = 0.f, optional float V = 0.f){
	drawCTile(c, texture, XL, YL, 255, 255, 255, 255, U, V);
}

/**
 * Draws a texture on the current position
 * Default colors will be used. Stretch from the entire image.
 */
function drawTileForced(Canvas c, Texture2D texture, float XL, float YL, optional float U = 0.f, optional float V = 0.f){
	drawCTileForced(c, texture, XL, YL, 255, 255, 255, 255, U, V);
}

/**
 * Draw a colored tile
 */
function drawCTile(Canvas c, Texture2D texture, float XL, float YL, int r, int g, int b, int a, optional float U = 0.f, optional float V = 0.f){
	c.SetDrawColor(r,g,b,a);
	c.DrawTile(texture, XL, YL, U, V, texture.SizeX, texture.SizeY);
}

/**
 * Draw a colored tile, forced size(partially)
 */
function drawCTileForced(Canvas c, Texture2D texture, float XL, float YL, int r, int g, int b, int a, optional float U = 0.f, optional float V = 0.f){
	c.SetDrawColor(r,g,b,a);
	c.DrawTile(texture, XL, YL, U, V, XL, YL);
}


DefaultProperties
{

}
