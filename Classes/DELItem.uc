class DELItem extends Actor abstract;

var() const int maxSize;

var() private string itemName;
var() private string itemDescription;
var() Texture2D texture, hoverTexture;
var() SoundCue pickupSound;
var() private int amount;
var() bool playerBound;

function int getAmount(){
	return amount;
}

function setAmount(int amount){
	if (amount < 0)amount=-1;
	self.amount=amount;
}

function String getDescription(){
	return itemDescription;
}

function String getName(){
	return itemName;
}

function bool isBound(){
	return playerBound;
}

defaultproperties
{
	itemName="None"
	itemDescription="No description"
	texture=Texture2D'DelmorHud.empty_item_bg'
	pickupSound=noSound
	amount=0
	playerBound=false
	maxSize=20;
}
