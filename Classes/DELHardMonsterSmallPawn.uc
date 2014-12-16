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

	if ( health <= healthMax / 2 ){ //Notify the controller that I'm damaged.
		DELHardMonsterSmallController( controller ).hitpointsBelowHalf();
	}
}

/**
 * Replaces the the small version of the pawn with a large version.
 */
exec function transform(){
	local DELHardMonsterLargePawn p;

	p = spawn( class'DELHardMonsterLargePawn' , , , , , , true );
	p.health = ( p.healthMax / healthMax ) * health;
	p.setRotation( rotation );
	p.setLocation( location );

	//Kill yourself
	controller.Destroy();
	destroy();	
}

DefaultProperties
{
	ControllerClass=class'Delmor.DELHardMonsterSmallController'

	//Mesh
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimtreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		Scale3D=(X=1, Y=1, Z=2)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=12.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)

	health = 100
	healthMax = 100
	healthRegeneration = 0
	GroundSpeed = 90.0
}