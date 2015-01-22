/**
 * Sword used in Delmor
 * @author Harmen Wiersma
 */
class DELMeleeWeapon extends DELWeapon;
/**
 * the name of a socket in a mesh
 */
var() const name swordHiltSocketName,swordTipSocketName, handSocketName;
/**
 * actors hit in the swing
 */
var array<Actor> swingHitActors;
/**
 * the damagetype the weapon does
 */
var class<DamageType> dmgType;

var class<DamageType> currentDmgType;

var class<DamageType> critDmgType;
/**
 * name of the swing to be used with this weapon
 */
var name animname1,animname2,animname3;

/**
 * rename of ammo with a meleeweapon
 */
var array<int> swings;
/**
 * maximum amount of swings one can do in succesion
 */
var const int maxSwings;

var bool bSwinging;

/*
function StartFire(byte FireModeNum){
	`log("starrt fireeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
	if(bSwinging == true) {
		`log("return start fire");
		return;
	}
	super.StartFire(FireModeNum);
}*/


/**
 * is an abbreviation of the weaponFiring state
 */
simulated state Swinging extends WeaponFiring {
	simulated event beginState(name PreviousStateName){
		super.BeginState(previousStateName);
		
	}

	simulated event Tick(float DeltaTime){
		//trace in every tick while swinging
		super.Tick(DeltaTime);
		TraceSwing();
	}
	simulated event EndState(Name NextStateName){
		super.EndState(NextStateName);
		SetTimer(0.5, false, nameof(ResetSwings));
	}
}

/**
 * resets the swings you can do to the maximum amount
 */
function ResetSwings(){
	RestoreAmmo(MaxSwings);
}

/**
 * equipping the weapon
 */
simulated function TimeWeaponEquipping(){
    super.TimeWeaponEquipping();
    AttachWeaponTo( Instigator.Mesh,handSocketName );
}

/**
 * attaches the weapon to a socket on the owner
 * @param MeshCpnt mesh of the owner
 * @param SocketName name of the socket the weapon is attached to
 */
simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName ){
    MeshCpnt.AttachComponentToSocket(Mesh,SocketName);
}

/**
 * sets the position of the socket
 * @param holder holder of the weapon
 */
simulated event SetPosition(UDKPawn Holder){
    local SkeletalMeshComponent compo;
    local SkeletalMeshSocket socket;
    local Vector FinalLocation;
 
    compo = Holder.Mesh;
    if (compo != none){
        socket = compo.GetSocketByName(handSocketName);
        if (socket != none){
            FinalLocation = compo.GetBoneLocation(socket.BoneName);
        }
    }
    SetLocation(FinalLocation);
}

/**
 * traces the sword and damages any actors that touches the sword
 */
simulated function TraceSwing(){
	local DELHostilePawn HitActor;
	local Vector HitLoc, HitNorm, SwordTip, SwordHilt, Momentum;
	local int DamageAmount;

	SwordTip = GetSwordSocketLocation(SwordTipSocketName);
	SwordHilt = GetSwordSocketLocation(SwordHiltSocketName);
	//DamageAmount = FCeil(InstantHitDamage[CurrentFireMode]);
	DamageAmount = calculateDamage();


	foreach TraceActors(class'DELHostilePawn', HitActor, HitLoc, HitNorm, SwordTip, SwordHilt){
		if ( AddToSwingHitActors(HitActor) && !hitActor.IsInState( 'Dead' ) ){
			HitActor.TakeDamage(DamageAmount, Instigator.Controller, HitLoc, Momentum, currentDmgType);
			//PlaySound(SwordClank);
		}
	}
}

/**
 * checks if the hit actor can be added to the array of hit actors
 * also ads the actor to the array if it is possible
 * @param HitActor actor you want to add
 * @return whether the actor was added or not
 */
function bool AddToSwingHitActors(Actor HitActor){
	local int i;

	for (i = 0; i < SwingHitActors.Length; i++){
		if (SwingHitActors[i] == HitActor){
			return false;
		}
	}

	SwingHitActors.AddItem(HitActor);
	return true;
}

