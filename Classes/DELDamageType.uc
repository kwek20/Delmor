/**
 * custom damagetypes for DELMORRRRRRRRRRRRRRR
 * @author harmen wiersma
 */
class DELDamageType extends DamageType;
/**
 * spell is magical
 */
var bool bMagical;

/**
 * returns if the damagetype is magical
 * not needed anymore
 * @return isMagical
 */
simulated function bool isMagical(){
	return bMagical;
}

DefaultProperties
{
}
