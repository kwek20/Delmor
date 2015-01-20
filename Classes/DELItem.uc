class DELItem extends Actor abstract;

var() const int maxSize;

var() private string itemName;
var() private string itemDescription;
var() Texture2D texture, hoverTexture;
var() SoundCue pickupSound, useSound;
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

/**
 * Picks up the item, putting it in the player's inventory.
 * @param picker    DELPawn The pawn that has picked up the item.
 */
function pickUp( DELPawn picker ){
	`log( "Picked up: "$self );
	picker.UManager.AddInventory( self.Class , 1 );
	destroy();
}

defaultproperties
{
	itemName="None"
	itemDescription="No description"
	texture=Texture2D'DelmorHud.freeze_spell'
	pickupSound=SoundCue'Delmor_sound.Pickup_Pop_Cue'
	amount=0
	playerBound=false
	maxSize=20;
}
