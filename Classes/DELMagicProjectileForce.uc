class DELMagicProjectileForce extends DELMagicProjectile;
var bool flying;
var ParticleSystem ProjChargeTemplate;

simulated function init(vector Direction){
	super.Init(Direction);
	DetachComponent(ProjEffects);
	flying = true;
	SpawnFlightEffects();
}

simulated function SpawnFlightEffects(){
	if(flying){
		Super.SpawnFlightEffects();
	} else if (!Flying){
		ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjChargeTemplate);
		ProjEffects.SetAbsolute(false, false, false);
		ProjEffects.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
		ProjEffects.OnSystemFinished = MyOnParticleSystemFinished;
		ProjEffects.bUpdateComponentInTick = true;
		AttachComponent(ProjEffects);
	}
}


DefaultProperties
{
	ProjFlightTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Projectile'
	ProjChargeTemplate = ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Projectile'
	ProjExplosionTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Impact'
	MaxEffectDistance=7000.0
	Flying = false

	Speed=1400
	MaxSpeed=5000
	AccelRate=3000.0

	Damage=20
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=26.0

	MyDamageType=class'DELDmgTypeMagical'
	LifeSpan=3.0
	NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	DrawScale=1.2
	//AmbientSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Travel_Cue'
	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ColorLevel=(X=1,Y=1.3,Z=1)
	ExplosionColor=(X=1,Y=1,Z=1);
}
