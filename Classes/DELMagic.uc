/**
 * superclass of each magic
 * @author Harmen Wiersma
 */
class DELMagic extends DELWeapon;

/**
 * projectile shot when using magic
 */
var class<UDKProjectile> spell;

var name ChargeAnim, CastAnim, InitAnim;


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

var name MagicPointName;

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


/**
 * the total size the projectile is
 */
var float ProjectileSizeTotal;

/**
 * the startsize of a projectile
 */
var float ProjectileSize;

/**
 * maximum size of a projectile
 */
var() const float maxProjectileSize;

/**
 * increase of projectilesize for each iteration
 */
var float ProjectileSizeIncrease;

/**
 * texture of the icon in the quick item bar
 */
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
		spellcaster.SwingAnim.PlayCustomAnim('lucian_MagicCharge', 1.0,,,true);
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
		spellcaster.SwingAnim.StopCustomAnim(0.5);
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
	spellcaster.SwingAnim.PlayCustomAnim('lucian_MagicCast', 1.0);
	if(ManaCost > spellCaster.mana){
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
 * @param localmanacost amount of mana that needs to be costumed
 */
simulated function consumeMana(int localmanaCost){
	spellCaster.ManaDrain(ManaCost);
}

/**
 * shoots the spell
 */
simulated function shoot(){
	spellcaster.SwingAnim.PlayCustomAnim('lucian_MagicCast', 1.0);
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
        socket = compo.GetSocketByName(MagicPointName);
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

		//gets the location and gets the direction
		Spawnlocation = GetSocketPosition(instigator);
		AimDir = Vector(Instigator.GetAdjustedAimFor( Self, Spawnlocation));

		
		// Spawns a projectile and gives it a direction
		SpawnedProjectile = Spawn(getSpell() ,self,, Spawnlocation);
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe ){
			
			SpawnedProjectile.Init(AimDir);
		}
	}
}

/**
 * gets the class of the projectile that will be shot
 * @return the udkprojectile class of the spell
 */
simulated function class<UDKProjectile> getSpell(){
	return spell;
}




DefaultProperties
{
	projectileSize = 0.1
	MagicPointName = "MagicPoint"
	bCanCharge = false
	WeaponFireTypes(0)=EWFT_Custom
	spell = class'UTProj_Grenade'
	iconTexture = Texture2D'UDKHUD.cursor_png'
	ChargeTime = 0.1;
}
