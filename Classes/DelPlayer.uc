/**
 * the lucian class
 * has everything lucian needs in delmor
 * @author programming team(everybody)
 */
class DELPlayer extends DELCharacterPawn implements(DELSaveGameStateInterface);



var array< class<Inventory> > DefaultInventory;
var DELWeapon sword;
var DELMagic magic;



var class<DELMeleeWeapon> swordClass;


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
 * Determines whether the player is kicking a chicken.
 * When kicking, the chicken kick function shouldn't be executed again.
 * You'll have to wait for the kicking to finish.
 */
var bool bIsKickingAChicken;

/**
 * The chicken to kick.
 */
var DELChickenPawn chickenToKick;

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
 * Set camera amongst and give sword.
 * kinda the init of the playah
 */
simulated event PostBeginPlay(){
	super.PostBeginPlay();
	AddDefaultInventory();

	setCameraOffset( 0.0 , 0.0 , defaultCameraHeight );
	SetThirdPersonCamera( true );

	QManager = Spawn(class'DELQuestManager',,,);
	QManager.createQuest("The Interview", "Je moet de grote leider van Noord-Korea vermoorden.");
	QManager.createQuest("Dropbox", "Je moet een pakketje droppen bij de Hogeschool Arnhem Nijmegen. Je moet een pakketje droppen bij de Hogeschool Arnhem Nijmegen. Je moet een pakketje droppen bij de Hogeschool Arnhem Nijmegen. Je moet een pakketje droppen bij de Hogeschool Arnhem Nijmegen. Je moet een pakketje droppen bij de Hogeschool Arnhem Nijmegen.");
	QManager.createQuest("The Crash", "Schiet een drone uit de lucht boven China.");
	QManager.createQuest("Apple Destroyer", "Installeer Windows 10 op alle Apple computers.");
	QManager.addObjective(QManager.getQuest("The Interview"), "Krijg een geweer");
	QManager.completeObjective(QManager.getQuest("The Interview"), "Krijg een geweer");
}

exec function suicideFail(){
	health = healthmax -(healthmax * 0.8);
}

function OnCompleteObjective(){

}

function OnAddObjective(DELSeqAct_AddObjective Action){

}


function OnCreateQuest(DELSeqAct_CreateQuest Action){
	local array<String> questStuff;
	questStuff = action.getQuestInfo();
	QManager.createQuest(questStuff[0],questStuff[1]);
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
	local DELHostilePawn nearest;

	if( bNoWeaponFiring){
		return;
	}
	if(FireModeNum == 1 && magic!= None){
		magic.FireStart();
	}
	if(FireModeNum == 0 && sword != None){
		//Stop moving (So that the auto-aim will work.
		//DELPlayerInput( DELPlayerController( controller ).getHud().PlayerOwner.PlayerInput ).stopMoving();
		//Turn the player towards a nearby enemy when there's no enemy in front of him.
		if ( !anEnemyIsInFrontOfPlayer() && anEnemyIsNearPlayer() ){
			nearest = nearestEnemy();
			DELPlayerInput( DELPlayerController( controller ).getHud().PlayerOwner.PlayerInput ).targetYaw = rotator( adjustLocation( nearest.Location , location.z ) - location ).Yaw;
		}
		else{
			DELPlayerInput( DELPlayerController( controller ).getHud().PlayerOwner.PlayerInput ).targetYaw = controller.Rotation.Yaw;
		}
		weapon.StartFire(FireModeNum);
		PlaySound( SoundCue'Delmor_sound.Weapon.sndc_sword_swing' );
	}
}

/**
 * Checks whether the player is aimed at an enemy.
 */
function bool anEnemyIsInFrontOfPlayer(){
	local vector inFrontLocation;
	local DELHostilePawn p;

	inFrontLocation = getInFrontLocation( controller.Rotation.Yaw );
	
	foreach worldInfo.AllPawns( class'DELHostilePawn' , p , location , 256.0 ){
		if ( !p.isInState( 'Dead' ) 
			&& self.CheckCircleCollision( inFrontLocation , GetCollisionRadius() * 0.5 , p.location , p.GetCollisionRadius() ) ){
				return true;
		}
	}
	return false;
}

/**
 * Checks whether there's an enemy near the player.
 */
function bool anEnemyIsNearPlayer(){
	local DELHostilePawn p;

	foreach worldInfo.AllPawns( class'DELHostilePawn' , p , location , 256.0 ){
		if ( !p.isInState( 'Dead' ) ){
			return true;
		}
	}
	return false;
}

/**
 * Gets the nearest enemy.
 */
