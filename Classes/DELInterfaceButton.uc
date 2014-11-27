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
	hud.Canvas.SetPos(position.X, position.Y);
	if (texture != None){
		hud.Canvas.DrawMaterialTile(texture, position.Z, position.W);
	} else {
		hud.Canvas.SetDrawColor(50, 0, 50); // Red
		hud.Canvas.DrawRect(position.Z, position.W);
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

DefaultProperties
{
	identifierKey=-1
	bCanActivate=true
}
