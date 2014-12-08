class DELInterfaceScrollbar extends DELInterfaceObject;

function bool requiresUse(DELInputMouseStats stats){
	return stats.PendingScrollUp || stats.PendingScrollDown;
}

DefaultProperties
{

}
