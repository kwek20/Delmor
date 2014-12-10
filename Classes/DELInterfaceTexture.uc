class DELInterfaceTexture extends DELInterface;

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

public function draw(DELPlayerHud hud){
	drawTile(hud.Canvas, texture, position.Z, position.W);
}

public function drawTileScaled(DELPlayerHud hud, Texture2D texture, float width, float height, float scale){
	drawTile(hud.Canvas, texture, width*scale, height*scale);
}

public function drawTileScaledOnCanvas(DELPlayerHud hud, Texture2D texture){
	local float x,y;
	getScaledCoords(hud.SizeX, hud.SizeY, texture, x, y);
	drawTile(hud.Canvas, texture, x, y);
}

public function drawTileScaledOnCanvasCentered(DELPlayerHud hud, Texture2D texture){
	local float x,y;
	getScaledCoords(hud.SizeX, hud.SizeY, texture, x, y);
	hud.Canvas.SetPos(hud.CenterX-x/2, hud.CenterY-y/2);  
	drawTile(hud.Canvas, texture, x, y);
}

function getScaledCoords(float SizeX, float SizeY, Texture2D texture, out float x, out float y){
	x=(SizeX > SizeY ? SizeY : SizeX) / texture.SizeY;
	y=x;

	x*=texture.SizeX;
	y*=texture.Sizey;
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
 * Sets the texture for this button
 * @param mat The material to set
 */
public function setTexture(Texture2D mat){
	texture = mat;
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

DefaultProperties
{
}
