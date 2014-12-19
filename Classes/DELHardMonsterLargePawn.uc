/**
 * @author Anders Egberts
 * Pawn class for the hard enemy
 */
class DELHardMonsterLargePawn extends DELHostilePawn
      placeable
	  Config(Game);


defaultproperties
{
	ControllerClass=class'Delmor.DELHardMonsterLargeController'
	swordClass = class'DELMeleeWeaponCulpaFists'
	//Mesh
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_culpa_Big'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Cupla_big_anim'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.sk_culpa_Big_Physics'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Culpa_big_AnimTree'
		Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=-136.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)

	health = 1000
	healthMax = 1000
	healthRegeneration = 0
	GroundSpeed = 95

	attackInterval = 1.0
	meleeRange = 160.0

	//Anim
	animname[ 0 ] = Culpa_Big_Attack
	animname[ 1 ] = Culpa_Big_Attack
	animname[ 2 ] = Culpa_Big_Attack
	deathAnimName = Culpa_Big_Val
	knockBackAnimName = ratman_knockback
	getHitAnimName = ratman_gettinghit

	physicalResistance = 0.0
	magicResistance = 0.0

	Begin Object Name=CollisionCylinder
		CollisionRadius = 36.0
		CollisionHeight = +132.0
	end object
}