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
		knockBack( 200.0 , location - DELHostileController( controller ).player.location );
	}
}


defaultproperties
{
	ControllerClass=class'DELEasyMonsterController'
	magicResistance = 1.0
	GroundSpeed = 105.0
	meleeRange = 50.0
	bCanBlock = true
}