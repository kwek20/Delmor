/**
 * DELInterfaceInteractible is a class meant for extension.
 * You can add buttons which you can interact with
 */
class DELInterfaceInteractible extends DELInterfaceTexture;

/**
 * All the objects this interface has
 */
var() PrivateWrite array< DELInterfaceObject > objects;

function load(DELPlayerHud hud){
	local DELInterfaceObject obj;
	super.load(hud);
	//load every object
	foreach objects(obj){obj.load(hud);}
}

/**
 * Block usage on it by default
 */
function bool requiresUse(DELInputMouseStats stats){
	return false;
}

/**
 * Adds a DELInterfaceObject to the list
 * @param obj The button to add
 */
public function bool addInteractible(DELInterfaceObject obj){
	objects.AddItem(obj); 
	return true;
}

/**
 * Removes a DELInterfaceObject from the list
 * @param obj The button to remove
 * @return true when successful
 */
public function bool removeInteractible(DELInterfaceObject obj){
	local int i;

	for (i=0; i<objects.Length; i++){
		if (objects[i] == obj){
			objects[i] = none;
			return true;
		}
	}
	return false;
}

/**
 * Function which handles keypress
 * @param p The playerhud
 * @param key the key beeing pressed
 */
public function onKeyPress(DELPlayerHud p, int key){
	performAction(p, getButtonByKey(key));
}

/**
 * Function which handles mouse click
 * @param hud The playerhud
 * @param stats The mouse statistics
 */
public function onMouseUse(DELPlayerHud hud, DELInputMouseStats stats){
	local DELInterfaceObject object;
	object = getObjectByPosition(stats.MousePosition);
	if (object != None && object.requiresUse(stats)) performAction(hud, object, stats);
}

/**
 * Looks for a button linked to a key.<br/>
 * Returns None if it does not exist
 * @param key The key we want the button of
 * @return the object or none
 */
protected function DELInterfaceButton getButtonByKey(int key){
	local DELInterfaceObject object;
	foreach objects(object){
		if (DELInterfaceButton(object) != None && DELInterfaceButton(object).identifiedBy(key)) {
			return DELInterfaceButton(object);
		}
	}
	return None;
}

/**
 * Looks for a button by position.<br/>
 * Returns None if it does not exist
 * @param position the position wher we want to check for a button
 * @return the object or None
 */
protected function DELInterfaceObject getObjectByPosition(IntPoint position){
	local DELInterfaceObject object;
	foreach objects(object){
		if (object.containsPos(position)) {
			return object;
		}
	}
	return None;
}

/**
 * Performs the action for the button passed.<br/>
 * Fails silently when one of the parameters are None
 * @param p The player hud
 * @param b The button we want to perform the action for
 * @param stats optional, the mouse statistics
 */
public function performAction(DELPlayerHud p, DELInterfaceObject b, optional DELInputMouseStats stats){
	if (b == None || p == None) return;
	b.use();
	b.onUse(p, stats, b);
}

/**
 * draw function. Gets called every tick.
 * @param hud the playerhud
 */
public function draw(DELPlayerHud hud){
	local DELInterfaceObject object;
	super.draw(hud);

	//draw the object
	foreach objects(object){
		if (object != None)object.draw(hud);
	}

	//check for hover
	foreach objects(object){
		if (object != None && object.containsPos(DELPlayerInput(hud.PlayerOwner.PlayerInput).stats.MousePosition)){
			//mouse on button
			object.hover();
			object.onHover(hud, true);
		}
	}
}

/**
 * @return if you can interact
 * @deprecated
 */
public function bool canInteract(){
	return true;
}

DefaultProperties
{

}
