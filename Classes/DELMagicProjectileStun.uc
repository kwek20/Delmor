/**
 * class for the stun spell
 * no custom functions as there doesn't need to be any
 * only sets some default properties
 * @author the amazing harmen
 */
class DELMagicProjectileStun extends DELMagicProjectile;


defaultproperties
{
	ProjFlightTemplate=ParticleSystem'Particlepackage.Particles.PS_ice_Small'
	ProjExplosionTemplate=ParticleSystem'Particlepackage.Particles.PS_Ice_impact'
	MaxEffectDistance=7000.0
	Speed=500
	MaxSpeed=2000
	AccelRate=1000.0

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
