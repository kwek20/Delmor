/**
 * the heal spell
 * @author Harmen Wiersma
 */
class DELMagicHeal extends DELMagic;

/**
 * the projectile in charging state
 */
var Projectile chargingProjectile;
/**
 * the location of the projectile during charging
 */
var vector locationOfProjectile;


/**
 * new Charging state
 */
simulated state Charging{
	local float initGroundSpeed;

	simulated event beginstate(Name NextStateName){
		initGroundSpeed = spellCaster.GroundSpeed;

		if(spellCaster.health + Damage >= spellCaster.HealthMax){
			gotoState('nothing');
			return;
		}
		super.beginstate(NextStateName);
		locationOfProjectile = GetSocketPosition(spellcaster);
		chargingProjectile = Spawn(getSpell() ,self,, locationOfProjectile);
		spellCaster.GroundSpeed = 0;
	}
	/**
	 * chargetick for heal spell
	 * checks if spell doesn't do more heal then health missing
	 */
	simulated function chargeTick(){
		super.chargeTick();
		if(spellCaster.health + totalDamage >= spellCaster.HealthMax){
			//when the health you get is higher than the health you need
			ClearTimer(NameOf(chargeTick));
		}
		consumeMana(ChargeAdd);
	}
	simulated event Tick(float DeltaTime){
		local bool awesome;
		super.Tick(DeltaTime);
		locationOfProjectile = GetSocketPosition(spellcaster);
		awesome = chargingProjectile.SetLocation(locationOfProjectile);
		chargingProjectile.LifeSpan += 0.4;
		
	}
	/**
	 * interrupts during spellcasting
	 */
	simulated function interrupt(){
		super.interrupt();
		GoToState('Nothing');
	}

	simulated function endstate(name NextStateName){
		spellCaster.GroundSpeed = initGroundSpeed;
	}
}

/**
 * a new firestart especially for heal
 * 
 */
simulated function FireStart(){
	super.FireStart();
	if(spellCaster.health + Damage >= spellCaster.HealthMax){
		gotoState('nothing');
		return;
	}
	consumeMana(manaCost);
}
/**
 * makes the magic shine
 */
simulated function shoot(){
	spellcaster.SwingAnim.PlayCustomAnim('lucian_healCast', 1.0);
	//CustomFire();
	spellCaster.Heal(totalDamage);
}

DefaultProperties
{
	magicName="Heal"
	spell = class'DELMagicProjectileHeal'
	bCanCharge=true
	MagicPointName = "MagicPoint2"
	ChargeTime = 0.5
	ChargeCost = 1;
	ChargeAdd = 5;
	manaCost = 10;
	damage = 20;
	IconTexture = Texture2D'DelmorHud.healing_spell'
}
