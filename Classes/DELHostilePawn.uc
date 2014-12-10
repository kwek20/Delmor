class DELHostilePawn extends DELNPCPawn abstract;
var bool bCanBeStunned;
var DELWeapon sword;

simulated event PostBeginPlay(){
	super.PostBeginPlay();
	AddDefaultInventory();
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	local int newDamage;
	newDamage = damage;
	if(DamageType == class'DELDmgTypeMelee'){
		newDamage = damage - (damage * physicalResistance);

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


function AddDefaultInventory()
{
	sword = Spawn(class'DELMeleeWeapon',,,self.Location);
	sword.GiveTo(Controller.Pawn);
	sword.bCanThrow = false; // don't allow default weapon to be thrown out
	Controller.ClientSwitchToBestWeapon();
}

/**
 * Say a line from the sound set. Only one sound can be played per 2 seconds.
 */
function say( String dialogue ){
	`log( ">>>>>>>>>>>>>>>>>>>> "$self$" said something ( "$dialogue$" )" );
	if ( mySoundSet != none && mySoundSet.bCanPlay ){
		mySoundSet.PlaySound( mySoundSet.getSound( dialogue ) );
		mySoundSet.bCanPlay = false;
		mySoundSet.setTimer( 0.5 , false , nameOf( mySoundSet.resetCanPlay ) );
	}
}

DefaultProperties
{
}
