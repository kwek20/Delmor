class DELPlayerHud extends UDkHUD
	config(game);

/**
 * Struct containing an interface with its priority
 */
struct InterFaceItem {
	var DELInterface interface;
	var EPriority priority;
};

/**
 * array of interfaces with load order. 
 * First is lowest, last is highest
 */
var() PrivateWrite array< InterFaceItem > interfaces;

var bool loadedInterfaces;

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

/**
 * Adds an interface with the correct priority.
 * @param interface the interface getting added
 * @param priority the priority
 */
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

/**
 * Clears the interfaces array. Removing all content
 */
function clearInterfaces(){
	local InterFaceItem i;
	foreach interfaces(i){i.interface.unload(self);}

	interfaces.Length = 0;
	loadedInterfaces = false;
}

/**
 * Gets an active interface by class name
 * @param interface the interface, must extend DELInterface
 * @return the interface or None
 */
function DELInterface getInterface(class<DELInterface> interface){
	local InterFaceItem item;
	foreach interfaces(item){
		if (item.interface.class == interface) return item.interface;
	}

	return none;
}

/**
 * Get all interfaces, ordered by priority
 */
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
	
	if (!loadedInterfaces)loadInterfaces();

	foreach interfaces(interface){
		interface.interface.draw(self);

	}
}

function loadInterfaces(){
	local InterFaceItem interface;
	foreach interfaces(interface){
		interface.interface.load(self);
	}

	loadedInterfaces = true;
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