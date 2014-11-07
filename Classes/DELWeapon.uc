/**
 * Weapon to be used in Delmor.
 */
class DELWeapon extends UTWeapon;
/**
 * Minimal damage to deal on hit.
 * Damage dealt will be between DamageMin.
 */
var int DamageMin;
/**
 * Maximum damage to deal on hit (Except for Criticals or damage bonusses).
 * Damage dealt will be between DamageMin.
 */
var int DamageMin;
/**
 * Critical Strike chance.
 */
var float CriticalStrikeChance;
/**
 * Effective range.
 * Swords also have an effective range (Longer swords have a wider range/Attack sweep).
 */
var float Range;
/**
 * Interval at which the weapons can be used.
 */
var float AttackSpeed;


DefaultProperties
{
}
