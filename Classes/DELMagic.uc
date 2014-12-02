class DELMagic extends DELWeapon;
var array<DELMagicProjectile> spells;


/**
 * gets the in-world position of the DualWeaponPoint of the holder
 */
simulated function Vector GetSocketPosition(Pawn Holder){
    local SkeletalMeshComponent compo;
    local SkeletalMeshSocket socket;
    local Vector FinalLocation;
 
    compo = Holder.Mesh;
    if (compo != none){
        socket = compo.GetSocketByName('DualWeaponPoint');
        if (socket != none){
            FinalLocation = compo.GetBoneLocation(socket.BoneName);
			return FinalLocation;
        }
    } 
	return FinalLocation;
}


simulated state WeaponFiring{

}




/**
 * checks if you are able to use magic.
 * if you are it will magic
 */
simulated function CustomFire(){
	local vector		StartTrace, RealStartLoc, AimDir;
	local Projectile	SpawnedProjectile;


	if( Role == ROLE_Authority ){
		// This is where we would start an instant trace. (what CalcWeaponFire uses)
		StartTrace = GetSocketPosition(instigator);

		AimDir = Vector(Instigator.GetAdjustedAimFor( Self, StartTrace));

		// this is the location where the projectile is spawned.
		RealStartLoc = GetPhysicalFireStartLoc(AimDir);

		
		// Spawn projectile
		SpawnedProjectile = Spawn(class'UTProj_LinkPowerPlasma',self,, RealStartLoc);
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe ){
			SpawnedProjectile.Init();
			`log(instigator.GetViewRotation());
		}
	}
}


DefaultProperties
{
	WeaponFireTypes(0)=EWFT_Custom
}
