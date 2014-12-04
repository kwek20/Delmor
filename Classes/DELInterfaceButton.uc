/**
 * Button interface. Meanth for use in @link(DELinterfaceInteractible)
 */
class DELInterfaceButton extends DELInterface;

var() bool bCanActivate;

/**
 * The positions for this button
 * z = xLength
 * w = yLength
 */
var() Vector4 position;

/**
 * The current texture of this button
 */
var() Texture2D texture; 

/**
 * The key you use to activate this button. None if not existing
 */
var() int identifierKey;

/**
 * The text displayed on the button
 */
var() string text;

/**
 * The color of the button if no texture has been found
 */
var() Color color;

/**
 * This function gets called when the button is used(mouse/key)
 * @param hud The player hud
 */
delegate onUse(DELPlayerHud hud);

/**
 * Checks if a position is inside this button
 * @param p The IntPoint to check
 */
public function bool containsPos(IntPoint p){
	if (!(p.X > position.X && p.X < position.X + position.Z)){return false;}
	return (p.Y > position.Y && p.Y < position.Y + position.W);
}

/**
 * Checks if the key is the same as this button its activation key
 * @param key the key to compare
 */
public function bool identifiedBy(int key){
	if (key == -1) return false;
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

/**
 * Draws the button. If no texture is defined it will draw a purple square with the key placed as text
 * @param hud The player hud.
 */
public function draw(DELPlayerHud hud){
	local float Xstring, Ystring;
	local string message;

	hud.Canvas.SetPos(position.X, position.Y);
	if (texture != None){
		drawTile(hud.Canvas, texture, position.Z, position.W);
	} else {
		//behind the text square
		hud.Canvas.SetDrawColorStruct(color);
		hud.Canvas.DrawRect(position.Z, position.W);
		
		//text
		message = getText();
		hud.Canvas.Font = class'Engine'.static.GetLargeFont();    
		hud.Canvas.TextSize(message $ "", Xstring, Ystring);
		hud.Canvas.SetDrawColor(0,0,0);
		hud.Canvas.SetPos(  position.X + position.Z / 2 - Xstring / 2, 
							position.Y + position.W / 2 - Ystring / 2);
		hud.Canvas.DrawText(message);
	}
}

/**
 * Sets the texture for this button
 * @param mat The material to set
 */
public function setTexture(Texture2D mat){
	texture = mat;
}

/**
 * Sets the indentifier key for this button.<br/>
 * This means when you press this indentifier on the keyboard, the button will activate
 * @param key the key to use, currently just numbers
 */
public function setIdentifier(int key){
	identifierKey = Clamp(key, 0, 9);
}

/**
 * Sets the on use method
 * @param runMethod The method this button will run when you activate it
 */
public function setRun(delegate<onUse> runMethod){
	onUse = runMethod;
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

/**
 * Sets the color for the button. <br/>
 * Only works if there is no texture
 */
public function setColor(color c){
	color = c;
}

DefaultProperties
{
	color=(R=255,G=255,B=255,A=255)
	identifierKey=-1
	bCanActivate=true
}
