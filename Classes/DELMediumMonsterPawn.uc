/**
 * Pawn class for the medium enemy
 * @author Bram
 */
class DELMediumMonsterPawn extends DELHostilePawn
      placeable
	  Config(Game);
/**
 * This soundset contains the pawn's voice
 */
var DELSoundSetMediumPawn mySoundSet;

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
<<<<<<< HEAD
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
			knockBack( 100.0 , location - DELHostileController( controller ).player.location );
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
		SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimtreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=12.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)

	health = 150
	healthMax = 150
	healthRegeneration = 4
	walkingSpeed = 80.0
	detectionRange = 512.0
	bCanBlock = true
	mySoundSet = none
}