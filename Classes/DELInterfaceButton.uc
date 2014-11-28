class DELInterfaceButton extends DELInterface;

var() bool bCanActivate;

/**
 * The positions for this button
 * z = xLength
 * w = yLength
 */
var() Vector4 position;

var() MaterialInstanceConstant texture; 

/**
 * The key you use to activate this button. None if not existing
 */
var() int identifierKey;

delegate onUse(DELPlayerHud hud);

/**
 * Checks if a position is inside this button
 */
public function bool containsPos(Vector2D p){
	if (!(p.X > position.X || p.X < position.X + position.Z))return false;
	return (p.Y > position.Y || p.Y < position.Y + position.W);
}

/**
 * Checks if the key is the same as this button its activation key
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

public function draw(DELPlayerHud hud){
	local float Xstring, Ystring;

	hud.Canvas.SetPos(position.X, position.Y);
	if (texture != None){
		hud.Canvas.DrawMaterialTile(texture, position.Z, position.W);
	} else {
		hud.Canvas.SetDrawColor(50, 0, 50); // purple
		hud.Canvas.DrawRect(position.Z, position.W);
		
		hud.Canvas.TextSize(identifierKey $ "", Xstring, Ystring);
		hud.Canvas.SetDrawColor(0, 0, 0); // black
		hud.Canvas.SetPos(  position.X + position.Z / 2 - Xstring / 2, 
							position.Y + position.W / 2 - Ystring / 2);
		hud.Canvas.DrawText(identifierKey $ "");
	}
}

/**
 * Sets the texture for this button
 */
public function setTexture(MaterialInstanceConstant mat){
	texture = mat;
}

public function setIdentifier(int key){
	identifierKey = Clamp(key, 0, 9);
}

public function setRun(delegate<onUse> runMethod){
	onUse = runMethod;
}

DefaultProperties
{
	identifierKey=-1
	bCanActivate=true
}
