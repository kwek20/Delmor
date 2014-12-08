class DELMagicProjectileStun extends DELMagicProjectile;


defaultproperties
{
	ProjFlightTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketTrail'
	ProjExplosionTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
	MaxEffectDistance=7000.0

	Speed=1400
	MaxSpeed=5000
	AccelRate=3000.0

	Damage=26
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=26.0

	MyDamageType=class'DELDmgTypeStun'
	LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	DrawScale=1.2
	AmbientSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Travel_Cue'
	ExplosionSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Impact_Cue'
	ColorLevel=(X=1,Y=1.3,Z=1)
	ExplosionColor=(X=1,Y=1,Z=1);
}
