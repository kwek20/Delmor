/**
 * DELInterface base class.<br/>
 * This class is intended for extension and used in the PlayerHUD.
 */
class DELInterface extends Actor
	config(Game)
	abstract;

enum EPriority {
  HIGHEST<value=5>, HIGH<value=4>, NORMAL<value=3>, LOW<value=2>, LOWEST<value=1>
};


/**
 * Load method gets called upon adding a new DELInterface
 */
function load(DELPlayerHud hud);

/**
 * Redraws the canvas objects for this Interface.
 */
function draw(DELPlayerHud hud);

/**
 * Lets this interface check on its own for updates.<br/>
 * When update returns true, draw(Canvas) will be called.
 */
function bool update();

DefaultProperties
{
	
}
