/**
 * the lucian class
 * has everything lucian needs in delmor
 * @author programming team(everybody)
 */
class DELPlayer extends DELCharacterPawn implements(DELSaveGameStateInterface);

var DELMagic magic;
/**
 * the factory of spells.
 * ask this class anything about the spells player can do anything else himself
 * is called grimoire for a reason . don't change it
 */
var DELMagicFactory Grimoire;

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

/* ==========================================
 * Camera stuff
 * ==========================================
 */

/**
 * Distance of the camera to this pawn.
 */
var float camOffsetDistance;
/**
 * The distance of the camera that we want, if camera is not at this distance it will adjust
 * the actualdistance till it is.
 */
var float camTargetDistance;
/**
 * The pitch of the camera.
 */
var float camPitch;
/**
 * Offset from the camera to the pawn.
 */
var Vector cameraOffset;

/**
 * Determines whether the player is in look mode.
 * When in look mode, the pawn will not rotate with the camara.
 * Else the camera will rotate with the pawn.
 */
var bool bLookMode;
/**
 * If locked to camera, the pawn's direction will be determined by the camera-direction.
 */
var bool bLockedToCamera;

var float defaultCameraHeight;
var float cameraZoomHeight;
var float cameraTargetHeight;

/**
 * makes sure everybode knows this player is not first-person and never will be
 */
simulated function bool IsFirstPerson(){
	return false;
}

/**
 * added an extra to takedamage so that some spells will be interrupted when you get hit
 * @param damage ammount of damage
 * @param instigatedby the player that does damage
 * @param hitlocation where you get hit
 * @param momentum momentum in the object that does damage
 * @param damagetype type of damage taken
 * @param hitinfo info about info
 * @param damagecauser no clue but probably the weapon that did the damage
 */
event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	
	super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
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
	}
}

/**
 * adds the certain items to the default inventory
 */
function AddDefaultInventory(){
	sword = Spawn(swordClass,,,self.Location);
	sword.GiveTo(Controller.Pawn);
	Controller.ClientSwitchToBestWeapon();
	grimoire = Spawn(class'DELMagicFactory');
	magic = grimoire.getMagic();
}

/**
<<<<<<< HEAD
 * Set camera amongst and give sword.
=======
 * kinda the init of the playah
>>>>>>> 462777f187f88e4a03363bd507bc1cf14bc90989
 */
simulated event PostBeginPlay(){
	super.PostBeginPlay();
	AddDefaultInventory();
	setCameraOffset( 0.0 , 0.0 , defaultCameraHeight );
	SetThirdPersonCamera( true );
	//Location.Z = 10000;
}

/**
 * switches magical ability to the one given (1,2,3,4)
 * @param abilitynumber the number of the ability you want to switch to
 */
simulated function magicSwitch(int AbilityNumber){
	if(bNoWeaponFiring){
		return;
	}	
	if(grimoire != None && AbilityNumber <= grimoire.getMaxSpells()){
		magic = grimoire.getMagic(AbilityNumber);
	}
}


/**
 * Pawn starts firing!
 * directly delegates the startfire on specific firemodes
 * @param	FireModeNum the firemode instigated. if it is 0 melee will be used, if 1 magic
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
 * stops firing 
 * (on release mouse)
 * delegates the function to either magic or sword 
 * same delegation as in startfire()
 * @param	FireModeNum		firemode used. 
 */
