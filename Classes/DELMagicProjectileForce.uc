class DELMagicProjectileForce extends DELMagicProjectile;

DefaultProperties
{
	ProjFlightTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Projectile'
	ProjExplosionTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Impact'
	MaxEffectDistance=7000.0

	Speed=1400
	MaxSpeed=5000
	AccelRate=3000.0

	Damage=26
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=26.0

	MyDamageType=class'DELDmgTypeMagical'
	LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	DrawScale=1.2
	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=1,Y=1.3,Z=1)
	ExplosionColor=(X=1,Y=1,Z=1);
}
