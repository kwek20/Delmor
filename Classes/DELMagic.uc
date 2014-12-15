class DELMagic extends DELWeapon;

/**
 * projectile shot when using magic
 */
var class<UDKProjectile> spell;

/**
 * cost of the spell without the charging
 * may not ba changed
 */
var int ManaCost;

/**
 * manaCost with chargecosts added
 */
var int TotalManaCost;

/**
 * standard ammount of damage/heal the spell will do
 */
var int Damage;

/**
 * ammount of damage/heal with the charge added
 */
var int TotalDamage;

/**
 * if the spell can charge
 */
var bool bCanCharge;

/**
 * the user of the spell
 */
var DELPlayer spellCaster;

/**
 * the cost that is added every iteration
 */
var int ChargeCost;

/**
 * the ammount that is added every charge iteration
 */
var int ChargeAdd;

var float ProjectileSizeTotal;

var float ProjectileSize;

var() const float maxProjectileSize;

var float ProjectileSizeIncrease;

var Texture2D IconTexture;

/**
 * Time in secconds for every iteration
 */
var float ChargeTime;

/**
 * the state where a spell charges
 */

simulated state charging{
	/**
	 * beginning of the state
	 */
	simulated event beginstate(Name NextStateName){
		SetTimer(ChargeTime,bCanCharge, NameOf(chargeTick));
	}

	/**
	 * a function that is called every iteration
	 */
	simulated function chargeTick(){
		totalManaCost+= chargeCost;
		totalDamage+= ChargeAdd;
		if(spellCaster.mana - (totalManaCost+chargeCost) <= 0){
			ClearTimer(NameOf(chargeTick));
		}
	}

	/**
	 * is called when key is released and the spell is charging
	 */
	simulated function FireStop(){
		super.FireStop();
		shoot();
	}

	/**
	 * ending of the state
	 */
	simulated event endstate(Name NextStateName){

	}
}

/**
 * when there is no magic being called
 */
simulated state Nothing{
	simulated event beginstate(Name NextStateName){
	}
}

/**
 * is called when the player takes damage, interrupts spells
 */
simulated function interrupt(){
	`log("spell interrupted if possible");
}


/**
 * starts the shooting
 * in case of a chargeable spell, the charging will be initiated
 */
simulated function FireStart(){
	spellCaster = DELPlayer(instigator);
	spellcaster.Grimoire.startCharge();
	if(ManaCost > spellCaster.mana){
		`log("you have not enough mana bitch");
		return;
	}

	if(bCanCharge){
		GoToState('Charging');
	} else {
		shoot();
	}
	TotalManaCost = ManaCost;
	TotalDamage = Damage;
}

/**
 * is called when the key is released
 */
simulated function FireStop(){
	spellcaster.Grimoire.stopCharge();
	GoToState('Nothing');
}

/**
 * consuming the mana needed for casting the spell
 * @param spell the spel that is cast
 * @param chargeTime in case the spell is charged, the charge time will be added to the cost
 */
simulated function consumeMana(){
	spellCaster.ManaDrain(TotalManaCost);
}

/**
 * shoots the spell
 */
simulated function shoot(){
	CustomFire();
}



/**
 * gets the in-world position of the DualWeaponPoint of the holder
 * @param holder holder of the weapon
 * @return returns the position of the socket
 */
simulated function Vector GetSocketPosition(Pawn Holder){
    local SkeletalMeshComponent compo;
    local SkeletalMeshSocket socket;
    local Vector FinalLocation;
 
    compo = Holder.Mesh;
    if (compo != none){
        socket = compo.GetSocketByName('MagicPoint');
        if (socket != none){
            FinalLocation = compo.GetBoneLocation(socket.BoneName);
			return FinalLocation;
        }
    } 
	return FinalLocation;
}



/**
 * checks if you are able to use magic.
 * if you are it will magic
 */
simulated function CustomFire(){
	local vector		Spawnlocation,AimDir;
	local UDKProjectile	SpawnedProjectile;

	if( Role == ROLE_Authority ){

		Spawnlocation = GetSocketPosition(instigator);
		AimDir = Vector(Instigator.GetAdjustedAimFor( Self, Spawnlocation));

		
		// Spawn projectile
		SpawnedProjectile = Spawn(getSpell() ,self,, Spawnlocation);
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe ){
			SpawnedProjectile.Init(AimDir);
		}
	}
}


simulated function class<UDKProjectile> getSpell(){
	return spell;
}




DefaultProperties
{
	projectileSize = 0.1
	bCanCharge = false
	WeaponFireTypes(0)=EWFT_Custom
	spell = class'UTProj_Grenade'
	iconTexture = Texture2D'UDKHUD.cursor_png'
	ChargeTime = 0.1;
}
