/**
 * Pawn class for the medium enemy
 * @author Anders Egberts
 */
class DELMediumMonsterPawn extends DELHostilePawn
      placeable
	  Config(Game);

/**
 * selects a point in the animtree so it is easier acessible
 * it is unknown to me what the super does
 * @param SkelComp the skeletalmesh component linked to the animtree
 */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp){
	super.PostInitAnimTree(SkelComp);

	if (SkelComp == Mesh){
		SwingAnim = AnimNodePlayCustomAnim(SkelComp.FindAnimNode('CustomAnim'));
	}
}

/**
 * Overridden so that a take damage call will be sent to the controller.
 */
/*event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	if ( DamageType == class'DELDmgTypeMelee' && !IsInState( 'Blocking' ) ){
		if ( Rand( 3 ) == 1 ){
			interrupt();
			playGetHitAnimation();
		}
		DELMediumMonsterController( controller ).pawnHit();
	}
	super.TakeDamage( Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}*/

/**
 * This soundset contains the pawn's voice
 * Overriden so the pawn will receive a soundSet.
 */

simulated event PostBeginPlay(){
	super.PostBeginPlay();

	assignSoundSet();
}

/**
 * Spawn a blood effect to indicate that the pawn has been hit..
 */
function spawnChargeHit( vector l , rotator r ){
	local ParticleSystem p;

	p = ParticleSystem'Delmor_Effects.Particles.p_charge_hit';

	worldInfo.MyEmitterPool.SpawnEmitter( p , l , r );
}

/**
 * Assigns a soundSet to the pawn.
 */
private function assignSoundSet(){
	if ( mySoundSet != none ){
		mySoundSet.Destroy();
	}
	mySoundSet = spawn( class'DELSoundSetMediumPawn' );
}

event hitWhileNotBlocking(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	//Block randomly
	/*if ( bCanBlock && rand( 3 ) == 1 ){
		`log( "Start blocking" );
		startBlocking();
		setTimer( 1.0 , false , 'stopBlocking' );
	} else {
		if ( rand( 2 ) == 1 ){
			getHit();
		}
	}*/
	if ( DamageType == class'DELDmgTypeMelee' && !IsInState( 'Blocking' ) ){
		if ( Rand( 3 ) == 1 ){
			getHit();
		}
		DELMediumMonsterController( controller ).pawnHit();
	}

	super.hitWhileNotBlocking(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}

/**
 * Overridden so that the pawn take no damage from melee-attacks.
 * However when hit by a force attack, the pawn will be knocked back and the block will end.
 */
event hitWhileBlocking( vector HitLocation , class<DamageType> DamageType ){
	switch( DamageType ){
	case class'DELDmgTypeMelee':
		playBlockingSound();
		spawnBlockEffect( hitLocation );
		//Block even longer
		setTimer( 5.0 , false , 'stopBlocking' );
		//knockBack( 100.0 , location - DELHostileController( controller ).player.location , true );
		break;

	case class'DELDmgTypeMagical':
		DELMediumMonsterController( controller ).breakBlock();
		knockBack( 400.0 , location - DELHostileController( controller ).player.location );
	}
}

/**
 * Stop blocking and notify the controller that we've stopped blocking.
 * Also we will not be able to block for only two seconds.
 */
function stopBlocking(){
	super.stopBlocking();
	DELMediumMonsterController( controller ).PawnStoppedBlocking();
	bCanBlock = false;
	setTimer( 2.0 , false , 'resetCanBlock' );
}

defaultproperties
{
	ControllerClass=class'Delmor.DELMediumMonsterController'

	//Mesh
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_Rhinoman'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Rhinoman_anim'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.sk_Rhinoman_Physics'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Rhinoman_AnimTree'
		Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=-68.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)

	//Collision cylinder
	Begin Object Name=CollisionCylinder
		CollisionRadius = 48.0
		CollisionHeight = 64.0
	end object

	health = 200
	healthMax = 200
	healthRegeneration = 8
	walkingSpeed = 80.0
	detectionRange = 512.0
	bCanBlock = true
	mySoundSet = none
	meleeRange = 75.0
	attackInterval = 1.5
	groundSpeed = 150.0

	//Anim
	animname[ 0 ] = rhinoman_attack1
	attackAnimationImpactTime[ 0 ] = 0.7112
	animname[ 1 ] = rhinoman_attack2
	attackAnimationImpactTime[ 1 ] = 0.6851
	animname[ 2 ] = rhinoman_attack2
	attackAnimationImpactTime[ 2 ] = 0.6851
	deathAnimName = rhinoman_death
	knockBackAnimName = rhinoman_knockback
	knockBackAnimLength = 3.3333
	getHitAnimName = Rhinoman_Gettinghit1
	blockAnimName = Rhinoman_Dodge_extended

	deathAnimationTime = 0.5833

	swordClass = class'DELMeleeWeaponRhinomanFists'
	//swordClass = class'DELMeleeWeaponBattleAxe'
}