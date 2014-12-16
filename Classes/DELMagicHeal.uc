/**
 * the heal spell
 * @author Harmen Wiersma
 */
class DELMagicHeal extends DELMagic;

/**
 * new Charging state
 */
simulated state Charging{
	/**
	 * chargetick for heal spell
	 * checks if spell doesn't do more heal then health missing
	 */
	simulated function chargeTick(){
		super.chargeTick();
		if(spellCaster.health + totalDamage >= spellCaster.HealthMax){
			ClearTimer(NameOf(chargeTick));
			`log("stop timerrrrrr");
		}
		consumeMana(ChargeAdd);
	}
	/**
	 * interrupts during spellcasting
	 */
	simulated function interrupt(){
		super.interrupt();
		GoToState('Nothing');
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
 * new customfire espacially for healing
 */
simulated function CustomFire(){
	//consumeMana();
	spellCaster.Heal(totalDamage);
}

DefaultProperties
{
	magicName="Heal"
	bCanCharge=true
	ChargeTime = 0.5
	ChargeCost = 1;
	ChargeAdd = 5;
	manaCost = 10;
	damage = 20;
	IconTexture = Texture2D'DelmorHud.healing_spell'
}
