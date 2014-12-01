class DELPlayerHud extends UDkHUD
	config(game);

struct InterFaceItem {
	var DELInterface interface;
	var EPriority priority;
};

/**
 * array of interfaces with load order. 
 * First is lowest, last is highest
 */
var() PrivateWrite array< InterFaceItem > interfaces;

/*COMPASS VARIABLES*/
var DELMinimap GameMinimap;
var MaterialInstanceConstant GameMiniMapMIC;
var Material GameMinimapp;
var float TileSize;
var int MapDim;
var int BoxSize;
var float ResolutionScale;
var float MPosXMap;
var float MPosYMap;

simulated event PostBeginPlay() {
	Super.PostBeginPlay();

	GameMiniMap = DELGame(WorldInfo.Game).GameMinimap;
}

function addInterface(DELInterface interface, EPriority priority){
	local InterFaceItem interf, newItem;
	local int i;

	i=0;
	foreach interfaces(interf){
		if (interf.priority >= priority) break;
		i++;
	}   
	newItem.interface = interface;
	newItem.priority = priority;
	interfaces.insertItem(i, newItem);
}

function clearInterfaces(){
	interfaces.Length = 0;
}

function array<DELInterface> getInterfaces(){
	local array<DELInterface> interfaceArray;
	local InterFaceItem item;
	foreach interfaces(item){
		interfaceArray.AddItem(item.interface);
	}
	return interfaceArray;
}

function PlayerOwnerDied(){
	local DELPlayerController PC;
    PC = getPlayer();
	PC.gotoState('End');
}

function PostRender(){
	local InterFaceItem interface;
	super.PostRender();

	foreach interfaces(interface){
		interface.interface.draw(self);

	}
}

function log(String text){
	class'WorldInfo'.static.GetWorldInfo().Game.Broadcast(getPlayer(), text);
}

function DELPlayerController getPlayer(){
	return DELPlayerController(PlayerOwner);
}


defaultproperties 
{
	MapDim=256
	TileSize=0.4
	  BoxSize=12
	 MapPosition=(X=0.000000,Y=0.000000)
	clockIcon=(Texture=Texture2D'UDKHUD.Time') 
	ResolutionScale=1.0
}