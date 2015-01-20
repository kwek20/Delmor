/**
 * DELInterfaceInteractible is a class meant for extension.
 * You can add buttons which you can interact with
 */
class DELInterfaceInteractible extends DELInterfaceTexture;

/**
 * All the objects this interface has
 */
var() PrivateWrite array< DELInterfaceTexture > objects;

function load(DELPlayerHud hud){
	local DELInterfaceTexture obj;
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
public function bool addInteractible(DELInterfaceTexture obj){
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
	local DELInterfaceTexture object;
	object = getObjectByPosition(stats.MousePosition);
	if (object == none || DELInterfaceObject(object) == none)return;
	if (DELInterfaceObject(object).requiresUse(stats)) performAction(hud, DELInterfaceObject(object), stats);
}

/**
 * Looks for a button linked to a key.<br/>
 * Returns None if it does not exist
 * @param key The key we want the button of
 * @return the object or none
 */
protected function DELInterfaceButton getButtonByKey(int key){
	local DELInterfaceTexture object;
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
protected function DELInterfaceTexture getObjectByPosition(IntPoint position){
	local DELInterfaceTexture object, currentSmallest;
	foreach objects(object){
		if (object.containsPos(position)) {
			if (object.position.Z == 0 || object.position.W == 0)continue;

			if (currentSmallest == None || (currentSmallest.position.Z > object.position.Z)) {
				currentSmallest = object;
			}
		}
	}
	return currentSmallest;
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
	local DELInterfaceTexture object;
	super.draw(hud);

	//check for hover
	foreach objects(object){
		if (DELInterfaceObject(object)==none)continue;
		if (object != None && object.containsPos(DELPlayerInput(hud.PlayerOwner.PlayerInput).stats.MousePosition)){
			//mouse on button
			DELInterfaceObject(object).hover();
		}
	}
	
	//draw the object
	foreach objects(object){
		if (object != None)object.draw(hud);
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
