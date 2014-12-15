class DELMagicForce extends DELMagic;
var Projectile chargingProjectile;
var vector locationOfProjectile;

simulated state Charging{
	simulated event beginstate(Name NextStateName){
		super.beginstate(NextStateName);
		locationOfProjectile = GetSocketPosition(spellcaster);
		chargingProjectile = Spawn(getSpell() ,self,, locationOfProjectile);
		chargingProjectile.SetDrawScale(projectileSize);
		ProjectileSizeTotal = projectileSize;
		consumeMana(manaCost);
	}
	simulated event Tick(float DeltaTime){
		super.Tick(DeltaTime);
		locationOfProjectile = GetSocketPosition(spellcaster);
		chargingProjectile.SetLocation(locationOfProjectile);
		chargingProjectile.LifeSpan += 0.4;
	}

	simulated function ChargeTick(){
		super.chargeTick();
		consumeMana(ChargeAdd);
		TotalManaCost = 0;
		if(ProjectileSizeTotal <= maxProjectileSize){
			ProjectileSizeTotal += projectileSizeIncrease;
		}
		chargingProjectile.SetDrawScale(ProjectileSizeTotal);
	}


}



simulated function shoot(){
	super.shoot();
	//consumeMana(TotalManaCost);
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
	projectileSize = 0.1
	projectileSizeIncrease = 0.01
	maxProjectileSize = 0.4

	spell = class'DELMagicProjectileForce'
	bCanCharge = true
	ChargeCost = 5;
	ChargeAdd = 8;
	manaCost = 1;
	damage = 10;
	IconTexture = Texture2D'EditorResources.LookTarget'
}
