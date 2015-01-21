/**
 * the force spell
 * @author Harmen Wiersma
 */
class DELMagicForce extends DELMagic;
/**
 * the projectile in charging state
 */
var Projectile chargingProjectile;
/**
 * the location of the projectile during charging
 */
var vector locationOfProjectile;

/**
 * costum made charging state for the force spell
 */
simulated state Charging{
	/**
	 * new beginstate also initiates the projectile in the hand and depletes the initial manacost
	 */
	simulated event beginstate(Name NextStateName){
		super.beginstate(NextStateName);
		locationOfProjectile = GetSocketPosition(spellcaster);
		chargingProjectile = Spawn(getSpell() ,self,, locationOfProjectile);
		chargingProjectile.SetDrawScale(projectileSize);
		ProjectileSizeTotal = projectileSize;
		consumeMana(manaCost);
		
	}
	/**
	 * extended tick that changes the position of the projectile and adds to the lifespan of it
	 */
	simulated event Tick(float DeltaTime){
		super.Tick(DeltaTime);
		locationOfProjectile = GetSocketPosition(spellcaster);
		chargingProjectile.SetLocation(locationOfProjectile);
		chargingProjectile.LifeSpan += 0.4;
	}

	/**
	 * the charge iteration of forcespell
	 */
	simulated function ChargeTick(){
		super.chargeTick();
		consumeMana(ChargeAdd);
		TotalManaCost = 0;
		if(ProjectileSizeTotal <= maxProjectileSize){
			//for when the projectile gets too big. it doesn't need to get any bigger
			ProjectileSizeTotal += projectileSizeIncrease;
		}
		chargingProjectile.SetDrawScale(ProjectileSizeTotal);
		
	}
}

/**
 * changed custom fire a bit to make sure it doesn't spawn a new projectile
 */
simulated function CustomFire(){
	local vector AimDir;

	if( Role == ROLE_Authority ){

		AimDir = Vector(Instigator.GetAdjustedAimFor( Self, locationOfProjectile));
		//AimDir = Vector(Spellcaster.Rotation);
		if( chargingProjectile != None && !chargingProjectile.bDeleteMe ){
			chargingProjectile.damage = totalDamage;
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
	ChargeAdd = 6;
	damage = 10;
	manaCost = 1;
	IconTexture = Texture2D'DelmorHud.damage_spell'
}
