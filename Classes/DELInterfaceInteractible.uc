/**
 * DELInterfaceInteractible is a class meant for extension.
 * You can add buttons which you can interact with
 */
class DELInterfaceInteractible extends DELInterfaceTexture;

var() PrivateWrite array< DELInterfaceObject > objects;

function load(DELPlayerHud hud){
	local DELInterfaceObject obj;
	super.load(hud);
	foreach objects(obj){obj.load(hud);}
}

function bool requiresUse(DELInputMouseStats stats){
	return false;
}

/**
 * Adds a button to the list
 * @param btn The button to add
 */
public function bool addInteractible(DELInterfaceObject obj){
	objects.AddItem(obj); 
	return true;
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
	local Texture2D tex;
	super.draw(hud);

	foreach objects(object){
		object.draw(hud);
	}

	foreach objects(object){
		if (object.containsPos(DELPlayerInput(hud.PlayerOwner.PlayerInput).stats.MousePosition)){
			//mouse on button
			//object.hover();
			object.onHover(hud, true);
		}
	}
}

public function bool canInteract(){
	return true;
}

DefaultProperties
{

}
