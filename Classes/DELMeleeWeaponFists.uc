class DELMeleeWeaponFists extends DELMeleeWeapon;

var() const name offHandHiltSocketName, offHandTipSocketName;

simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName ){
    //simply overriding shit, nothing else
}

simulated event SetPosition(UDKPawn Holder){
//woohoo another override
}

simulated function TraceSwing(){
	local Vector SwordTip2, SwordHilt2;
	local Actor HitActor;
	local Vector HitLoc, HitNorm, Momentum;
	local int DamageAmount;
	super.TraceSwing();

	SwordTip2 = GetSwordSocketLocation(offHandTipSocketName);
	SwordHilt2 = GetSwordSocketLocation(offHandHiltSocketName);

	foreach TraceActors(class'Actor', HitActor, HitLoc, HitNorm, SwordTip2, SwordHilt2){
		if (HitActor != self && AddToSwingHitActors(HitActor)){
			HitActor.TakeDamage(DamageAmount, Instigator.Controller, HitLoc, Momentum, dmgType);
			//PlaySound(SwordClank);
		}
	}
}

simulated function Vector GetSwordSocketLocation(Name SocketName){
	local Vector SocketLocation;
	local Rotator SwordRotation;
	local SkeletalMeshComponent SMC;

	SMC = DELPawn(owner).Mesh;


	if (SMC != none && SMC.GetSocketByName(SocketName) != none){
		SMC.GetSocketWorldLocationAndRotation(SocketName, SocketLocation, SwordRotation);
	}
	return SocketLocation;
}




DefaultProperties
{
	animname1 = 'Lucian_slash1'
	animname2 = 'Lucian_slash1'
	animname3 = 'Lucian_slash1'
	swordHiltSocketName = R_wrist
	swordTipSocketName = R_nail
	offHandHiltSocketName = L_wrist
	offHandTipSocketName = L_nail
	critChance = 0;
}
