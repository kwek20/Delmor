class M5InvDisplay  extends Actor config(Game);
// Note: have to subclass Actor, JUST to have access to GetItemName();

/* Philip Brown, http://www.bolthole.com/udk/
 * 
 * This class is a very very trivial inventory display menu, done entirely in
 * UnrealScript, rather than needing the other fancy external stuff.
 * 
 * It displays a very simple grid of the items in InventoryManager, along with a currently
 * highlighted item. 
 * It has hooks for you to move cursor via CursorUp()/down/left/right
 * You can also find out the cursor's current inventory position, by calling
 * CursorInventoryIndex()
 *
 * Requirements:

 * 1. You have to either create a Material template, or download my package that contains
 *     some templates.   http://www.bolthole.com/udk/Bolthole.upk
 * 
 *    The material used for the above object, needs to have its Material use a
 *    texture which is wrapped in a TextureSampleParameter2D, aka Param2D, named 'Texture'
 * 
 * 2. You probably will have to customize the ItemToTexture() function.
 *    At minimum, read it, and note its order of where it looks for textures for items.
 * 
 * 3. You must call SetInventoryManager() after your Pawn actually has an inventory.
 *    I chose to do it in (PlayerController)  exec function ToggleInventory
 *    You are also responsible for setting up keyboard hooks to call this.Cursorxxxx(),
 *    and any other inventory interaction.
 *  
 * 4. You need to add hooks to actually call this. Sample code for that is at
 *     http://www.bolthole.com/udk/
 * 
 * See the "defaultparameters" at end, for tunables
 *
 * Notes:
 * This WILL work if the referenced texture is a "FlipTexture". It will calculate the
 * first display of it and use that.
 * Sorry, no animations as yet :) It's theoretically doable but I dont like dealing with
 * looping-over-time logic at the moment.
 *
 * This code might be a little simpler with a custom InventoryManager class that is
  * array based, but I wanted to keep external changes minimal.
 */

 
 // Having parameters in here "editable", is a bit silly, since this
 // class is not normally placed into scene. oh well. maybe globalconfig would help? 
 // naw that gets wierd with compile/import errors. sigh.
var  int 					MaterialIndex; // index into our Mesh's materials
var  StaticMeshComponent	DisplayComponent;
var  int ItemSize;  // in-window pixelsize(on one side) of itemicon

// These are for target search paths once we figure out name of object.
var  string IconBasePath;
var  string TextureBasePath;

var int WindowSizeX, WindowSizeY;

var bool colorinit;
var color CanvasDefaultColor; // Experimental

var MaterialInstanceConstant CanvasMaterial;
var ScriptedTexture CanvasTexture;
var MaterialInterface CanvasParentMat;
	
var Color TextColor;
var Color HighlightColor;
var Color Black;

var InventoryManager InventoryManager;

var int GridYOffset; // How far down to offset item display grid below title
var int NumCols;     // Number of columns of items to display
var int NumRows;     // Number of rows of items to display
// Note that NumCols*NumRows must be smaller than max inv size, which is 100?

var int oldcursorpos,newcursorpos; 
var int InventoryItemCount;


// This must be called by whatever initially spawns us.
//   (eg: ClientSetHUD ?)
function SetInventoryManager(InventoryManager inv)
{
	loginternal(GetFuncName()$" called, with value "$inv);
	InventoryManager=inv;
}

/** 
 * returns the index number of what item our 'cursor'
 * currently has highlighted.
 * Note that it starts at **ZERO**
 */
function int CursorInventoryIndex()
{
	return oldcursorpos;
}


