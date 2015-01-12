class DELInterfaceObject extends DELInterfaceTexture abstract;

var const int MAX_INT;

/**
 * The current texture of this button
 */
var() array<Texture2D> hoverTextures; 

/**
 * The color of the button if no texture has been found
 */
var() Color color, hoverColor;

/**
 * If this is true, the player is hovering on it
 */
var bool isHover;

/**
 * The sound you hear when someone clicks
 */
var() SoundCue clickSound;

/**
 * If this oject is completely see-through
 */
var() bool transparant;

/**
 * This function gets called when the button is used(mouse/key)
 * @param hud The player hud
 */
delegate onUse(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object);

/**
 * Private function which will be called before onUse<br/>
 * DONT CALL MANUALLY UNLESS YOU WANT THIS BUTTON TO BE "used"
 */
function use(){
	PlayClickSound();
}

/**
 * Default use check. Left pressed
 */
function bool requiresUse(DELInputMouseStats stats){
	return stats.PendingLeftPressed;
}

/**
 * Method we run when you hover on this object
 */
delegate onHover(DELPlayerHud hud, bool enter);

/**
 * Private function which will be called before onHover<br/>
 * DONT CALL MANUALLY UNLESS YOU WANT THIS BUTTON TO BE "HOVERED"
 */
function hover(){
	isHover = true;
	SetTimer(0.1, false, 'noHover');
}

/**
 * Stop hovering
 */
function noHover(){isHover=false;}

/**
 * Play the click sound
 */
function PlayClickSound(){
	PlaySound( clickSound );
}

/**
 * Draws the button. If no texture is defined it will draw a purple square with the key placed as text
 * @param hud The player hud.
 */
public function draw(DELPlayerHud hud){
	hud.Canvas.SetPos(position.X, position.Y);
	if (textures.Length > 0){
		super.draw(hud);
	} else {
		//behind the text square
		drawStandardbackground(hud.Canvas);
	}
}

/**
 * draw this object. <br/>
 * if you hover on this and a hover texture or color is set, this will display that.<br/>
 * Otherwise all textures will be drawn normally
 */
public function drawTexture(Canvas c, optional bool scale=true){
	if (textures.Length == 0 || transparant) return;
	if (isHover && (hoverTextures.Length > 0 || hoverColorSet())){
		if (hoverTextures.Length > 0){
			drawAllHoverTextures(c);
		} else {
			drawAllTexturesColored(c, hoverColor);
		}
	} else {
		drawAllTextures(c, scale);
	}
}

/**
 * Draw all normal textures with a hover color
 * @param c
 * @param hoverColor The color we emerge the image with
 */
public function drawAllTexturesColored(Canvas c, color hoverColor){
	local Texture2D texture;
	foreach textures(texture){
		c.SetPos(position.X, position.Y);
		drawCTile(c, texture, position.Z, position.W, hoverColor.R, hoverColor.G, hoverColor.B, hoverColor.A);
	}
}

/**
 * draw the hover textures for this object
 */
public function drawAllHoverTextures(Canvas c){
	local Texture2D hoverTexture;
	foreach hoverTextures(hoverTexture){
		c.SetPos(position.X, position.Y);
		drawTile(c, hoverTexture, position.Z, position.W);
	}
}

/**
 * Checks if there is a hover color set
 * @return true if there is
 */
private function bool hoverColorSet(){
	return hoverColor.R > 0 || hoverColor.G > 0 || hoverColor.B > 0 || hoverColor.A > 0;
}

/**
 * Backup draw.<br/>
 * If no texture is supplied we draw a rect<br/>
 * Takes hover into account
 */
public function drawStandardbackground(Canvas c){
	if (transparant) return;
	c.SetPos(position.X, position.Y);
	c.SetDrawColorStruct(isHover ? hoverColor : color);
	c.DrawRect(position.Z, position.W);
}

/**
 * Sets the hover texture for this button
 * @param mat The material to set
 */
public function setHoverTexture(Texture2D mat){
	hoverTextures.AddItem(mat);
}

/**
 * Sets the on use method
 * @param runMethod The method this button will run when you activate it
 */
public function setRun(delegate<onUse> runMethod){
	onUse = runMethod;
}

/**
 * Sets the hover method
 * @param runMethod The method this button will run when you hover above it with the mouse
 */
public function setHover(delegate<onHover> runMethod){
	onHover = runMethod;
}

/**
 * Sets the color for the button. <br/>
 * Only works if there is no texture
 */
public function setColor(color c){
	color = c;
}

/**
 * Sets the color based on ints
 */
public function setColorVars(int r, int g, int b, int a){
	local Color c;
	c.r = r;
	c.g = g;
	c.b = b;
	c.a = a;
	setColor(c);
}

/**
 * Toggles transparancy
 */
public function toggleTranparant(){
	transparant = !transparant;
}

DefaultProperties
{
	onHover = hover
	onUse = use;

	clickSound = SoundCue'Delmor_sound.ButtonKlik_Cue'

	color=(R=255,G=255,B=255,A=255)
	hoverColor=(R=175,G=175,B=175,A=255)

	MAX_INT= 2147483647
}
