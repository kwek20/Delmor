class DELInterfaceObject extends DELInterface abstract;

var const int MAX_INT;

/**
 * The positions for this button
 * z = xLength
 * w = yLength
 */
var() Vector4 position;

/**
 * The current texture of this button
 */
var() Texture2D texture, hoverTexture; 

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
 * This function gets called when the button is used(mouse/key)
 * @param hud The player hud
 */
delegate onUse(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object);

function use(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject button){
	PlayClickSound();
}

function bool requiresUse(DELInputMouseStats stats){
	return stats.PendingLeftPressed;
}

delegate onHover(DELPlayerHud hud, bool enter);

function hover(DELPlayerHud hud, bool enter){
	isHover = true;
	SetTimer(0.1, false, 'noHover');
}

function noHover(){isHover=false;}

function PlayClickSound(){
	PlaySound( clickSound );
}

/**
 * Checks if a position is inside this button
 * @param p The IntPoint to check
 */
public function bool containsPos(IntPoint p){
	if (!(p.X > position.X && p.X < position.X + position.Z)){return false;}
	return (p.Y > position.Y && p.Y < position.Y + position.W);
}

/**
 * Draws the button. If no texture is defined it will draw a purple square with the key placed as text
 * @param hud The player hud.
 */
public function draw(DELPlayerHud hud){
	hud.Canvas.SetPos(position.X, position.Y);
	if (texture != None){
		drawTexture(hud.Canvas);
	} else {
		//behind the text square
		drawStandardbackground(hud.Canvas);
	}
}

public function drawTexture(Canvas c){
	if (texture == None) return;
	if (isHover && (hoverTexture != none || hoverColorSet())){
		if (hoverTexture != none){
			drawTile(c, hoverTexture, position.Z, position.W);
		} else {
			drawCTile(c, texture, position.Z, position.W, hoverColor.R, hoverColor.G, hoverColor.B, hoverColor.A);
		}
	} else {
		drawTile(c, texture, position.Z, position.W);
	}
}

private function bool hoverColorSet(){
	return hoverColor.R > 0 || hoverColor.G > 0 || hoverColor.B > 0 || hoverColor.A > 0;
}

public function drawStandardbackground(Canvas c){
	c.SetPos(position.X, position.Y);
	c.SetDrawColorStruct(isHover ? hoverColor : color);
	c.DrawRect(position.Z, position.W);
}

/**
 * Sets the texture for this button
 * @param mat The material to set
 */
public function setTexture(Texture2D mat){
	texture = mat;
}

/**
 * Sets the hover texture for this button
 * @param mat The material to set
 */
public function setHoverTexture(Texture2D mat){
	hoverTexture = mat;
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

DefaultProperties
{
	onHover = hover
	onUse = use;

	clickSound = SoundCue'a_interface.menu.UT3MenuAcceptCue'

	color=(R=255,G=255,B=255,A=255)
	hoverColor=(R=175,G=175,B=175,A=255)

	MAX_INT= 2147483647
}
