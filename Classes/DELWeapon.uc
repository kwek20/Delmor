/**
 * Weapon to be used in Delmor.
 * @author Harmen Wiersma
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
 * default setting to all weapons
 */
DefaultProperties
{
	criticalHitChance = 5;
	criticalDamageMultiplier = 4;
	bCanThrow = false
}
