

/*
 Reminder: to get your own custom PlayerController to load, have
  PlayerControllerClass=class'YourPlayerController'
 in your Game class
*/
class M5PlayerController extends UTPlayerController;


var M5InvDisplay M5InvDisplay;
var bool bShowInventory;
var ScriptedTexture  scriptex;
var MaterialInstanceConstant MaterialWrapper;


// There is a default keybinding for this, for F10
exec function ToggleInventory()
{
	if(M5InvDisplay!=none)
	{
		bShowInventory= !bShowInventory;
		return;
	}

	loginternal("  -- spawning M5InvDisplay");
	if(Pawn.InvManager==none){
		loginternal("  -- Pawn.InvManager null, cannot spawn");
		return;
	}
	M5InvDisplay=Spawn(class'M5InvDisplay',self); 
	M5InvDisplay.SetInventoryManager(Pawn.InvManager);

	// Now force some random objects to be in inventory. Tweak as you like...
	// But dont forget that you need to set up icons or materials for display,
	class'M5Inventory'.static.NewM5Item(Pawn,StaticMesh'Misa500.objects48.blockDiamond_48');
	class'M5Inventory'.static.NewM5Item(Pawn,StaticMesh'Misa500.objects48.blockEmerald_48');
	class'M5Inventory'.static.NewM5Item(Pawn,StaticMesh'Misa500.objects48.blockGold_48');
	class'M5Inventory'.static.NewM5Item(Pawn,StaticMesh'Misa500.objects48.brick_48');

}


// These four use override bindings in UDKGame/Config/DefaultInput.ini
// For the Up/Down/Left/Right arrows.
// Trouble is.. while left/right is unique, Up/Down is shared by w/s bindings
// Just override all four in that section, commenting out the old ones.
exec function M5_Moveup()
{
		WorldInfo.Game.Broadcast (self, "M5PlayerController.UP called");
		M5InvDisplay.CursorUp();
}
exec function M5_Movedown()
{
		WorldInfo.Game.Broadcast (self, "M5PlayerController.DOWN called");
		M5InvDisplay.CursorDown();
}
exec function M5_Moveleft()
{
		WorldInfo.Game.Broadcast (self, "M5PlayerController.LEFT called");
		M5InvDisplay.CursorLeft();
}
exec function M5_Moveright()
{
		WorldInfo.Game.Broadcast (self, "M5PlayerController.RIGHT called");
		M5InvDisplay.CursorRight();
}
/** 
 * "There are many other DrawHUD functions, (in this game, even!)
 *   but this one is mine"
 */
function DrawHUD(HUD H)
{
	local Canvas C;
	local int invsizex,invsizey, offsetx, offsety;
	// DrawHUD gets called on every frame refresh . SO dont debugspam.
	//loginternal("M5PlayerController: DrawHUD called (which prompts Player.DrawHUD)");
	Super.DrawHUD(H);
	
	if(M5InvDisplay==none){
		return;
	}
	
	if(bShowInventory==false){
		return;
	}

	/*I really dont want to do this MaterialInstance wrapper junk. But doing a straight
	 * DrawTile(scriptex, ...)
	 * Just doesnt seem to show anything!!
	 */

	if(MaterialWrapper==none){
		scriptex=M5InvDisplay.CanvasTexture;
		MaterialWrapper=new Class'MaterialInstanceConstant';
		
		// No visible difference. but Emissive, Unlit has a few less instructions so use that.
		//MaterialWrapper.SetParent(Material'Bolthole.Materials.MaterialBase_Emissive_Nondirectional');
		MaterialWrapper.SetParent(Material'Bolthole.Materials.MaterialBase_Emissive_Unlit');
		MaterialWrapper.SetTextureParameterValue('Texture', scriptex);	
	}

	invsizex=M5InvDisplay.WindowSizeX;
	invsizey=M5InvDisplay.WindowSizeY;
	C=H.Canvas;
	
	if((invsizex<C.Sizex) && (invsizey<C.SizeY))
	{
		offsetx=invsizex/2;
		offsety=invsizey/2;
		C.SetPos(C.Sizex/2 -offsetx, C.Sizey/2 - offsety);
		C.DrawMaterialTile(MaterialWrapper, invsizex,invsizey);
	} else {
		C.SetPos(0,0);
		C.DrawMaterialTile(MaterialWrapper, C.SizeX, C.SizeY);
	}
	
	//C.DrawTile(M5InvDisplay.CanvasTexture, invsize, invsize, 0,0, 500,500);
}
