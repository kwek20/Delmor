class DELMagicForce extends DELMagic;



simulated function CustomFire(){
	super.CustomFire();
	consumeMana();
	`log("manacost:" $ totalManaCost);
}




DefaultProperties
{
	magicName="force"
	spell = class'DELMagicProjectileForce'
	bCanCharge = true
	ChargeCost = 10;
	ChargeAdd = 20;
	manaCost = 10;
}