/* This is a util function that attempts to do its job with the least amount
 * of manual hand-holding from a content designer. It attempts to "magically" 
 * figure out first, the correct name/type of the item, and then what texture
 * we should display for it.
 

   It currently does this by looking at whatever mesh is set for DroppedPickupMesh
    Note that FindTexture uses both an   	IconBasePath and a	 TextureBasePath
	First it will attempt to find a custom-drawn 'icon' for the object. If not, it 
	will just load a texture of approximately the same name, from the TextureBasePath.
	
	I do all this fancy footwork so that other folks get to do as little as possible
	that would be different from ordinary UDK use.
	
	I plan to have hundreds of different inventory item types. 
	If on the other hand, you have only a few, then there are lots of 
	ways you might make this simpler.
	One way: define a custom Inventory object, with a custom
	internal variable "string icon_name" or something, and directly reference that.
	
	Or, make a direct switch{} based on invitem.GetPathName() or some such.
	
 */
function Texture2D ItemToTexture(Inventory invitem)
{
	local PrimitiveComponent component;
	local SkeletalMesh skeletalmesh;
	local StaticMesh staticmesh;
	local MaterialInterface mat_int;
	local Texture2D texptr;
	
	loginternal("DEBUG: ItemToTexture: "$invitem.Class);
	
	component=invitem.DroppedPickupMesh;
	if(component==none){
		// some very, VERY rare things, dont have droppedpickup meshes. Sooo... ?
		// just fall back to straight class name. sigh..
		return FindTexture(string(invitem.Class));
	}
	staticmesh=StaticMeshComponent(component).StaticMesh;
	if(staticmesh!=none){
		loginternal(string(staticmesh)$" staticmesh to "$GetItemName(string(staticmesh)));
		texptr=FindTexture(GetItemName(string(staticmesh)));
		if(texptr!=none){
			return texptr;
		}
	}
	skeletalmesh=SkeletalMeshComponent(component).SkeletalMesh;
	if(skeletalmesh!=none){
		loginternal(string(skeletalmesh)$" skeletalmesh to "$GetItemName(string(skeletalmesh)));
		texptr=FindTexture(GetItemName(string(skeletalmesh)));
		if(texptr!=none){
			return texptr;
		}
	}
	
	// Desperate Fallback mechanism
	mat_int=MeshComponent(component).GetMaterial(0);
	
	texptr=FindTexture(GetItemName(string(mat_int)));
	if(texptr!=none){
		return texptr;
	}
	
	loginternal("	ARRG! ItemToTexture Failed");
	return texptr;
}

/** Pass in potential candidate for name of item.
 * We'll do the hard work of cleaning it up, and then looking through
 * the two places a valid inventory display texture might be.
 * Make sure to pass in DEPACKAGED "itemname", courtesy of GetItemName()
 */
function Texture2D FindTexture(string itemname)
{
	local string target;
	local int tmp_index;
	local int rightlen;
	local Texture2D texptr;
	
	if(itemname==string(none)){
		loginternal("ERROR: M5InvDisplay.FindTexture passed 'none'");
		return none;
	}
	
	tmp_index=InStr(itemname,"_");
	if(tmp_index==-1){
		target=itemname;
	} else {
		// there could be more than one.
		rightlen=Len(GetRightMost(itemname))+1;
		target=Left(itemname, Len(itemname)-rightlen);	
	}
	loginternal("FindTexture: Converted "$itemname$" to "$target);
	
	texptr = Texture2D(DynamicLoadObject(IconBasePath$"."$target, class'Texture'));
	if(texptr!=none){
		return texptr;
	}
	texptr = Texture2D(DynamicLoadObject(TextureBasePath$"."$target, class'Texture'));
	return texptr; // If it's empty, return it too!
}


/*
-- --  NEXT THINGS NEEDED:
Design how our inventoryitems work!
Set up sample inventory in AddDEfaultInventory
Create a InventoryToTexture routine
Make ourselves actually go through inventory.
Plus ideally allow a needsupdate from inventory, when inventory changed.
*/

