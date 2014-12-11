class DELMagicForce extends DELMagic;
var Projectile chargingProjectile;
var vector locationOfProjectile;

simulated state Charging{
	simulated event beginstate(Name NextStateName){
		super.beginstate(NextStateName);
		locationOfProjectile = GetSocketPosition(instigator);
		chargingProjectile = Spawn(getSpell() ,self,, locationOfProjectile);
		ProjectileSizeTotal = projectileSize;
	}
	simulated event Tick(float DeltaTime){
		super.Tick(DeltaTime);
		locationOfProjectile = GetSocketPosition(instigator);
		chargingProjectile.SetLocation(locationOfProjectile);
		chargingProjectile.LifeSpan += 0.4;
	}

	simulated function ChargeTick(){
		super.chargeTick();
		ProjectileSizeTotal += projectileSizeIncrease;
		chargingProjectile.SetDrawScale(ProjectileSizeTotal);
	}


}



simulated function shoot(){
	super.shoot();
	consumeMana();
}


simulated function CustomFire(){
	local vector AimDir;

	if( Role == ROLE_Authority ){

		AimDir = Vector(Instigator.GetAdjustedAimFor( Self, locationOfProjectile));

		
		if( chargingProjectile != None && !chargingProjectile.bDeleteMe ){
			chargingProjectile.Init(AimDir);
		}
	}
}

DefaultProperties
{
	projectileSize = 1.0
	projectileSizeIncrease = 0.1
	magicName="force"
	spell = class'DELMagicProjectileForce'
	bCanCharge = true
	ChargeCost = 1;
	ChargeAdd = 2;
	manaCost = 10;
	damage = 10;
	IconTexture = Texture2D'EditorResources.LookTarget'
}
