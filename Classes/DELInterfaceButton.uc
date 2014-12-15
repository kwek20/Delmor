/**
 * Button interface. Meanth for use in @link(DELinterfaceInteractible)
 */
class DELInterfaceButton extends DELInterfaceObject;

var() bool bCanActivate;

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

var() Vector2D textOffset;

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
 * an addition to the draw texture
 * draws an outline around the used button
 * !warning has magic numbers for the extra space around buttons
 * @author harmen wiersma
 */
public function drawTexture(Canvas c){
	super.drawTexture(c);
	if(bLastClicked && textures.Length>0){
		c.SetDrawColor(clickedColor.R,clickedColor.G,clickedColor.B,clickedColor.A);
		c.SetPos(position.X-5,position.Y-5,position.Z);
		c.DrawBox(position.W + 2*5 , position.Z + 2*5); 
	}
}

/**
 * checks if this item from the quick menu is the last used one
 * if not, then it will be
 * if it is then it won't be anymore
 * @author harmen wiersma
 */
public function useQItem(){
	if(bLastClicked){ bLastClicked = false;}
	else{ bLastClicked =true;}
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
}