simulated function StopFire(byte FireModeNum){
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
exec function startSprint(){
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
		if(isTimerActive('TimeSinceSprint')){
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
		else{
	
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
exec function stopSprint(){
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
 * Ends the stun.
 */
function endStun(){
	controller.goToState( 'Playing' );
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
	} else {
		if(Stam < MaxStam){ //if current stam lower then max
			Stam += StamRegenVal; //start regen

		}

		if(Stam >= MaxStam){
			clearTimer('RegenStam');

		}
	}
}

function String Serialize()
{
    local JSonObject PJSonObject;

    // Instance the JSonObject, abort if one could not be created
    PJSonObject = new class'JSonObject';

    if (PJSonObject == None)
    {
		`Warn(Self$" could not be serialized for saving the game state.");
		return "";
    }

    // Save the location
    PJSonObject.SetFloatValue("Location_X", Location.X);
    PJSonObject.SetFloatValue("Location_Y", Location.Y);
    PJSonObject.SetFloatValue("Location_Z", Location.Z);

    // Save the rotation
    PJSonObject.SetIntValue("Rotation_Pitch", Rotation.Pitch);
    PJSonObject.SetIntValue("Rotation_Yaw", Rotation.Yaw);
    PJSonObject.SetIntValue("Rotation_Roll", Rotation.Roll);

    // If the controller is the player controller, then saved a flag to say that it should be repossessed
    //by the player when we reload the game state
    PJSonObject.SetBoolValue("IsPlayer", DELPlayerController(self.Controller) != none);

    // Send the encoded JSonObject
    return class'JSonObject'.static.EncodeJson(PJSonObject);
}

function Deserialize(JSonObject Data)
{
    local Vector SavedLocation;
    local Rotator SavedRotation;
    local DELGAME SGameInfo;

    // Deserialize the location and set it
    SavedLocation.X = Data.GetFloatValue("Location_X");
    SavedLocation.Y = Data.GetFloatValue("Location_Y");
    SavedLocation.Z = Data.GetFloatValue("Location_Z");
    SetLocation(SavedLocation);

    // Deserialize the rotation and set it
    SavedRotation.Pitch = Data.GetIntValue("Rotation_Pitch");
    SavedRotation.Yaw = Data.GetIntValue("Rotation_Yaw");
    SavedRotation.Roll = Data.GetIntValue("Rotation_Roll");
    SetRotation(SavedRotation);

    // Deserialize if this was a player controlled pawn, if it was then tell the game info about it
    if (Data.GetBoolValue("IsPlayer")){
		SGameInfo = DELGame(self.WorldInfo.Game);

		if (SGameInfo != none){
			SGameInfo.PendingPlayerPawn = self;
		}
    }
}

/*
 * ============================================
 * Chicken kicking
 * ============================================
 */

/**
 * Checks whether a chicken is in front of the player pawn and returns that chicken
 */
private function DELChickenPawn chickenIsInFrontOfMe(){
	local DELChickenController c;
	local DELChickenPawn toReturn;
	local Vector inFrontLocation;

	toReturn = none;

	inFrontLocation = getInFrontLocation();

	foreach WorldInfo.AllControllers( class'DELChickenController' , c ){
		if ( VSize( Location - c.Pawn.Location ) < 96.0 ){
			if ( CheckCircleCollision( inFrontLocation , GetCollisionRadius() + 1.0 , c.adjustLocation( c.Pawn.Location , location.z ) , c.Pawn.GetCollisionRadius() + 1.0 ) ){
				toReturn = DELChickenPawn( c.Pawn );
			}
		}
	}

	return toReturn;
}

/**
 * Kicks a chicken, sending it flying through the air.
 * @param c DELChicken  The chicken to kick.
 */
private function kickChicken( DELChickenPawn c ){
	local Vector selfToChicken;

	selfToChicken = c.location - Location;

	c.knockBack( 250.0 , selfToChicken );
	c.kick();
}

/**
 * Return the player's position plus 8 in the player's direction.
 */
function Vector getInFrontLocation(){
	local vector newLocation;

	newLocation.X = location.X + lengthDirX( 16.0 , -Rotation.Yaw );
	newLocation.Y = location.Y + lengthDirY( 16.0 , -Rotation.Yaw );
	newLocation.Z = Location.Z;

	return newLocation;
}

/*
 * ===========================================================
 * Camera
 * ===========================================================
 */
/**
 * Set the camera offset.
 * @param x float   x-offset.
 * @param y float   y-offset.
 * @param z float   z-offset.
 */
function setCameraOffset( float x , float y , float z ){
	cameraOffset.X = x;
	cameraOffset.Y = y;
	cameraOffset.Z = z;
}
/**
 * Calculates a new camera position based on the postition of the pawn.
 */
simulated function bool CalcCamera(float DeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV){
    local Vector HitLocation, HitNormal;
	local Rotator targetRotation;
	/**
	 * New pawn rotation if using look mode.
	 */
	local Rotator newRotation;

	if ( controller.IsA( 'DELPlayerController' ) && DELPlayerController( controller ).canWalk ){
		//Get the controller's rotation as camera angle.
		targetRotation = Controller.Rotation;

		out_CamLoc = Location;
		out_CamLoc.X -= Cos(targetRotation.Yaw * UnrRotToRad) * Cos(camPitch * UnrRotToRad) * camOffsetDistance;
		out_CamLoc.Y -= Sin(targetRotation.Yaw * UnrRotToRad) * Cos(camPitch * UnrRotToRad) * camOffsetDistance;
		out_CamLoc.Z -= Sin(camPitch * UnrRotToRad) * camOffsetDistance;
		out_CamLoc = out_CamLoc + cameraOffset;

		out_CamRot.Yaw = targetRotation.Yaw;
		out_CamRot.Pitch = camPitch;
		out_CamRot.Roll = 0;

		//If in look mode, change the pawn's rotation based on the camera
		newRotation.Pitch = Rotation.Pitch;
		newRotation.Roll = Rotation.Roll;
		newRotation.Yaw = targetRotation.Yaw;

		Controller.SetRotation( newRotation );

		if (Trace(HitLocation, HitNormal, out_CamLoc, Location, false, vect(12, 12, 12)) != none){
			out_CamLoc = HitLocation;
		}
	}

    return true;
}

/**
 * Animates the camera distance.
 * THIS FUNCTION MAY ONLY BE EXECUTED IN THE TICK EVENT.
 * @param deltaTime float   The deltaTime from the tick-event.
 */
function adjustCameraDistance( float deltaTime ){
	local float difference , distanceSpeed;
	difference = max( camOffsetDistance , camTargetDistance ) - min( camOffsetDistance , camTargetDistance );
	distanceSpeed = max( difference * ( 10 * deltaTime ) , 2 );

	if ( camOffsetDistance < camTargetDistance ){
		camOffsetDistance += distanceSpeed;
	}
	if ( camOffsetDistance > camTargetDistance ){
		camOffsetDistance -= distanceSpeed;
	}
	//Lock
	if ( camOffsetDistance + distanceSpeed > camTargetDistance && camOffsetDistance - distanceSpeed < camTargetDistance ){
		camOffsetDistance = camTargetDistance;
	}
}

function adjustCameraOffset( float deltaTime ){
	local float difference , distanceSpeed;
	difference = max( cameraOffset.Z , cameraTargetHeight ) - min( cameraOffset.Z , cameraTargetHeight );
	distanceSpeed = max( difference * ( 10 * deltaTime ) , 2 );

	if ( cameraOffset.Z < cameraTargetHeight ){
		setCameraOffset( 0.0 , 0.0 , cameraOffset.Z + distanceSpeed );
	}
	if ( cameraOffset.Z > cameraTargetHeight ){
		setCameraOffset( 0.0 , 0.0 , cameraOffset.Z - distanceSpeed );
	}
	//Lock
	if ( cameraOffset.Z + distanceSpeed > cameraTargetHeight && cameraOffset.Z - distanceSpeed < cameraTargetHeight ){
		setCameraOffset( 0.0 , 0.0 , cameraTargetHeight );
	}
}

/*
 * ==========================================
 * Events
 * ==========================================
 */
event Tick( float deltaTime ){
	local DELChickenPawn chicken;

	super.Tick( deltaTime );

	chicken = chickenIsInFrontOfMe();

	//Kick a chicken!!
	if ( chicken != none ){
		kickChicken( chicken );
	}

	//Change camera height when aiming
	if ( bLockedToCamera ){
		camTargetDistance = 150.0;
		cameraTargetHeight = cameraZoomHeight;
	} else {
		camTargetDistance = 200.0;
		cameraTargetHeight = defaultCameraHeight;
	}

	if ( controller.IsA( 'DELPlayerController' ) && DELPlayerController( controller ).canWalk ){
		//Animate the camera
		adjustCameraDistance( deltaTime );
		adjustCameraOffset( deltaTime );
	}
}


DefaultProperties
{
	swordClass = class'DELMeleeWeaponDemonSlayer';
	//swordClass = class'DELMeleeWeaponTheButcher'
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
	bCanBeBaseForPawn=true

	Components.Remove(ThirdPersonMesh);

		Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_lucian'
		AnimSets(0)=AnimSet'Delmor_Character.Lucian_anim'
		PhysicsAsset=PhysicsAsset'Delmor_Character.Lucian_walking_Physics'
		AnimtreeTemplate=AnimTree'Delmor_Character.Lucian_AnimTree'
		Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=-48.0)
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

	manaRegeneration = 2

	//Camera
	camOffsetDistance = 200.0
	camTargetDistance = 200.0
	defaultCameraHeight = 48.0
	cameraTargetHeight = 48.0
	cameraZoomHeight = 64.0
	camPitch = -5000.0
	bLookMode = false
	bLockedToCamera = false
}
