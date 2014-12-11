class DELMagicHeal extends DELMagic;

simulated state Charging{
	simulated function chargeTick(){
		super.chargeTick();

		if(spellCaster.health + totalDamage >= spellCaster.HealthMax){
			ClearTimer(NameOf(chargeTick));
		}
	}
	simulated function interrupt(){
		super.interrupt();
		spellCaster.ManaDrain(TotalManaCost);
		GoToState('Nothing');
	}
}




simulated function CustomFire(){
	consumeMana();
	spellCaster.Heal(totalDamage);
}





DefaultProperties
{
	magicName="Heal"
	bCanCharge=true
	ChargeCost = 1;
	ChargeAdd = 2;
	manaCost = 10;
	damage = 20;
	IconTexture = Texture2D'EditorResources.VolumePath'
}
