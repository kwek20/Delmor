/**
 * @author Anders Egberts
 * Pawn class for the hard enemy
 */
class DELHardMonsterLargePawn extends DELHostilePawn
      placeable
	  Config(Game);

/**
 * The effective radius of the shockwave attack.
 */
var float shockWaveRadius;

event tick( float deltaTime ){
	super.tick( deltaTime );

	scaleMesh( deltaTime );
}

function scaleMesh( float deltaTime ){
	local vector newScale , scaleAdd , targetScale;

	targetScale.X = 1.0;
	targetScale.Y = 1.0;
	targetScale.Z = 1.0;

	//Increase size
	if ( !meshIsBigEnough() ){
		scaleAdd.X = deltaTime * 0.5;
		scaleAdd.Y = deltaTime * 0.5;
		scaleAdd.Z = deltaTime * 0.5;

		newScale = Mesh.Scale3D + scaleAdd;
		Mesh.SetScale3D( newScale );
	} else {
		Mesh.SetScale3D( targetScale );
	}
}

function bool meshIsBigEnough(){
	if ( Mesh.Scale3D.X >= 1.0 ){
		return true;
	} else {
		return false;
	}
}

/**
 * Overridden so that we'll perform a shockwave attack on the second attack.
 */
function attackEffects( int attackNumber ){
	`log( "attackEffects. attackNumber: "$attackNumber );
	switch( attackNumber - 1 ){
	case 1:
		shockWave();
		break;
	default:
		self.dealAttackDamage();
		break;
	}
}

/**
 * Perform a shockwave that blasts any pawn away.
 */
function shockWave(){
	local DELPawn p;
	local vector momentum , shockwaveLocation;
	local float shockwaveDamage;

	shockwaveLocation = getInFrontLocation();

	`log( self$" shockWave" );
	foreach WorldInfo.AllPawns( class'DELPawn' , p , shockwaveLocation , shockWaveRadius ){
		if ( p != self ){
			shockwaveDamage = DELMeleeWeapon( sword ).CalculateDamage();
			p.knockBack( 384.0 , adjustLocation( p.location  , shockwaveLocation.Z ) - getFloorLocation( location ) , false );
			//p.TakeDamage( DELMeleeWeapon( sword ).CalculateDamage() , Instigator.controller , ( p.location + location ) / 2 , momentum , class'DELDmgTypeMelee' );
			p.TakeRadiusDamage( Instigator.controller , shockwaveDamage , shockWaveRadius , class'DELDmgTypeMelee' , 1000 , shockwaveLocation , false , self );
		}
	}

	spawnShockwaveEffect( shockwaveLocation );
}

function spawnShockwaveEffect( vector shockwaveLocation ){
	local ParticleSystem p;
	local vector offSet;
	local rotator rot;

	p = ParticleSystem'Delmor_Effects.Particles.p_culpa_shockwave';
	offSet.Z = +1.0;

	rot.Pitch = 0 * DegToUnrRot;

	worldInfo.MyEmitterPool.SpawnEmitter( p , getFloorLocation( shockwaveLocation ) + offSet , rot );
}

/**
 * Empty knockback, Culpas cannot be knocked back.
 */
function knockBack( float intensity , vector direction , optional bool bNoAnimation ){
}

function hitFloor(){
	super.hitFloor();

	spawnShockwaveEffect( getFloorLocation( getASocketsLocation( 'FlashSocket' ) ) );
}

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
	GroundSpeed = 95.0

	attackInterval = 1.0
	meleeRange = 112.0
	detectionRange = 102400000.0

	//Anim
	animname[ 0 ] = Culpa_Big_Attack
	attackAnimationImpactTime[ 0 ] = 0.8533
	animname[ 1 ] = Culpa_Big_Attack_Jump
	attackAnimationImpactTime[ 1 ] = 0.8840
	animname[ 2 ] = Culpa_Big_Attack
	attackAnimationImpactTime[ 2 ] = 0.8533
	deathAnimName = Culpa_Big_Death_Extended
	knockBackAnimName = ratman_knockback
	getHitAnimName = ratman_gettinghit

	deathAnimationTime = 2.173

	physicalResistance = 0.0
	magicResistance = 0.0

	Begin Object Name=CollisionCylinder
		CollisionRadius = 64.0
		CollisionHeight = +132.0
	end object

	shockWaveRadius = 512.0

	bloodDecalSize = 256.0
}