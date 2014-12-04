class DELInterfaceInventory extends DELInterfaceInteractible;

var() Texture2D background;
var() int inbetween, length, buttonAmount, amountX, amountY;
var() float backgroundDimensionWidth;

function load(DELPlayerHud hud){
	local DELInterfaceItemSlot button;
	local array<U_Items> items;
	local U_items item;
	local int startX, startY, i;
	
	startX = hud.sizeX/2 - ((AmountX*length)+((AmountX + 1)*inbetween))/2;
	startY = hud.sizeY/2 - ((AmountY*length)+((AmountY + 1)*inbetween))/2;

	items = hud.getPlayer().getPawn().UManager.UItems;

	for(i = 0; i < (amountX*amountY); i++){

		button = Spawn(class'DELInterfaceItemSlot');
		button.setPosition( startX + ((i % amountX + 1)*inbetween) + ((i % amountX)*length), 
							startY  + ((class'DELMath'.static.floor(i / amountX) + 1)*inbetween) 
									+ ((class'DELMath'.static.floor(i / amountX))*length),
							length, length, hud);

		if (items.Length > i){
			button.setRun(button.click);
			button.setHover(button.hover);
			button.setText(items[i].getName());
			button.setTexture(items[i].texture);
		}

		button.setIdentifier(i+1);
		addButton(button);
	}

	
}

function draw(DELPlayerHud hud){
	super.draw(hud);
}

DefaultProperties
{
	inbetween=10
	length=100
	amountX=4
	amountY=4
	background=Texture2D'UDKHUD.cursor_png'
}
