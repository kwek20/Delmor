/**
 * The pawn for the HardMonster. It will be weak but later it should transform in a more 
 * formidable opponent.
 * 
 * @author Anders Egberts.
 */
class DELHardMonsterSmallPawn extends DELHostilePawn
      placeable
	  Config(Game);

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	super.TakeDamage( Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );

	if ( health <= healthMax / 2 && health > 0 ){ //Notify the controller that I'm damaged.
		DELHardMonsterSmallController( controller ).hitpointsBelowHalf();
	}
}

/**
 * Replaces the the small version of the pawn with a large version.
 */
exec function transform(){
	shapeShift( class'DELHardMonsterLargePawn' );
}

DefaultProperties
{
	ControllerClass=class'Delmor.DELHardMonsterSmallController'

	//Mesh
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_culpa_small'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Culpa_small_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Culpa_small_AnimTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.sk_culpa_small_Physics'
		Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=-136.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)

	health = 100
	healthMax = 100
	healthRegeneration = 0
	GroundSpeed = 365.0
	Begin Object Name=CollisionCylinder
		CollisionRadius = 36.0
		CollisionHeight = +132.0
	end object
}