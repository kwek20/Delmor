class DELItemPickup extends Actor placeable;

var() editconst const CylinderComponent	CylinderComponent;
var() const editconst DynamicLightEnvironmentComponent LightEnvironment;


//the physical pickup that is seen in the world as a "Bag" which will contain any kind of inventory and a certain amount.

var     DELInventoryManager	InvManager;

var()	string	ItemName;

var()   string	PickupMessage;			// Human readable description when picked up.

var() SoundCue PickupSound;

var() class<DELItem> ItemType;

var() int ItemAmount_ADD;

var DELPawn UHP;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    super.Touch(Other, OtherComp, HitLocation, HitNormal);

    UHP = DELPawn(Other);

    if (UHP != none)
    {
       //If the inventory check returns false (has space) add the item.
       if(!(UHP.UManager.CheckInventorySize(ItemType, ItemAmount_ADD)))
       {
         //Add the picked up item
         GiveTo(UHP);
         PlaySound(PickUpSound);
         //UHP.UManager. NotifyHUDMessage(PickUpMessage, ItemAmount_ADD, ItemName);

       }
    }
}


//Add to pawns inventory once picked up
//If you still have space add it to the inventory
 function GiveTo( DELPawn Other )
{
	if ( Other != None && Other.UManager != None )
	{
		Other.UManager.AddInventory(ItemType, ItemAmount_ADD );
		Destroy();

		
	}

}

defaultproperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=TRUE
    End Object

    LightEnvironment=MyLightEnvironment
    Components.Add(MyLightEnvironment)


    Begin Object class=StaticMeshComponent Name=BaseMesh
        StaticMesh=None //StaticMesh'Items.Items.ItemBag' Add your own staticmesh
        Scale = 3.5
        LightEnvironment=MyLightEnvironment
    End Object
    Components.Add(BaseMesh)
    
    Begin Object Class=CylinderComponent NAME=CollisionCylinder
		CollideActors=true
		CollisionRadius=+0040.000000
		CollisionHeight=+0040.000000
		bAlwaysRenderIfSelected=true
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bHidden=false
	bCollideActors=true
}