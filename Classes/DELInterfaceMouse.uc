/**
 * Mouse interface. This draws the mouse on the screen
 */
class DELInterfaceMouse extends DELInterfaceTexture;

simulated function load(DELPlayerHud hud){
	//set the mouse in the center
	DELPlayerInput(hud.PlayerOwner.PlayerInput).setMousePos(hud.centerX, hud.centerY);
}

/**
 * Redraws the canvas objects for this Interface.
 */
simulated function draw(DELPlayerHud hud){
	local DELPlayerInput MouseInterfacePlayerInput;

	// Ensure that we have a valid PlayerOwner and CursorTexture
	if (hud.PlayerOwner != None) {
		// Cast to get the MouseInterfacePlayerInput
		MouseInterfacePlayerInput = DELPlayerInput(hud.PlayerOwner.PlayerInput); 
		if (MouseInterfacePlayerInput != None){
			// Set the canvas position to the mouse position
			setPosition(MouseInterfacePlayerInput.stats.MousePosition.X, MouseInterfacePlayerInput.stats.MousePosition.Y, 64, 64, hud); 
			super.draw(hud);
		}
	}
}

/**
 * Lets this interface check on its own for updates.<br/>
 * When update returns true, draw(Canvas) will be called.
 */
simulated function bool update();
	

DefaultProperties
{
	textures=(Texture2D'DelmorHud.cursor')
}
