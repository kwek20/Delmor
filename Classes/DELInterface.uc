/**
 * DELInterface base class.<br/>
 * This class is intended for extension and used in the PlayerHUD.
 */
class DELInterface extends Actor
	config(Game)
	abstract;

enum EPriority {
	LOWEST, LOW, NORMAL, HIGH, HIGHEST
};

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
 * Draw a colored tile
 */
function drawCTile(Canvas c, Texture2D texture, float XL, float YL, int r, int g, int b, int a, optional float U = 0.f, optional float V = 0.f){
	c.SetDrawColor(r,g,b,a);
	c.DrawTile(texture, XL, YL, U,V, texture.SizeX, texture.SizeY);
}


DefaultProperties
{

}
