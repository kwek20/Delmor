/**
 * Button interface. Meanth for use in @link(DELinterfaceInteractible)
 */
class DELInterfaceButton extends DELInterfaceObject;

/**
 * if you can use this button
 * @deprecated
 */
var() bool bCanActivate;

/**
 * The color from the box around a selected item
 */
var Color clickedColor;


/**
 * checks if the button is the last one clicked
 */
var bool bLastClicked;

/**
 * The key you use to activate this button. None if not existing
 */
var() int identifierKey;

/**
 * The text displayed on the button
 */
var() string text;

/**
 * The offset of a text displayment
 */
var() Vector2D textOffset;

/**
 * The background of a number
 */
var() Texture2D rondje_onder, rondje_onder_hover;

public function draw(DELPlayerHud hud){
	super.draw(hud);
	if (textures.Length == 0){
		drawText(hud.Canvas);
	}
}

/**
 * Checks if the key is the same as this button its activation key
 * @param key the key to compare
 */
public function bool identifiedBy(int key){
	if (key < 0) return false;
	return (key == identifierKey);
}

/**
 * Draw the text. <br/>
 * Takes position and offset into account.<br/>
 * Text taken from getText()
 */
public function drawText(Canvas c){
	local float Xstring, Ystring;
	if (getText() == "") return;
	c.Font = class'Engine'.static.GetLargeFont();    
	c.TextSize(getText() $ "", Xstring, Ystring);
	c.SetDrawColor(0,0,0);
	c.SetPos(  position.X + position.Z * textOffset.X - Xstring / 2, 
							position.Y + position.W * textOffset.Y - Ystring / 2);
	c.DrawText(getText());
}

/**
 * 
 * @param c the canvas we draw on
 * @param xOff The x offset based on interface position.x
 * @param yOff The y offset based on interface position.y
 * @param char The mesage we display
 * @param scale optional, default to 4. Meaning 1/4th of the total image
 */
public function drawNumber(Canvas c, float xOff, float yOff, string char, optional float scale=4){
	local float xSize, ySize;

	c.SetPos(position.X + xOff - position.Z/scale, position.Y + yOff - position.W/scale);
	drawTile(c, rondje_onder, position.Z/(scale/2), position.W/(scale/2));

	c.Font = defaultFont;
	c.setDrawColor(0,0,0);
	c.TextSize(char, xSize, ySize);
	c.SetPos(position.X + xOff - xSize/2, position.Y + yOff - ySize/2);
	c.DrawText(char);
	//draw color when we hover
	if (isHover){
		c.SetPos(position.X + xOff - position.Z/scale + (position.Z/(scale/2) - position.Z/(scale/12*7))/2, 
				 position.Y + yOff - position.W/scale + (position.W/(scale/2) - position.W/(scale/12*7))/2);
		drawTile(c, rondje_onder_hover, position.Z/(scale/12*7), position.W/(scale/12*7));
	}
}

/**
 * Make a drawNumber call with our default position and identifier
 */
public function drawIdentifier(Canvas c){
	drawNumber(c, position.Z, 0, String(identifierKey), 4);
}


/**
 * an addition to the draw texture
 * draws an outline around the used button
 * !warning has magic numbers for the extra space around buttons
 * @author harmen wiersma
 */
public function drawTexture(Canvas c, optional bool scale=true){
	super.drawTexture(c, scale);

}

/**
 * Sets the indentifier key for this button.<br/>
 * This means when you press this indentifier on the keyboard, the button will activate
 * @param key the key to use, currently just numbers
 */
public function setIdentifier(int key){
	identifierKey = Clamp(key, 0, MAX_INT);
}

/**
 * Sets the displayed text for the button. <br/>
 * Only works if there is no texture
 */
public function setText(string text){
	if (self.text == text) return;
	self.text = text;
}

/**
 * Returns the current text on the button
 * @return The text
 */
public function string getText(){
	return text != "" ? text : (identifierKey > -1 ? (string(identifierKey)) : "NO KEY");
}

DefaultProperties
{
	identifierKey=-1
	bCanActivate=true

	textOffset=(X=0.5,Y=0.5)
	clickedColor=(R=255,G=215,B=0,A=255)

	rondje_onder=Texture2D'DelmorHud.rondje_zonder_cijfer'
	rondje_onder_hover=Texture2D'DelmorHud.groene_overlay_transperant'

	clickSound = SoundCue'Delmor_sound.ButtonClick_Cue'
}
