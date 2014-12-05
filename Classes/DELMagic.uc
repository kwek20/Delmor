class DELMagic extends DELWeapon;
/**
 * list of spells available to magician
 */
var array< class<DElMagic> > spells;
/**
 * location of active ability within spell list
 */
var int ActiveAbilityNumber;

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
var DELPawn spellCaster;

/**
 * the cost that is added every iteration
 */
var int ChargeCost;

/**
 * the ammount that is added every charge iteration
 */
var int ChargeAdd;

/**
 * the state where a spell charges
 */
simulated state charging{
	/**
	 * beginning of the state
	 */
	simulated event beginstate(Name NextStateName){
		SetTimer(1.0,bCanCharge, NameOf(chargeTick));
		TotalManaCost = ManaCost;
		TotalDamage = Damage;
		`log("start charge");
		`log("player has now " $ spellCaster.Health $" health");
		`log("player has now " $ spellCaster.Mana $" mana");
	}

	/**
	 * a function that is called every iteration
	 */
	simulated function chargeTick(){
		totalManaCost+= chargeCost;
		totalDamage+= ChargeAdd;
		`log("manacost:" $ totalManaCost);
		`log("ammount of heal/damage:" $ totalDamage);
		if(spellCaster.mana - (totalManaCost+chargeCost) <= 0){
			`log("max chargetime reached");
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
		`log("charge Complete");

	}
}

/**
 * when there is no magic being called
 */
simulated state Nothing{
	simulated event beginstate(Name NextStateName){
		`log("kinda like a idle but my own");
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
	spellCaster = DELPawn(instigator);
	spellCaster.Health = 20;
	//super.StartFire(FireModeNum);
	if(bCanCharge){
		GoToState('Charging');
	} else {
		shoot();
	}
}

/**
 * is called when the key is released
 */
simulated function FireStop(){
	GoToState('Nothing');
}

/**
 * consuming the mana needed for casting the spell
 * @param spell the spel that is cast
 * @param chargeTime in case the spell is charged, the charge time will be added to the cost
 */
simulated function consumeMana(DELMagicProjectile spell, optional int chargeTime){
	spell.getCost();
}

/**
 * shoots the spell
 */
simulated function shoot(){
	CustomFire();
}

/**
 * gets the amount of spells the player knows
 */
simulated function int getMaxSpells(){
	return spells.Length;
}

/**
 * changes the spell that will be used
 */
simulated function switchMagic(int AbilityNumber){
	ActiveAbilityNumber = AbilityNumber-1;
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
 * gets the spell
 */
function class<DELMagic> getMagic(){
	`log(spells[ActiveAbilityNumber]);
	return spells[ActiveAbilityNumber];
}

/**
 * checks if you are able to use magic.
 * if you are it will magic
 */
simulated function CustomFire(){
	local vector		Spawnlocation,AimDir;
	local UTProj_LinkPlasma	SpawnedProjectile;

	if( Role == ROLE_Authority ){

		Spawnlocation = GetSocketPosition(instigator);
		AimDir = Vector(Instigator.GetAdjustedAimFor( Self, Spawnlocation));

		
		// Spawn projectile
		SpawnedProjectile = Spawn(class'UTProj_LinkPlasma' ,self,, Spawnlocation);
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe ){
			SpawnedProjectile.Init(AimDir);
			`log("shoot");
		}
	}
}


DefaultProperties
{
	bCanCharge = true
	newColor = false
	newColorlevel = (X=1,Y=1,Z=2);
	WeaponFireTypes(0)=EWFT_Custom
	/*spells[0] = class'UTProj_LinkPlasma'
	spells[1] = class'UTProj_Rocket'
	spells[2] = class'UTProj_Grenade'
	spells[3] = class'UTProj_LoadedRocket'
*/	
	spells[0] = class'DELMagicHeal'
	ActiveAbilityNumber = 0;
}
