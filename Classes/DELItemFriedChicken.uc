class DELItemFriedChicken extends DELItemPotionHealth;

var StaticMeshComponent DFCBucket;

/**
 * Picks up the item, putting it in the player's inventory.
 */
function pickUp( DELPawn picker ){
	`log( "Picked up: "$self );
	picker.UManager.AddInventory( self.Class, getAmount() );
	destroy();
}

DefaultProperties
{
	texture=Texture2D'DelmorHud.DFC'
	itemName="Delmor Fried Chicken"
	itemDescription="Chicken fried in the heat of a fireball"

	Begin Object Class=StaticMeshComponent Name=DFCBucket
		StaticMesh=StaticMesh'Delmor_Items.DFCBucket'
		HiddenGame=false
		HiddenEditor=false
	End Object

	bCollideActors=true
	bBlockActors=false

	Mesh=DFCBucket
	Components.Add(DFCBucket);
}
