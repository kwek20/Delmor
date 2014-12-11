class DELInterfaceObject extends DELInterfaceTexture abstract;

var const int MAX_INT;

/**
 * The current texture of this button
 */
var() Texture2D hoverTexture; 

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

function bool requiresUse(DELInputMouseStats stats){
	return stats.PendingLeftPressed;
}

delegate onHover(DELPlayerHud hud, bool enter);

/**
 * Private function which will be called before onHover<br/>
 * DONT CALL MANUALLY UNLESS YOU WANT THIS BUTTON TO BE "HOVERED"
 */
function hover(){
	isHover = true;
	SetTimer(0.1, false, 'noHover');
}

function noHover(){isHover=false;}

function PlayClickSound(){
	PlaySound( clickSound );
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

/**
 * javadoc voor brood
 */
public function drawTexture(Canvas c){
	if (texture == None || transparant) return;
	if (isHover && (hoverTexture != none || hoverColorSet())){
		if (hoverTexture != none&& false){
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

public function setColorVars(int r, int g, int b, int a){
	local Color c;
	c.r = r;
	c.g = g;
	c.b = b;
	c.a = a;
	setColor(c);
}

public function toggleTranparant(){
	transparant = !transparant;
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
