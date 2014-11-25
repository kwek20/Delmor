class DELInterfaceMouse extends DELInterface;

// The texture which represents the cursor on the screen
var const Texture2D CursorTexture; 
// The color of the cursor
var const Color CursorColor;

/**
 * Redraws the canvas objects for this Interface.
 */
simulated function draw(DELPlayerHud hud){
	local DELMouseInterfacePlayerInput MouseInterfacePlayerInput;

	// Ensure that we have a valid PlayerOwner and CursorTexture
	if (hud.PlayerOwner != None /*&& CursorTexture != None*/) {
		// Cast to get the MouseInterfacePlayerInput
		MouseInterfacePlayerInput = DELMouseInterfacePlayerInput(hud.PlayerOwner.PlayerInput); 

		if (MouseInterfacePlayerInput != None){
			// Set the canvas position to the mouse position
			hud.Canvas.SetPos(MouseInterfacePlayerInput.MousePosition.X, MouseInterfacePlayerInput.MousePosition.Y); 
			// Set the cursor color
			hud.Canvas.DrawColor = CursorColor;
			// Draw the texture on the screen
			//hud.Canvas.DrawTile(CursorTexture, CursorTexture.SizeX, CursorTexture.SizeY, 0.f, 0.f, CursorTexture.SizeX, CursorTexture.SizeY,, true);
			hud.Canvas.DrawRect(20, 20); 
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
	CursorColor=(R=255,G=255,B=255,A=255)
	CursorTexture=Texture2D'EngineResources.Cursors.Arrow'
}
