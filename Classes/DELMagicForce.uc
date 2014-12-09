class DELMagicForce extends DELMagic;
var Projectile chargingProjectile;
var vector locationOfProjectile;

simulated state Charging{
	simulated event beginstate(Name NextStateName){
		super.beginstate(NextStateName);
		locationOfProjectile = GetSocketPosition(instigator);
		chargingProjectile = Spawn(getSpell() ,self,, locationOfProjectile);
	}
	simulated event Tick(float DeltaTime){
		super.Tick(DeltaTime);
		locationOfProjectile = GetSocketPosition(instigator);
		chargingProjectile.SetLocation(locationOfProjectile);
		chargingProjectile.LifeSpan += 0.4;
	}

	simulated function ChargeTick(){
		super.chargeTick();
		chargingProjectile.SetDrawScale(chargingProjectile.DrawScale + 0.5);
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
	magicName="force"
	spell = class'DELMagicProjectileForce'
	bCanCharge = true
	ChargeCost = 10;
	ChargeAdd = 20;
	manaCost = 10;
}
