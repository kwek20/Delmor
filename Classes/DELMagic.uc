class DELMagic extends DELWeapon;
//var array<DELMagicProjectile> spells;
var Array< class<UTProjectile> > spells;
var int ActiveAbilityNumber;


/**
 * shoots the magic
 */
simulated function shoot(){
	CustomFire();
}

simulated function int getMaxSpells(){
	return spells.Length;
}

simulated function switchMagic(int AbilityNumber){
	`log("ability:" $ AbilityNumber);
	ActiveAbilityNumber = AbilityNumber-1;
	`log("ellllllllllllllllllllllllllllllllllllo active ability:");
	`log(ActiveAbilityNumber);
}


/**
 * gets the in-world position of the DualWeaponPoint of the holder
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

function class<UTProjectile> getMagic(){
	return spells[ActiveAbilityNumber];
}


simulated state WeaponFiring{

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