function DELHostilePawn nearestEnemy(){
	local DELHostilePawn p , nearest;
	local float smallestDistance , distance;
	
	smallestDistance = 256.0;
	nearest = none;

	foreach worldInfo.AllPawns( class'DELHostilePawn' , p , location , 256.0 ){
		distance = VSize( location - p.location );
		if ( !p.isInState( 'Dead' ) && distance < smallestDistance ){
			smallestDistance = distance;
			nearest = p;
		}
	}

	return nearest;
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

function PickUp() {   
	local DELItemInteractible p;
	local float pickupRange;
	pickupRange = 128.0;
	foreach WorldInfo.allActors(class'DELItemInteractible', p) {
		if (VSize(location-p.location) < pickupRange) {
			p.pickup();
		}
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
		Mesh.SetAnimTreeTemplate( AnimTree'Delmor_Character.AnimTrees.Lucian_Sprint_AnimTree' );
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
	Mesh.SetAnimTreeTemplate( AnimTree'Delmor_Character.AnimTrees.Lucian_AnimTree' );
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
	PlaySound( SoundCue'Delmor_sound.Lucian.sndc_lucian_pant' );
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

	inFrontLocation = getInFrontLocation( self.rotation.yaw );

	foreach WorldInfo.AllControllers( class'DELChickenController' , c ){
		if ( VSize( Location - c.Pawn.Location ) < 96.0 ){
			if ( CheckCircleCollision( inFrontLocation , GetCollisionRadius() + 1.0 , /*c.adjustLocation( c.Pawn.Location , location.z )*/c.Pawn.Location , c.Pawn.GetCollisionRadius() + 1.0 ) ){
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
private function startKickingAChicken( DELChickenPawn c ){
	bIsKickingAChicken = true;
	playKickAnimation();
	chickenToKick = c;
	SetTimer( 0.5080 , false , 'actuallyKickChicken' );
	SetTimer( 0.8333 , false , 'finishKick' );
}

/**
 * Actually kick the chicken causing it to move.
 */
private function actuallyKickChicken(){
	local Vector selfToChicken , footLocation;

	footLocation = getASocketsLocation( 'ChickenKickSocket' );
	chickenToKick.SetLocation( footLocation );
	selfToChicken = chickenToKick.location - Location;

	chickenToKick.knockBack( 500.0 , selfToChicken );
	chickenToKick.kick();
	spawnChickenKickEffects( footLocation );
}

/**
 * This function will be called at the end of the Kick animation. It will set bIsKickingAChicken to false.
 */
function finishKick(){
	bIsKickingAChicken = false;
}

/**
 * Spawns a cool particle-effect for extra chicken-kick-y-ness.
 * @param l Vector  The location where the effect should be spawned.
 */
function spawnChickenKickEffects( vector l ){
	local ParticleSystem p;

	p = ParticleSystem'Delmor_Character.Particles.p_feathers';

	worldInfo.MyEmitterPool.SpawnEmitter( p , l );
}

/**
 * Return the player's position plus 32 in the player's direction.
 * @param yaw   int When given, the player will use this yaw to determine the infront location.
 */
function Vector getInFrontLocation( optional int yaw ){
	local vector newLocation;
	local int useYaw;

	if ( yaw != 0 ){
		useYaw = yaw;
	} else {
		useYaw = rotation.yaw;
	}

	newLocation.X = location.X + lengthDirX( 32.0 , -useYaw );
	newLocation.Y = location.Y + lengthDirY( 32.0 , -useYaw );
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

	//Pick nearby items.
	PickUp();

	if ( !bIsKickingAChicken ){
		chicken = chickenIsInFrontOfMe();

		//Kick a chicken!!
		if ( chicken != none ){
			startKickingAChicken( chicken );
		}
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

/*
 * ==================================
 * Functions for animation
 * ==================================
 */

/**
 * Plays the kick animation.
 */
function playKickAnimation(){
	SwingAnim.PlayCustomAnim( 'Lucian_kick_chicken' , 1.0 , 0.0 , 0.0 , false , true );
}


/**
 * Plays the item pickup animation
 */
function playPickupAnimation(){
	SwingAnim.PlayCustomAnim( 'Lucian_Pickup' , 1.0 , 0.0 , 0.0 , false , true );
}

function bool died( Controller killer , class<DamageType> damageType , vector HitLocation ){
	playDeathAnimation();
	super.died( killer , damageType , HitLocation );
	playDeathAnimation();
	GroundSpeed = 0.0;
}

function returnToPreviousState(){
	goToState( /*'Playing'*/ 'Playing' );
}

DefaultProperties
{
	deathAnimName = Lucian_Death

	swordClass = class'DELMeleeWeaponDemonSlayer';
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'
	bCanBeBaseForPawn=true

	Components.Remove(ThirdPersonMesh);

	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_lucian'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Lucian_anim'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.Lucian_walking_Physics'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Lucian_AnimTree'
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
	//groundSpeed = 250.0

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

	bIsKickingAChicken = false

	hitSound = SoundCue'Delmor_sound.Lucian.sndc_lucian_hit'
}
