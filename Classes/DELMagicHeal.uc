class DELMagicHeal extends DELMagic;

simulated state Charging{
	simulated function chargeTick(){
		super.chargeTick();

		if(spellCaster.health + totalDamage >= spellCaster.HealthMax){
			`log("no need for further charging");
			ClearTimer(NameOf(chargeTick));
		}
	}
	simulated function interrupt(){
		super.interrupt();
		spellCaster.ManaDrain(TotalManaCost);
		GoToState('Nothing');
		`log("interrupted");
	}
}




simulated function CustomFire(){
	spellCaster.ManaDrain(TotalManaCost);
	spellCaster.Heal(totalDamage);
}




DefaultProperties
{
	ChargeCost = 10;
	ChargeAdd = 20;
	manaCost = 10;
}
