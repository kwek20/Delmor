class DELMagicProjectileHeal extends DELMagicProjectile;



DefaultProperties
{
	ProjFlightTemplate = ParticleSystem'Particlepackage.Heal.Healcircle_par'

	MaxEffectDistance=7000.0
	Flying = false

	Speed=0.0
	MaxSpeed=0.0
	AccelRate=0.0
	
	
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=0.0

	LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	bCollideWhenPlacing = false
	DrawScale=1.0
	//AmbientSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Travel_Cue'
	//ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	//ColorLevel=(X=1,Y=1.3,Z=1)
	//ExplosionColor=(X=1,Y=1,Z=1);
}
