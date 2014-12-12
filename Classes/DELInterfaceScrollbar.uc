class DELInterfaceScrollbar extends DELInterfaceObject abstract;

var DELInterfaceTexture lockedObject;

var() array< string > text;
var() float offset;
var() float percent;
var() float perScroll;

var bool downLock;

function load(DELPlayerHud hud){
	setRun(scroll);
}

function draw(DELPlayerHud hud){
	drawPartial(hud, percent);
}

function drawPartial(DELPlayerHud hud, float percent);

function scroll(DELPlayerHud hud, DELInputMouseStats stats, DELInterfaceObject object){
	if (stats.PendingScrollUp && downLock) downLock = false;
	percent = Clamp(percent + stats.PendingScrollUp ? -perScroll : (downLock ? 0.0 : perScroll), 1, 100);
}

function lockdown(){
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
	perScroll=1
	percent=2
}
