class DELMagicForce extends DELMagic;



simulated function CustomFire(){
	super.CustomFire();
	consumeMana();
}




DefaultProperties
{
	magicName="force"
	spell = class'UTProj_LinkPlasma'
	bCanCharge = true
	ChargeCost = 10;
	ChargeAdd = 20;
	manaCost = 10;
}
