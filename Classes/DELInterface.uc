/**
 * DELInterface base class.<br/>
 * This class is intended for extension and used in the PlayerHUD.
 */
class DELInterface extends Actor
	config(Game)
	abstract;

/**
 * Redraws the canvas objects for this Interface.
 */
simulated function draw(DELPlayerHud hud);

/**
 * Lets this interface check on its own for updates.<br/>
 * When update returns true, draw(Canvas) will be called.
 */
simulated function bool update();

DefaultProperties
{
	
}
