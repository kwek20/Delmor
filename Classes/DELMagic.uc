class DELMagic extends DELWeapon;
/**
 * list of spells available to magician
 */
var array< class<Projectile> > spells;
/**
 * location of active ability within spell list
 */
var int ActiveAbilityNumber;

var vector newColorlevel;

var bool newColor;

simulated state charging{
	simulated event beginstate(Name NextStateName){
		SetTimer(3.0,false, NameOf(setColor));
		`log("start charge");
	}

	function setColor(){
		newColor = true;
		`log("charge complete");
	}

	simulated event endstate(Name NextStateName){
		shoot();
	}
}

simulated state Nothing{
	simulated event beginstate(Name NextStateName){
		`log("kinda like a idle but my own");
	}
}



/**
 * starts the shooting
 * in case of a chargeable spell, the charging will be initiated
 */
simulated function FireStart(){
	//super.StartFire(FireModeNum);
	if(ActiveAbilityNumber == 0){
		GoToState('Charging');
	} else {
		shoot();
	}
}

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
function class<Projectile> getMagic(){
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
		if(newColor){
			SpawnedProjectile.ColorLevel = newColorlevel;
			SpawnedProjectile.DamageRadius = 20000;
			SpawnedProjectile.Damage = 2000000;
			`log("colorChanged");
		}
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe ){
			//SpawnedProjectile.Init(AimDir);
			`log("shoot");
		}
	}
}


DefaultProperties
{
	newColor = false
	newColorlevel = (X=1,Y=1,Z=2);
	WeaponFireTypes(0)=EWFT_Custom
	spells[0] = class'UTProj_LinkPlasma'
	spells[1] = class'UTProj_Rocket'
	spells[2] = class'UTProj_Grenade'
	spells[3] = class'UTProj_LoadedRocket'
	ActiveAbilityNumber = 0;
}
