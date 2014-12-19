/**
 * Pawn class for the medium enemy
 * @author Bram
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
event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	super.TakeDamage( Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	if ( DamageType == class'DELDmgTypeMelee' ){
		DELMediumMonsterController( controller ).pawnHit();
	}
}

/**
 * This soundset contains the pawn's voice
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
	mySoundSet = spawn( class'DELSoundSetMediumPawn' );
}

/**
 * Blocking state.
 * While in the blocking state the pawn should get no damage from melee attacks.
 */
state Blocking{

	function beginState( name previousStateName ){
		super.beginState( previousStateName );

		//Stop after five seconds
		setTimer( 5.0 , false , 'stopBlocking' );
	}
	/**
	 * Overridden so that the pawn take no damage from melee-attacks.
	 * However when hit by a force attack, the pawn will be knocked back and the block will end.
	 */
	event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
	class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){

		switch( DamageType ){
		case class'DELDmgTypeMelee':
			playBlockingSound();
			//Block even longer
			setTimer( 5.0 , false , 'stopBlocking' );
			knockBack( 100.0 , location - DELHostileController( controller ).player.location , true );
			break;

		case class'DELDmgTypeMagical':
			breakBlock();
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

	/**
	 * Called when hit a by player's force attack.
	 * When the block is broken the pawn will not be able to block for five seconds.\
	 * Also notify the controller that our block was broken.
	 */
	function breakBlock(){
		super.stopBlocking();
		DELMediumMonsterController( controller ).PawnBlockBroken();
		bCanBlock = false;
		setTimer( 5.0 , false , 'resetCanBlock' );
	}
}


/*
 * Say a line from the sound set. Only one sound can be played per 2 seconds.
 */
function say( String dialogue ){
	`log( ">>>>>>>>>>>>>>>>>>>> "$self$" said something ( "$dialogue$" )" );
	if ( mySoundSet.bCanPlay ){
		mySoundSet.PlaySound( mySoundSet.getSound( dialogue ) );
		mySoundSet.bCanPlay = false;
		mySoundSet.setTimer( 2.0 , false , nameOf( mySoundSet.resetCanPlay ) );
	}
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

	health = 150
	healthMax = 150
	healthRegeneration = 4
	walkingSpeed = 80.0
	detectionRange = 512.0
	bCanBlock = true
	mySoundSet = none
	meleeRange = 75.0
	attackInterval = 3.0
	groundSpeed = 200.0

	//Anim
	animname[ 0 ] = rhinoman_attack1
	animname[ 1 ] = rhinoman_attack2
	animname[ 2 ] = rhinoman_attack2
	deathAnimName = rhinoman_death
	knockBackAnimName = rhinoman_knockback
	getHitAnimName = rhinoman_gettinghit
}