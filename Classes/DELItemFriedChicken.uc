class DELItemFriedChicken extends DELItemPotionHealth;

var StaticMeshComponent DFCBucket;

DefaultProperties
{
	texture=Texture2D'DelmorHud.DFC'
	itemName="Delmor Fried Chicken"
	itemDescription="Chicken fried in the heat of a fireball"

	Components.Remove(healthPotion);
	Begin Object Class=StaticMeshComponent Name=DFCBucket
		StaticMesh=StaticMesh'Delmor_Items.DFCBucket'
		HiddenGame=false
		HiddenEditor=false
	End Object
	Mesh=DFCBucket
	Components.Add(DFCBucket);

	bCollideActors=true
	bBlockActors=false
}
