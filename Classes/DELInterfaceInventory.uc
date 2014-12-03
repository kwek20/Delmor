class DELInterfaceInventory extends DELInterfaceInteractible;

var() Texture2D background;
var() int inbetween, length, buttonAmount, amountX, amountY;
var() float backgroundDimensionWidth;

function load(DELPlayerHud hud){
	local DELInterfaceButton button;
	local U_items item;
	local int startX, startY, i;
	
	startX = hud.sizeX/2 - ((AmountX*length)+((AmountX + 1)*inbetween))/2;
	startY = hud.sizeY/2 - ((AmountY*length)+((AmountY + 1)*inbetween))/2;

	//foreach hud.getPlayer().getPawn().UInventory.UItems(item){

	for(i = 0; i < (amountX*amountY); i++){
		button = Spawn(class'DELInterfaceButton');

		`log(startX + ((i % amountX + 1)*inbetween) + (((i % amountX))*length) @ startY + ((class'DELMath'.static.floor(i / amountX) + 1)*inbetween) + ((class'DELMath'.static.floor(i / amountX))*length) @ i);

		button.setPosition( startX + ((i % amountX + 1)*inbetween) + ((i % amountX)*length), 
							startY + ((class'DELMath'.static.floor(i / amountX) + 1)*inbetween) + ((class'DELMath'.static.floor(i / amountX))*length),                             
							length, length, hud);
		//button.setRun(exit);
		button.setText("" $ (i+1));
		//button.setColor(buttonColor);
		addButton(button);
	}

	
}

function draw(DELPlayerHud hud){
	super.draw(hud);
}

DefaultProperties
{
	inbetween=10
	length=50
	amountX=8
	amountY=8
	background=Texture2D'UDKHUD.cursor_png'
}