/**
 * gets the location of the socket an the sword
 * @param SocketName name of the socket 
 * @return the location of the socket
 */
simulated function Vector GetSwordSocketLocation(Name SocketName){
	local Vector SocketLocation;
	local Rotator SwordRotation;
	local SkeletalMeshComponent SMC;
	SMC = SkeletalMeshComponent(Mesh);


	if (SMC != none && SMC.GetSocketByName(SocketName) != none){
		SMC.GetSocketWorldLocationAndRotation(SocketName, SocketLocation, SwordRotation);
	}
	return SocketLocation;
}

/**
 * calculates the damage between the minimum and the maximum damage
 * also checks the crit hit chance and adds crit if possible
 * @return the damage that will be done
 */
simulated function int CalculateDamage(){
	local int damageRange, damage;
	currentDmgType = dmgType;
	damageRange = (damageMax - damageMin);
	damage = damageMin +Rand(damageRange);
	if (doesCrit()) damage = addCrit(damage);
	return damage;
}

/**
 * checks if the weapon crits or not
 * @return crits (false =no)
 */
simulated function bool doesCrit(){
	local int wheelOfFortune;
	wheelOfFortune = Rand(100);
	return wheelOfFortune<criticalHitChance;
}

/**
 * adds the crit to the damage
 * @param damage damage normally done
 * @return new crit damage
 */
simulated function int addCrit(int damage){
	currentDmgType = critDmgType;
	return damage * criticalDamageMultiplier;
}


/**
 * restores the ammo the a specific amount
 * @param amount the amount one wants to add
 * @param FireModeNum the firemode the ammo belongs to
 */
function RestoreAmmo(int Amount, optional byte FireModeNum){
	Swings[FireModeNum] = Min(Amount, MaxSwings);
}

/**
 * consumes the ammo
 * @param firemodenum the firemode used
 */
function ConsumeAmmo(byte FireModeNum){
	if (HasAmmo(FireModeNum)){
		Swings[FireModeNum]--;
	}
}
/**
 * checks if weapon has enough ammo to shoot something
 * @return wether weapon has enough ammo
 * @param Firemodenum the firemode the user wants to use
 * @param ammount needed to shoot
 */
simulated function bool HasAmmo(byte FireModeNum, optional int Ammount){
	return Swings[FireModeNum] > Ammount;
}

/**
 * abbreviation of the normal fireammunition
 * contains the swing animations
 */
simulated function FireAmmunition(){
	StopFire(CurrentFireMode);
	SwingHitActors.Remove(0, SwingHitActors.Length);
	if (HasAmmo(CurrentFireMode)){
		//bSwinging = true;
		if (MaxSwings - Swings[0] == 0) {
			DELPawn(Owner).SwingAnim.PlayCustomAnim(animname1, 1.f);
		} else if (MaxSwings - Swings[0] == 1){
			DELPawn(Owner).SwingAnim.PlayCustomAnim(animname2, 1.0);
		} else {
			DELPawn(Owner).SwingAnim.PlayCustomAnim(animname3, 1.0);
		}
		PlaySound( SoundCue'Delmor_sound.Weapon.sndc_sword_swing' );
		//bSwinging = false;
		super.FireAmmunition();
	}
}

DefaultProperties
{
	animname1 = Lucian_slash1
	animname2 = Lucian_slash2
	animname3 = Lucian_slash3
	bHardAttach = true
	swordHiltSocketName = SwordHiltSocket
	swordTipSocketName = SwordTipSocket
	handSocketName = WeaponPoint

	
	dmgType = class'DELDmgTypeMelee'
	critDmgType = class'DELDmgTypeMeleeCritical'

	MaxSwings=3
	Swings(0)=3

	FireInterval(0)= 0.66

	damageMin = 10
	damageMax = 50

	bMeleeWeapon=true
	bInstantHit=true
	bCanThrow=false
	//bSwinging = false

	FiringStatesArray(0)="Swinging"

	WeaponFireTypes(0)=EWFT_Custom
}
