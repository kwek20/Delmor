class DELSprintPawn extends UDKPawn;

/**
 * Variables
 **/

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

/**
 * Returns stamina count
 */
simulated function int getStamCount(){
	return Stam;
}

/**
 * Function to start sprinting
 * Works on timers
 */
exec function StartSprint(){
	local float TimeSinceLast;
	local float Log;
	//ConsoleCommand("Sprint");
	Log = 2.512;
	ScaledTimer = (LogE(Stam)/LogE(Log));
	Worldinfo.Game.Broadcast(self, "ScaledTimer Logarithem Calculated");

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
				Worldinfo.Game.Broadcast(self, "Sprinting (Full Sprint)");
				StopFiring();
				ClearTimer('Exhausted');
				ClearTimer('TimeSinceSprint');
				setTimer(StamTimer, true, 'LowerStam');
				setTimer(ScaledTimer, false, 'Exhausted');
			}

			//if we have less than ScaledSprintTimer left use that value instead of ScaledSprintTimer
			if(LastSprint < ScaledTimer){
				Worldinfo.Game.Broadcast(self, "Sprinting (LastSprint < ScaledTimer)");
				StopFiring();
				setTimer(StamTimer, true, 'LowerStam');
				setTimer(LastSprint, false, 'Exhausted');
				ClearTimer('TimeSinceSprint');
			}
		}
		//else sprint normally
		else
		{
			Worldinfo.Game.Broadcast(self, "Sprinting (No prev Timer)");
			StopFiring();
			setTimer(StamTimer, true, 'LowerStam');
			setTimer(ScaledTimer, false, 'Exhausted');
		}
	}
}

exec function StopSprint(){
	Groundspeed = 375.0;
	bSprinting = false;
	ClearTimer('LowerStam');
	setTimer(StamRegenRate, true, 'RegenStam');

		//How long were we exhausted
	if(isTimerActive('Exhausted')){
		//How many seconds of sprint did we have left
		SprintTimerCount = ScaledTimer - (GetTimerCount('Exhausted'));
		PauseTimer(true, 'Exhausted');
		SetTimer(5.0, false, 'TimeSinceSprint');
	}
}

simulated function LowerStam(){
	if(Stam > 0){ //If Stam is enough, remove per sec
		Worldinfo.Game.Broadcast(self, "-5 stam");
		Stam -= StamLoss;
	}

	if(Stam <= 0){
		//If not, stop sprnting and clear depletion timer
		StopSprint();
		bCanSprint = false;
		bSprinting = false;
		Worldinfo.Game.Broadcast(self, "Out of Stam");
		ClearTimer('DepleteStam');
	}
}

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

simulated function SprintRecovery(){
	bCanSprint = true;
	bExhausted = false;
 WorldInfo.Game.Broadcast(self, "SprintRecovery, No Longer Winded");
}

simulated function RegenStam(){
	if(bSprinting){
		ClearTimer('RegenStam'); //if we start sprinting, cancel regen
		Worldinfo.Game.Broadcast(self, "Sprint called, regen cancelled");
		return;
	}

	else
	{
		if(Stam < MaxStam){ //if current stam lower then max
			Stam += StamRegenVal; //start regen
			Worldinfo.Game.Broadcast(self,  "+1 stam");
		}

		if(Stam >= MaxStam){
			clearTimer('RegenStam');
			Worldinfo.Game.Broadcast(self, "Max stam; killing regen timer"); //if its full, stop regen and clear timer
		}
	}
}


DefaultProperties
{
	bIsPlayer = true;
	Stam = 100.0
	maxStam = 100.0
	StamRegenRate = 3.0
	StamRegenVal = 1.0
	StamTimer = 1.0
	SprintRecoverTimer = 5.0
	StamLoss = 5.0
	Groundspeed = 375.0
}
