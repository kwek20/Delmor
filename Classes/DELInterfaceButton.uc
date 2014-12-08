/**
 * Button interface. Meanth for use in @link(DELinterfaceInteractible)
 */
class DELInterfaceButton extends DELInterfaceObject;

var() bool bCanActivate;

/**
 * The key you use to activate this button. None if not existing
 */
var() int identifierKey;

/**
 * The text displayed on the button
 */
var() string text;

var() Vector2D textOffset;

public function draw(DELPlayerHud hud){
	super.draw(hud);
	if (texture == None){
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
 * Set the button position

* @param x
 * @param y
 * @param length
 * @param width
 * @param hud The player hud. Needed for size check
 */
public function setPosition(int x, int y, int length, int width, DELPlayerHud hud){
	position.X = Clamp(x, 0, hud.SizeX);
	position.Y = Clamp(y, 0, hud.SizeY);

	//can only be max size - start point
	position.Z = Clamp(length, 0, hud.SizeX - x);
	position.W = Clamp(width, 0, hud.SizeY - y);
}

public function drawText(Canvas c){
	local float Xstring, Ystring;
	c.Font = class'Engine'.static.GetLargeFont();    
	c.TextSize(getText() $ "", Xstring, Ystring);
	c.SetDrawColor(0,0,0);
	c.SetPos(  position.X + position.Z * textOffset.X - Xstring / 2, 
							position.Y + position.W * textOffset.Y - Ystring / 2);
	c.DrawText(getText());
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
}
