class DELInterfaceScrollbar extends DELInterfaceObject;

function draw(DELPlayerHud hud){
	
}

function bool requiresUse(DELInputMouseStats stats){
	return stats.PendingScrollUp || stats.PendingScrollDown;
}

DefaultProperties
{
	
}
