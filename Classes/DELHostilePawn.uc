class DELHostilePawn extends DELNPCPawn abstract;
var bool bCanBeStunned;

simulated event PostBeginPlay(){
	super.PostBeginPlay();
	AddDefaultInventory();
}

/**
 * Modified for the magic damage.
 * Will also play a pain sound when hit.
 */
event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	local int newDamage;
	`log("damage: "$damage);
	newDamage = damage;
	if(DamageType == class'DELDmgTypeMelee'){
		newDamage = damage - (damage * physicalResistance);

		//Play hit sound
		say( "TakeDamage" );
	} else if(DamageType == class'DELDmgTypeMagical') {
		newDamage = damage - (damage * magicResistance);

	} else if(DamageType == class'DELDmgTypeStun'){
		if(bCanBeStunned == false){
			return;
		} else {
			//stun
		}
	}
	super.TakeDamage(newDamage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}

/**
 * Stub to play a blocking sound.
 */
function playBlockingSound(){
}

/**
 * Ends the stun.
 */
function endStun(){
	`log( "***************************" );
	`log( "###########################" );
	`log( ">>>>>>>>>>>>>>>>>> END STUN" );
	`log( "###########################" );
	`log( "***************************" );
	controller.goToState( 'Attack' );
}

/**
 * Blocking state.
 * While in the blocking state the pawn should get no damage from melee attacks.
 */
state Blocking{

	/**
	 * Overridden so that the pawn take no damage.
	 */
	event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
	class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
		if(DamageType == class'DELDmgTypeMelee'){
			playBlockingSound();
		}
	}
}

DefaultProperties
{
}
