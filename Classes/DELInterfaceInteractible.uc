/**
 * DELInterfaceInteractible is a class meant for extension.
 * You can add buttons which you can interact with
 */
class DELInterfaceInteractible extends DELInterface;

var() PrivateWrite array< DELInterfaceButton > buttons;

/**
 * Adds a button to the list
 * @param btn The button to add
 */
public function bool addButton(DELInterfaceButton btn){
	buttons.AddItem(btn); 
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
 * @param p The playerhud
 * @param position The position where the mouse clicked
 */
public function onClick(DELPlayerHud p, IntPoint position){
	performAction(p, getButtonByPosition(position));
}

/**
 * Looks for a button linked to a key.<br/>
 * Returns None if it does not exist
 * @param key The key we want the button of
 */
protected function DELInterfaceButton getButtonByKey(int key){
	local DELInterfaceButton button;
	foreach buttons(button){
		if (button.identifiedBy(key)) return button;
	}
	return None;
}

/**
 * Looks for a button by position.<br/>
 * Returns None if it does not exist
 * @param position the position wher we want to check for a button
 */
protected function DELInterfaceButton getButtonByPosition(IntPoint position){
	local DELInterfaceButton button;
	foreach buttons(button){
		if (button.containsPos(position)) return button;
	}
	return None;
}

/**
 * Performs the action for the button passed.<br/>
 * Fails silently when one of the parameters are None
 * @param p The player hud
 * @param b The button we want to perform the action for
 */
public function performAction(DELPlayerHud p, DELInterfaceButton b){
	if (b == None || p == None) return;
	`log("Button action for " $ b.identifierKey);
	b.onUse(p);
}

/**
 * draw function. Gets called every tick.
 * @param hud the playerhud
 */
public function draw(DELPlayerHud hud){
	local DELInterfaceButton button;
	foreach buttons(button){
		button.draw(hud);
	}
}

public function bool canInteract(){
	return true;
}

DefaultProperties
{

}
