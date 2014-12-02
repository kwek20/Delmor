class DELMagic extends DELWeapon;
/**
 * list of spells available to magician
 */
//var array<DELMagicProjectile> spells;
var Array< class<UTProjectile> > spells;
/**
 * location of active ability within spell list
 */
var int ActiveAbilityNumber;


/**
 * starts the shooting
 * in case of a chargeable spell, the charging will be initiated
 */
simulated function FireStart(){
	//super.StartFire(FireModeNum);
	if(ActiveAbilityNumber != 0){
		shoot();
	}else{
		shoot();
	}
	shoot();
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
function class<UTProjectile> getMagic(){
	return spells[ActiveAbilityNumber];
}

/**
 * checks if you are able to use magic.
 * if you are it will magic
 */
simulated function CustomFire(){
	local vector		StartTrace, RealStartLoc, AimDir, Direction;
	local Projectile	SpawnedProjectile;

	Direction.X = 0;
	Direction.Y = 0;
	Direction.Z = 0;

	if( Role == ROLE_Authority ){
		// This is where we would start an instant trace. (what CalcWeaponFire uses)
		StartTrace = GetSocketPosition(instigator);

		AimDir = Vector(Instigator.GetAdjustedAimFor( Self, StartTrace));

		// this is the location where the projectile is spawned.
		RealStartLoc = GetPhysicalFireStartLoc(AimDir);
		
		// Spawn projectile
		SpawnedProjectile = Spawn(getMagic(),self,, StartTrace);
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe ){
			SpawnedProjectile.Init(AimDir);
			`log(instigator.GetViewRotation());
		}
	}
}


DefaultProperties
{
	WeaponFireTypes(0)=EWFT_Custom
	spells[0] =class'UTProj_LinkPlasma'
	spells[1] =class'UTProj_Rocket'
	spells[2] =class'UTProj_Grenade'
	ActiveAbilityNumber = 0;
}
