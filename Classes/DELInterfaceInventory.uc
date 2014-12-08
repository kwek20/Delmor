class DELInterfaceInventory extends DELInterfaceInteractible;

var() Texture2D background;
var() int inbetween, length, buttonAmount, amountX, amountY;
var() float backgroundDimensionWidth;

function load(DELPlayerHud hud){
	local DELInterfaceItemSlot button;
	local array<DELItem> items;
	local DELItem item;
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
			item = items[i];
			button.setRun(button.click);
			button.setText(item.getAmount()$"");
			button.setTexture(item.texture);
			button.setHoverTexture(item.hoverTexture);
		} else {
			button.setText(" ");
		}

		button.setHover(button.hover);
		button.setIdentifier(i+1);
		addInteractible(button);
	}

	super.load(hud);
}

function draw(DELPlayerHud hud){
	local int w, h;

	w = (amountX*length + amountX+2*inbetween) * 1.5;
	h = (amountY*length + amountY+2*inbetween) * 1.5;

	hud.Canvas.setPos(hud.sizeX/2 - w/2, hud.sizeY/2 - h/2);
	drawTile(hud.Canvas, background, w, h);
	super.draw(hud);
}

DefaultProperties
{
	inbetween=10
	length=100
	amountX=4
	amountY=4
	background=Texture2D'DelmorHud.backpack'
	openSound=SoundCue'a_interface.menu.UT3MenuScreenSpinCue'
}
