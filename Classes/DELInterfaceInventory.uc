class DELInterfaceInventory extends DELInterfaceInteractible;

var() Texture2D background;
var() int inbetween, length, buttonAmount, amountX, amountY;
var() float backgroundDimensionWidth;

function load(DELPlayerHud hud){
	local DELInterfaceButton button;
	local U_items item;
	local int startX, startY, i;
	
	i = 1;

	startX = hud.sizeX/2 - hud.sizeX*backgroundDimensionWidth/2 + inbetween;
	startY = hud.sizeY/2 - (length*buttonAmount + inbetween*(buttonAmount+2))/2 + inbetween;

	//foreach hud.getPlayer().getPawn().UInventory.UItems(item){

	for(i = 1; i <= (amountX*amountY); i++){
		button = Spawn(class'DELInterfaceButton');

		`log(startX + ((i % 5)*inbetween) + (((i % 5)-1)*length) @ startY + ((class'DELMath'.static.floor(i / 5) + 1)*inbetween) + ((class'DELMath'.static.floor(i / 5))*length) @ i);

		button.setPosition( startX + ((i % 5)*inbetween) + (((i % 5)-1)*length), 
							startY + ((class'DELMath'.static.floor(i / 5) + 1)*inbetween) + ((class'DELMath'.static.floor(i / 5))*length),                             length, length, hud);
		//button.setRun(exit);
		button.setText("text = " $ i);
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
	length=30
	amountX=5
	amountY=5
	background=Texture2D'UDKHUD.cursor_png'
}
