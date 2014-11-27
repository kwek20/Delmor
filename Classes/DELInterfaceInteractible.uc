class DELInterfaceInteractible extends DELInterface;

var() PrivateWrite array< DELInterfaceButton > buttons;

public function bool addButton(DELInterfaceButton btn){
	buttons.AddItem(btn); 
	return true;
}

public function onKeyPress(DELPlayerHud p, int key){
	performAction(p, getButtonByKey(key));
}

public function onClick(DELPlayerHud p, Vector2D position){
	performAction(p, getButtonByPosition(position));
}

protected function DELInterfaceButton getButtonByKey(int key){
	local DELInterfaceButton button;
	foreach buttons(button){
		if (button.identifiedBy(key)) return button;
	}
	return None;
}

protected function DELInterfaceButton getButtonByPosition(Vector2D position){
	local DELInterfaceButton button;
	foreach buttons(button){
		if (button.containsPos(position)) return button;
	}
	return None;
}

public function performAction(DELPlayerHud p, DELInterfaceButton b){
	if (b == none || p == None) return;
	
	`log("Button action for " $ b.identifierKey);
}

public function bool canInteract(){
	return true;
}

DefaultProperties
{

}
