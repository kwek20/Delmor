/**
 * Weapon to be used in Delmor.
 * @author Harmen Wiersma
 */
class DELWeapon extends Weapon;
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
 * Critical Strike chance.
 */
var float criticalStrikeChance;
/**
 * multiplier that is added to the danage when a crit hits
 */
var float criticalDamageMultiplier;

/**
 * default setting to all weapons
 */
DefaultProperties
{
	criticalStrikeChance = 0.05;
	criticalDamageMultiplier = 5;
}
