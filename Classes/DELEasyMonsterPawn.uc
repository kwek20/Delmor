/**
 * @author Bram
 * Pawn class for the easy enemy
 */
class DELEasyMonsterPawn extends DELHostilePawn
      placeable
	  Config(Game);

/**
 * Overriden so the pawn will receive a soundSet.
 */
simulated event PostBeginPlay(){
	super.PostBeginPlay();

	assignSoundSet();
}

/**
 * Assigns a soundSet to the pawn.
 */
private function assignSoundSet(){
	if ( mySoundSet != none ){
		mySoundSet.Destroy();
	}
	mySoundSet = spawn( class'DELSoundSetEasyMonster' );
	`log( self$" mySoundSet: "$mySoundSet );
}

defaultproperties
{	
	Components.Remove(ThirdPersonMesh);
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_ratman'
		AnimSets(0)=AnimSet'Delmor_Character.Ratman_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.Ratman_AnimTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.sk_ratman_Physics'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=-42.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	ControllerClass=class'DELEasyMonsterController'
	magicResistance = 1.0
	walkingSpeed = 120.0
	meleeRange = 50.0
}