function PostBeginPlay()
{

	local Texture valuecheck;
	local LinearColor ClearColor;
	
	ClearColor=MakeLinearColor(0,0,0,0);
	Black=MakeColor(0,0,0,0);
	TextColor=MakeColor(255,255,255,255);
	HighlightColor=MakeColor(150,155,20,255);
		
	loginternal("M5InvDisplay.--- Wall uses material of  "$class'Object'.PathName(CanvasParentMat));
	
	// This just validates that our target wall, has our required Named Parameer.
	CanvasParentMat.GetTextureParameterValue('Texture',valuecheck);
	if(valuecheck==none){
		`log("ERROR: M5InvDisplay: parent material does not allow Texture parameter override");
		return;
	}
   
	CanvasTexture = ScriptedTexture(class'ScriptedTexture'.static.Create(WindowSizeX, WindowSizeY,, ClearColor));
	CanvasTexture.Render = OnRender;
	
	//Convenience routine that clones a material to be a dynamic one
	CanvasMaterial=new Class'MaterialInstanceConstant';
	CanvasMaterial.SetParent(CanvasParentMat);
	CanvasMaterial.SetTextureParameterValue('Texture', CanvasTexture);
   
}

/** 
 * Tweak this as desired. This is the actual "Draw Stuff" routine.
 * Note that any Materials used to draw on our Canvas, MUST BE EMISSIVE!!
 * There is no light source "inside" this scripted dynamic canvas.
 */
function OnRender(Canvas C)
{
	local Vector2D TextSize;
	local string ConsoleText;
	local float TextScale;
	local Vector2D textPos;
	
	if(colorinit==false) // cant find other place where access to Canvas
	{
		CanvasDefaultColor=C.DrawColor;
		colorinit=true;
	}
	
	ConsoleText="Inventory";

	TextScale=1.0;
	
	C.TextSize(ConsoleText, TextSize.X, TextSize.Y);
	TextSize *= TextScale;
	textPos.Y=5;
	textPos.X =0;

	C.SetOrigin(0,0);
	C.SetClip(CanvasTexture.SizeX + TextSize.X, CanvasTexture.SizeY + TextSize.Y);
	C.SetDrawColorStruct(TextColor);
	C.SetPos(textPos.X, textPos.Y);

	C.DrawText(ConsoleText,, TextScale, TextScale);

	DisplayInventory(C);
	
	DisplayCursor(C);

	
	// Set this if you wanted some kind of looping, animated display, 
	// and want to code that stuff.
	//CanvasTexture.bNeedsUpdate = true;


}

// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
/** 
 * Iterate through inventory, and display each item.

 * Current plan:
 * Look up mesh name
 * Convert that thing into shorter name,via ItemToTexture().
 * This will look in
 *   - IconBasePath.name
 *   - TextureBasePath.name
 * Draw the texture.
 *
 * Note: for "In-World" display, wrapping in a Material seems obligatory to make colors right.
 * For In-HUD usage.... it's a toss-up.
 */
function DisplayInventory(Canvas C){
	local Inventory IPtr;
	local Texture2D itemtexture;
	local int itempos;
	
	itempos=0;
	
	loginternal("--M5InvDisplay.DisplayItems start");
	ForEach InventoryManager.InventoryActors(class'Inventory', IPtr){
		itemtexture=ItemToTexture(IPtr);
		
		C.SetDrawColor(255,255,255,255);
		DisplayTexture(C, itemtexture, itempos);
		
		//DisplayTextureInMat(C, itemtexture, itempos);
		itempos+=1;
	}
	
	InventoryItemCount=itempos;
	
	loginternal("--M5InvDisplay.DisplayItems end");
	
}

/** Given position in inventory, calculate Canvas Coords, for displaying
 * an item in our item grid.
 * If Item textures are 48 units, and we leave 2 units on BOTH sides, for grid highlight,
 * offset between items is still only 50x50, because the border would overlap
 */
function PosToGridCoords(int position, out int x, out int y)
{
	// first get inv-grid coord.  then convert to pixel offsets
	y=position/NumCols;  // let int truncation happen
	x=position-(y*NumCols);
	x=2+ (x*(ItemSize + 2));    // 2 is linewidth of DrawBox()
	y=2+ GridYOffset +(y*(ItemSize+2));
}

function CursorUp()
{
	local int oldpos; // to minimize race conditions?
	oldpos=oldcursorpos;
	if(oldpos >=NumCols){
		newcursorpos=oldpos-NumCols;
		CanvasTexture.bNeedsUpdate = true;
	}
}
function CursorDown()
{
	local int oldpos; // to minimize race conditions?
	oldpos=oldcursorpos+NumCols;
	if((oldpos<InventoryItemCount)&&(oldpos!=newcursorpos)){
		newcursorpos=oldpos;
		CanvasTexture.bNeedsUpdate = true;
	}

}
function CursorRight()
{
	local int oldpos; // to minimize race conditions?
	oldpos=oldcursorpos+1;
	if((oldpos<InventoryItemCount)&&(oldpos!=newcursorpos)){
		newcursorpos=oldpos;
		CanvasTexture.bNeedsUpdate = true;
	}
}
function CursorLeft()
{
	local int oldpos; // to minimize race conditions?
	oldpos=oldcursorpos-1;
	if((oldpos>=0)&&(oldpos!=newcursorpos)){
		newcursorpos=oldpos;
		CanvasTexture.bNeedsUpdate = true;
	}
}

/** 
  * Display a Box as a cursor of sorts around our "current" inventory item.
  * 
  * For efficiency in redraws, have global newcursorpos be object var, that is updated
 * dynamically, but we dont actually display until the updatethingie is called
 * via bNeedsUpdate
 */
function DisplayCursor(Canvas C)
{
	local int x,y;
	local int gridres; // x-pos increment between grid positions, aka grid resolution
	
	gridres=ItemSize+2;
	
	if(newcursorpos!=oldcursorpos){
		PosToGridCoords(oldcursorpos,x,y);
		C.SetDrawColorStruct(Black);
		C.SetPos(x-2,y-2);
		C.DrawBox(gridres,gridres);
	}
		
	C.SetPos(0,GridYOffset);
	C.SetDrawColorStruct(TextColor);
	C.DrawBox(2+NumCols*gridres, 2+NumRows*gridres);
	
	PosToGridCoords(newcursorpos,x,y);
	C.SetDrawColorStruct(HighlightColor);
	C.SetPos(x-2,y-2);
	C.DrawBox(gridres+2,gridres+2);
	oldcursorpos=newcursorpos;
}


/** 
 * Internal utility routine
 * Pass in a representational texture, and an inventory position,
 *   display it in our inventory window.

 * Default is 10x10 grid inventory display
 * Position may range from 0-99 (since InventoryManager can only hold 100 items?)
 * Note that if null texture passed in, will display an error block instead.
 */
 // I WANT to use this routine, but has side effects. See DisplayTextureInMat instead
function DisplayTexture(Canvas C, Texture2D tex_ref, int position)
{
	local int x,y;
	local float TWidth, THeight;

	PosToGridCoords(position,x,y);
	C.SetPos(x,y);	
	
	if(tex_ref==none)
	{
		loginternal("ERROR: DisplayTexture passed in null texture");
		C.SetDrawColorStruct(TextColor);
		C.DrawBox(40,40);
		C.SetPos(x,y+20);
		C.DrawText("Error");
		return;
	}
	
	TWidth=tex_ref.SizeX;
	THeight=tex_ref.SizeY;
			
	if(tex_ref.Class == class'TextureFlipBook')
	{
		TWidth= TWidth / TextureFlipBook(tex_ref).HorizontalImages;
		THeight= THeight / TextureFlipBook(tex_ref).VerticalImages;
	}
	
	C.DrawTile(tex_ref, ItemSize,ItemSize, 0,0,  TWidth, THeight);
	
}


defaultproperties
{	
	CanvasParentMat=Material'Bolthole.Materials.MaterialBase_Emissive_Unlit';

	bHidden=true;
	
	MaterialIndex=0
	ItemSize=48
	IconBasePath="Misa500.Icons"
	TextureBasePath="Misa500.Textures"

	WindowSizeX=600
	WindowSizeY=600
	
	GridYOffset=20
	NumCols=10
	NumRows=10
}
