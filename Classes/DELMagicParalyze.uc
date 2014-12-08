class DELMagicParalyze extends DELMagic;

simulated function CustomFire(){
	super.CustomFire();
	consumeMana();
}



DefaultProperties
{
	magicName="paralyze"
	//spell = class'UTProj_Rocket'
	spell = class'DELMagicProjectileStun'
	bCanCharge = false
	manaCost = 10;
	damage= 10;
}
