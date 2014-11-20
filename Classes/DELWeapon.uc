/**
 * Weapon to be used in Delmor.
 * @author Anders Egberts
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
var int DamageMax;
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

/**
 * Get random damage between the min and max damage.
 */
function int GetDamage(){
	local int Damage , Random;
	Random = DamageMax - DamageMin;
	Damage = DamageMin + rand( Random );

	return Damage;
}

DefaultProperties
{
	DamageMin=40
	DamageMax=60
	CriticalStrikeChance=0.0
	Range=100
	AttackSpeed=1.0
}
