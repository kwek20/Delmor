class DELPlayer extends DELCharacterPawn;

var array< class<Inventory> > DefaultInventory;
var DELWeapon sword;
var DELMagic magic;
var bool    bSprinting;
var bool    bCanSprint;
var bool    bExhausted;
var float   Stam;
var float   maxStam;
var float   StamTimer;
var float   StamLoss;
var float   StamRegenRate;
var float   StamRegenVal;
var float   SprintRecoverTimer;
var float   SprintTimerCount;
var float   LastSprint;
var float   ScaledTimer;

var() const array<Name> SwingAnimationNames;
var AnimNodePlayCustomAnim SwingAnim;

simulated function bool IsFirstPerson(){
	return false;
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	
	Global.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
	if(magic != none){
		magic.Interrupt();
	}
}




/**
 * selects a point in the animtree so it is easier acessible
 * it is unknown to me what the super does
 * @param SkelComp the skeletalmesh component linked to the animtree
 */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp){
	super.PostInitAnimTree(SkelComp);

	if (SkelComp == Mesh){
		SwingAnim = AnimNodePlayCustomAnim(SkelComp.FindAnimNode('SwingCustomAnim'));
		`log("-------------------__________-----------------");
	}
}

/**
 * adds the weapons(magic + masterSword to the player)
 */
function AddDefaultInventory(){
	sword = Spawn(class'DELMeleeWeapon',,,self.Location);
	sword.GiveTo(Controller.Pawn);
	Controller.ClientSwitchToBestWeapon();
	magic = Spawn(class'DELMagic',,,self.Location);
	magic = Spawn(magic.getMagic(),,,self.Location);
	magic.GiveTo(Controller.Pawn);
}


simulated event PostBeginPlay(){
	super.PostBeginPlay();
	AddDefaultInventory();
	magicSwitch(1);
}

/**
 * switches magical ability
 */
simulated function magicSwitch(int AbilityNumber){
	if(bNoWeaponFiring){
		return;
	}	
	if(magic != None && AbilityNumber <= magic.getMaxSpells()){
		magic.switchMagic(AbilityNumber);
		magic = Spawn(magic.getMagic(),,,self.Location);
		magic.GiveTo(Controller.Pawn);
	}
}


/**
 * Pawn starts firing!
 * Called from PlayerController::StartFiring
 * Network: Local Player
 *
 * @param	FireModeNum		fire mode number
 */
simulated function StartFire(byte FireModeNum){
	if( bNoWeaponFiring){
		return;
	}
	if(FireModeNum == 1 && magic!= None){
		magic.FireStart();
	}
	if(FireModeNum == 0 && sword != None){
		weapon.StartFire(FireModeNum);
	}
}


/**
 * Pawn stops firing!
 * i.e. player releases fire button, this may not stop weapon firing right away. (for example press button once for a burst fire)
 * Network: Local Player
 *
 * @param	FireModeNum		fire mode number
 */
simulated function StopFire(byte FireModeNum){
	`log("mouse released");
	if(FireModeNum == 1 && magic!= None){
		magic.FireStop();
	}
	if(FireModeNum == 0 && sword != None){
		sword.StopFire(FireModeNum);
	}
}


/*================================================
 *                 SPRINTING
 *================================================*/

/**
 * Returns stamina count
 */
simulated function int getStamCount(){
	return Stam;
}

/**
 * Function to start sprinting
 * Works on timers according to a logarithm
 */
exec function StartSprint(){
	local float TimeSinceLast;
	local float Log;
	//ConsoleCommand("Sprint");
	Log = 2.512;
	ScaledTimer = (LogE(Stam)/LogE(Log));
//	Worldinfo.Game.Broadcast(self, "ScaledTimer Logarithem Calculated");

	// ^Logarithm to perform ScaledSprintTimer = Log(2.512) for (Stamina)
     // Scales our SprintTimer on a curve based upon how much stamina we have left:
                    //Log(2.512) for 100 Stam = 4.99 sec
                    // "    "    for  50 Stam = 4.24 sec
                    // "    "    for  25 Stam = 3.49 sec
                    // "    "    for  15 Stam = 2.94 sec
                    // "    "    for  10 Stam = 2.49 sec
                    // "    "    for   5 Stam = 1.75 sec

     //NOTE: As it is written here, the Logarithm is recalculated everytime the
     //player toggles sprint, so as to avoid issues with players repeatedly
     //'tapping' the sprint key to try and cheat the SprintTimer
	
	//If Stamina lower then Stamina loss per tick
	//Cant sprint
	if(Stam <= StamLoss){
		bCanSprint = false;
		StopSprint();
		return;
	}
	//If stamia bigger then Stamina loss and exhausted == false
	if(Stam >= StamLoss && bExhausted != true){
		bSprinting= true;
		GroundSpeed = 600.000;

		//Recently sprinted?
		if(isTimerActive('TimeSinceSprint'))
		{
			//Pause timer
			PauseTimer(true, 'TimeSinceSprint');
			//Find how long sprint duration was
			TimeSinceLast = GetTimerCount('TimeSinceSprint');
			//how many seconds of sprint we had left + how many seconds since we last sprinted
			LastSprint = SprintTimerCount + TimeSinceLast;
			
			//IF its more then scaled, use this
			if(LastSprint >= ScaledTimer){
			
				StopFiring();
				ClearTimer('Exhausted');
				ClearTimer('TimeSinceSprint');
				setTimer(StamTimer, true, 'LowerStam');
				setTimer(ScaledTimer, false, 'Exhausted');
			}

			//if we have less than ScaledSprintTimer left use that value instead of ScaledSprintTimer
			if(LastSprint < ScaledTimer){
		
				StopFiring();
				setTimer(StamTimer, true, 'LowerStam');
				setTimer(LastSprint, false, 'Exhausted');
				ClearTimer('TimeSinceSprint');
			}
		}
		//else sprint normally
		else
		{
	
			StopFiring();
			setTimer(StamTimer, true, 'LowerStam');
			setTimer(ScaledTimer, false, 'Exhausted');
		}
	}
}

/**
 * Stops sprinting
 * checks if certain timer (exhausted) is active
 * if so, stop sprinting
 */
exec function StopSprint(){
	Groundspeed = 375.0;
	bSprinting = false;
	ClearTimer('LowerStam');
	//set timer for lowering stamina
	setTimer(StamRegenRate, true, 'RegenStam');

		//How long were we exhausted
	if(isTimerActive('Exhausted')){
		//How many seconds of sprint did we have left
		SprintTimerCount = ScaledTimer - (GetTimerCount('Exhausted'));
		PauseTimer(true, 'Exhausted');
		SetTimer(5.0, false, 'TimeSinceSprint');
	}
}


/**
 * Lowers the stamina at a -5 rate per second
 * if stam =< 0 stops sprinting and clears depletion so that regen can start
 */
simulated function LowerStam(){
	if(Stam > 0){ //If Stam is enough, remove per sec

		Stam -= StamLoss;
	}

	if(Stam <= 0){
		//If not, stop sprnting and clear depletion timer
		StopSprint();
		bCanSprint = false;
		bSprinting = false;

		ClearTimer('DepleteStam');
	}
}

/**
 * Gets called when stopsprint is called from startsprint
 * and exhaustion timer is enabled
 * starts the regen
 */
simulated function Exhausted(){
	bExhausted = true;
	Groundspeed = 375.000;
	bSprinting = false;
	bCanSprint = false;
	Worldinfo.Game.Broadcast(self, "Exhausted, rest a moment");
	ClearTimer('LowerStam');
	SetTimer(SprintRecoverTimer, false, 'SprintRecovery'); //How long till next sprint
	SetTimer(StamRegenRate, true, 'RegenStam'); //start regeneration
}

/**
 * Gets called if sprinting is available again
 */
simulated function SprintRecovery(){
	bCanSprint = true;
	bExhausted = false;
}

/**
 * Regenerates stamina
 */
simulated function RegenStam(){
	if(bSprinting){
		ClearTimer('RegenStam'); //if we start sprinting, cancel regen
		return;
	}

	else
	{
		if(Stam < MaxStam){ //if current stam lower then max
			Stam += StamRegenVal; //start regen

		}

		if(Stam >= MaxStam){
			clearTimer('RegenStam');

		}
	}
}

DefaultProperties
{
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
	bCanBeBaseForPawn=true

	Components.Remove(ThirdPersonMesh);

		Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Lucian_walking'
		AnimSets(0)=AnimSet'Delmor_Character.Lucian_walking'
		PhysicsAsset=PhysicsAsset'Delmor_Character.Lucian_walking_Physics'
		AnimtreeTemplate=AnimTree'Delmor_Character.Lucian_AnimTree'
		Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=-50.0)
	End Object
    Components.Add(ThirdPersonMesh)

	bIsPlayer = true
	Stam = 100.0
	maxStam = 100.0
	StamRegenRate = 3.0
	StamRegenVal = 1.0
	StamTimer = 1.0
	SprintRecoverTimer = 5.0
	StamLoss = 5.0
	Groundspeed = 375.0
}
