/**
 * The abstract scroll interface.<br/>
 * This is used in the credits and quest log.
 * It features a scroll function
 */
class DELInterfaceScrollbar extends DELInterfaceObject abstract;

/**
 * The lock
 */
var DELInterfaceTexture lockedObject;

var() array< string > text;
var() float offset;
var() float percent;
var() float perScroll, perScrollPercent;


var bool downLock;

function load(DELPlayerHud hud){
	local float x,y;
	setRun(scroll);
	hud.Canvas.TextSize("1", x, y);
	perScroll=y;
	perScrollPercent=percentWeScrollPerLine(hud.Canvas);
}


function float maxLinesDisplayed(Canvas c){
	return class'DELMath'.static.floor(textFieldSize()/getLetterHeight(c));
}

/**
 * Calculates the average letter size
 * @return the y size
 * @param x out, the x size
 */
function float getLetterHeight(Canvas c, optional out float x, optional string text=""){
	local float xString, yString, totalX, totalY;

	c.Font = defaultFont;
	if (text==""){
		c.TextSize("1", xString, yString);
		totalX+=xString;totalY+=yString;

		c.TextSize("@", xString, yString);
		totalX+=xString;totalY+=yString;

		c.TextSize("Y", xString, yString);
		totalX+=xString;totalY+=yString;

		c.TextSize("k", xString, yString);
		totalX+=xString;totalY+=yString;
		x = totalX/4;
		return totalY/4;
	} else {
		c.TextSize(text, x, yString);
		return yString;
	}
}

function float textFieldSize(){
	return lockedObject.position.W - 2*offset;
}

function float percentWeScrollPerLine(Canvas c){
	return 100 / amountOfLinesWeScroll(c);
}

function int amountOfLinesWeScroll(Canvas c){
	return class'DELMath'.static.ceil(sizeOfTextWeScroll(c)/getLetterHeight(c));
}

function float sizeOfTextWeScroll(Canvas c){
	local float yString, yLength;
	yString = getLetterHeight(c);
	yLength = textFieldSize();
	return FClamp((text.Length*yString) - yLength, 0, text.Length*yString);
}

function draw(DELPlayerHud hud){
	drawPartial(hud, percent);
}

function drawPartial(DELPlayerHud hud , float percent);

function scroll(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	if (stats.PendingScrollUp && downLock) downLock = false;
	percent = FClamp(percent + stats.PendingScrollUp ? -perScrollPercent : perScrollPercent, 0 , 100);
}

function lockdown() {
	downLock = true;
}

function bool requiresUse(DELInputMouseStats stats){
	return stats.PendingScrollUp || stats.PendingScrollDown;
}

function setLocked(DELInterfaceTexture lockedObject){
	self.lockedObject = lockedObject;
	position = lockedObject.position;
}

DefaultProperties
{
}
