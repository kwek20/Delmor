class DELMagicProjectileStun extends DELMagicProjectile;


defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Particlepackage.Particles.PS_ice_Small'
	ProjExplosionTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
	MaxEffectDistance=7000.0

	Speed=200
	MaxSpeed=1000
	AccelRate=300.0

	Damage=26
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=26.0

	MyDamageType=class'DELDmgTypeStun'
	LifeSpan=5.0
	NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	DrawScale=0.3
	AmbientSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Travel_Cue'
	ExplosionSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Impact_Cue'
	ColorLevel=(X=1,Y=1.3,Z=1)
	ExplosionColor=(X=1,Y=1,Z=1);
}
