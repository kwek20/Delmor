class DELMagicParalyze extends DELMagic;

/**
 * needed not much stuff for this one
 */
simulated function CustomFire(){
	super.CustomFire();
	consumeMana(TotalManaCost);
}



DefaultProperties
{
	magicName="paralyze"
	//spell = class'UTProj_Rocket'
	spell = class'DELMagicProjectileStun'
	bCanCharge = false
	manaCost = 10;
	damage= 10;
	IconTexture = Texture2D'DelmorHud.freeze_spell'
}
