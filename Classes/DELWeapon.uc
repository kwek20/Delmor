/**
 * Weapon to be used in Delmor.
 * @author Harmen Wiersma
 * 
 * EDIT: set bCanThrow to false in defaultProperties so that you won't have to
 * do that when assigning the weapon to a pawn.
 */
class DELWeapon extends UDKWeapon;
/**
 * Minimal damage to deal on hit.
 * Damage dealt will be between DamageMin.
 */
var int damageMin;
/**
 * Maximum damage to deal on hit (Except for Criticals or damage bonusses).
 * Damage dealt will be between DamageMin.
 */
var int damageMax;
/**
 * Critical Strike chance. will be done in full percentages, standard 5 percent
 */
var float criticalHitChance;
/**
 * multiplier that is added to the danage when a crit hits, standard 4
 */
var float criticalDamageMultiplier;

/**
 * Made empty to prevent weapon dropping.
 */
function DropFrom(vector StartLocation, vector StartVelocity){
}

/**
 * default setting to all weapons
 */
DefaultProperties
{
	criticalHitChance = 5;
	criticalDamageMultiplier = 4;
	bCanThrow = false
	bDropOnDeath = false
}
