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

/**
 * Overridden so that the pawn take no damage from melee-attacks.
 * However when hit by a force attack, the pawn will be knocked back and the block will end.
 */
event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

	//Block randomly
	if ( bCanBlock && rand( 3 ) == 1 ){
		`log( "Start blocking" );
		startBlocking();
		setTimer( 1.0 , false , 'stopBlocking' );
	}
}

state Blocking{
	/**
	 * Overridden so that the pawn take no damage from melee-attacks.
	 * However when hit by a force attack, the pawn will be knocked back and the block will end.
	 */
	event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
	class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){

		//When hit by a melee attack the block will be broken and the pawn will be knocked back.
		switch( DamageType ){
		case class'DELDmgTypeMelee':
			playBlockingSound();
			breakBlock();
			break;
		}
	}

	/**
	 * Called when hit a by player's melee attack.
	 * When the block is broken the pawn will not be able to block for five seconds.
	 */
	function breakBlock(){
		stopBlocking();
		bCanBlock = false;
		setTimer( 5.0 , false , 'resetCanBlock' );
		knockBack( 50.0 , location - DELHostileController( controller ).player.location );
	}
}

defaultproperties
{	
	//Collision cylinder
	Begin Object Name=CollisionCylinder
		CollisionRadius = 32.0;
		CollisionHeight = +44.0;
	end object

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
	magicResistance = 0.8
	groundSpeed = 380.0
	meleeRange = 75.0
	bCanBlock = true

	swordClass = class'DELMeleeWeaponFists'

	animname[ 0 ] = ratman_attack1
	animname[ 1 ] = ratman_attack2
	animname[ 2 ] = ratman_jumpattack
	deathAnimName = ratman_death
	knockBackAnimName = ratman_knockback
}