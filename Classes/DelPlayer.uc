class DELPlayer extends DELCharacterPawn;

var array< class<Inventory> > DefaultInventory;
var Weapon sword;

simulated function bool IsFirstPerson(){
	return false;
}

function AddDefaultInventory()
{
	sword = Spawn(class'DELMeleeWeapon',,,self.Location);
	sword.GiveTo(Controller.Pawn);
	sword.bCanThrow = false; // don't allow default weapon to be thrown out
	Controller.ClientSwitchToBestWeapon();
}


simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	AddDefaultInventory();
}

DefaultProperties
{
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
	bCanBeBaseForPawn=true
	Components.Remove(ThirdPersonMesh);
		Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Lucian_walking'
		AnimSets(0)=AnimSet'Delmor_Character.Lucian_walking'
		PhysicsAsset=PhysicsAsset'Delmor_Character.Lucian_walking_Physics'
		AnimtreeTemplate=AnimTree'Delmor_Character.Lucian_AnimTree'
		Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=-50.0)
	End Object
    Components.Add(ThirdPersonMesh)
}