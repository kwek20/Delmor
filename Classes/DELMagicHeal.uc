class DELMagicHeal extends DELMagic;

simulated state Charging{
	simulated function chargeTick(){
		super.chargeTick();
		if(spellCaster.health + totalDamage >= spellCaster.HealthMax){
			ClearTimer(NameOf(chargeTick));
			`log("stop timerrrrrr");
		}
		consumeMana(ChargeAdd);
	}
	simulated function interrupt(){
		super.interrupt();
		//spellCaster.ManaDrain(TotalManaCost);
		GoToState('Nothing');
	}
}

simulated function FireStart(){
	super.FireStart();
	if(spellCaster.health + Damage >= spellCaster.HealthMax){
		`log("why doth thou wanteth to heal thyself??");
		`log("thyne health is " $ spellCaster.Health);
		`log("the maximum thyne health caneth be is " $ spellCaster.HealthMax);
		`log("the strength of thyne spell is "$ damage);
		gotoState('nothing');
		return;
	}
	consumeMana(manaCost);
}

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
