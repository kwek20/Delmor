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

simulated event PostBeginPlay() {
	Super.PostBeginPlay();
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


function PostRender(){
	local InterFaceItem interface;

	if (!bShowHUD) return;
	if (getPlayer().isDead() && !(getPlayer().getStateName() == 'DeathScreen' || getPlayer().getStateName() == 'MainMenu')) return;

	if ( sizeChanged() ){
		reScaleStuff();
	}

	super.PostRender();
	
	if (!loadedInterfaces)loadInterfaces();
	
	foreach interfaces(interface){
		interface.interface.draw(self);
	}
}

function bool sizeChanged(){
	return SizeX != Canvas.SizeX || SizeY != Canvas.SizeY;
}

function reScaleStuff(){
	local string sub;
	sub = getPlayer().getSubtitle();
	getPlayer().goToPreviousState();
	getPlayer().goToPreviousState();
	getPlayer().showSubtitle(sub);
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
	ResolutionScale=1.0

	rotation=(Pitch=-6000,Yaw=0,Roll=0)
	startPos=(X=0,Y=200,Z=0)
}