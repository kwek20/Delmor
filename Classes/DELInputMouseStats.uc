class DELInputMouseStats extends Actor;

// Stored mouse position. Set to private write as we don't want other classes to modify it, but still allow other classes to access it.
var IntPoint MousePosition; 

// Pending left mouse button pressed event
var bool PendingLeftPressed;
// Pending left mouse button released event
var bool PendingLeftReleased;
// Pending right mouse button pressed event
var bool PendingRightPressed;
// Pending right mouse button released event
var bool PendingRightReleased;
// Pending middle mouse button pressed event
var bool PendingMiddlePressed;
// Pending middle mouse button released event
var bool PendingMiddleReleased;
// Pending mouse wheel scroll up event
var bool PendingScrollUp;
// Pending mouse wheel scroll down event
var bool PendingScrollDown;

private function removeRelease(){
	PendingLeftReleased = false;
	PendingMiddleReleased = false;
	PendingRightReleased = false;
	PendingScrollUp = false;
	PendingScrollDown = false;
}

function clear(){
	SetTimer(0.1, false, 'removeRelease');
}

DefaultProperties
{
}
