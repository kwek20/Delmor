/**
 * This DELPawn will later later split in to the monsters that the player has to defeat and the NPCs that
 * the player can talk to.
 * So MonsterPawns and VillagerPawns will both inherit from DELPawn.
 * DELCharacterPawn will extend from this and if you create a new pawn, it should extend from DELCharacterPawn.
 * 
 * @author Anders Egberts
 */
class DELPawn extends UTPawn;


/* ==========================================
 * Stats
 * ==========================================
 */


/**
 * How much health the pawn will regain each second.
 */
var int healthRegeneration;

/**
 * The current amount of mana that the pawn has.
 * Mana is used to cast spells.
 */
var int mana;

/**
 * The maximum amount of mana this pawn can have.
 */
var int manaMax;

/**
 * The pawn's mana pool will refill with this amount each second.
 */
var int manaRegeneration;

/**
 * Resistance againt melee-attacks.
 * Usage: DamageToDeal = Damage * ( 1 - physicalResistance );
 */
var float physicalResistance;

/**
 * Resistance againt magic-attacks.
 * Usage: DamageToDeal = Damage * ( 1 - magicResistance );
 */
var float magicResistance;

/**
 * The speed of the pawn when it is walking.
 */
var float walkingSpeed;

/**
 * The range at which the pawn can detect the player.
 */
var float detectionRange;

var array< class<Inventory> > DefaultInventory;

/**
 * Timer for regeneration. If it hit zero, the timer will reset to 1.0 and the pawn will regain health and mana.
 */
var float regenerationTimer;

/**
 * When the pawn is stunned it may not move or attack.
 */
var bool bIsStunned;

/**
 * Determines whether the pawn can block or not.
 */
var bool bCanBlock;

/**
 * The weapon that will be used by the pawn.
 */
var DELWeapon myWeapon;

/**
 * The class for the weapon that should be spawned.
 */
var class<DELMeleeWeapon> weaponClass;

/**
 * The interval in which the pawn can attack in seconds.
 */
var float attackInterval;

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

/*
 * ==========================================================
 * Weapons and shite
 * ==========================================================
 */
/**
 * the meleeWeapon that the pawn holds
 */
var DELWeapon sword;

/**
 * class of the sword
 */
var class<DELMeleeWeapon> swordClass;


/**
 * Reference to the swing animation in the anim tree.
 */
var() const array<Name> SwingAnimationNames;
var AnimNodePlayCustomAnim SwingAnim;

/*
 * ====================================
 * Sound
 * ====================================
 */

/**
 * This soundset contains the pawn's voice
 */
var DELSoundSet mySoundSet;

var class<DELInventoryManager> UInventory;

var repnotify DELInventoryManager UManager;

var class<DELQuestManager> QuestManager;

var repnotify DELQuestManager QManager;

/*
 * =========================================
 * Animation
 * =========================================
 */
var array<name> animname;
/**
 * An int to point to the attack-animation array.
 */
var int attackNumber;

/**
 * In this event, the pawn will get his movement physics, camera offset and controller.
 */
simulated event PostBeginPlay(){
	super.PostBeginPlay(); 

	QManager = Spawn(class'DELQuestManager',,,);
	QManager.createQuest("The Interview", "Je moet de grote leider van Noord-Korea vermoorden.");
	QManager.createQuest("Dropbox", "Je moet een pakketje droppen bij de Hogeschool Arnhem Nijmegen. Je moet een pakketje droppen bij de Hogeschool Arnhem Nijmegen. Je moet een pakketje droppen bij de Hogeschool Arnhem Nijmegen. Je moet een pakketje droppen bij de Hogeschool Arnhem Nijmegen. Je moet een pakketje droppen bij de Hogeschool Arnhem Nijmegen.");
	QManager.createQuest("The Crash", "Schiet een drone uit de lucht boven China.");
	QManager.createQuest("Apple Destroyer", "Installeer Windows 10 op alle Apple computers.");
	

	spawnDefaultController();
	setCameraOffset( 0.0 , 0.0 , defaultCameraHeight );
	SetThirdPersonCamera( true );
	SetMovementPhysics();
	//Mesh.GetSocketByName("");
	//Mesh.GetSocketByName(socketName);
	SetTimer( 1.0 , true , nameOf( regenerate ) ); 

	 //Set up custom inventory manager
     if (UInventory != None){
		UManager = Spawn(UInventory, Self);
		if ( UManager == None )
			`log("Warning! Couldn't spawn InventoryManager" @ UInventory @ "for" @ Self @  GetHumanReadableName() );

	}
	
	AddDefaultInventory();
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
 * adds the weapons(magic + masterSword to the player)
 */
function AddDefaultInventory(){
	sword = Spawn(swordClass,,,self.Location);
	sword.GiveTo(Controller.Pawn);
	Controller.ClientSwitchToBestWeapon();
}

/**
 * heals a pawn
 * @param ammount the ammount to be healed
 */
function Heal(int ammount){
	health += ammount;
	if(health>healthMax){
		health = clamp(health,0,healthMax);
	}
}

/**
 * subtracts the mana from the player
 * @param ammount of mana to be subtracted
 */
function ManaDrain(int ammount){
	mana -=ammount;
	mana = clamp(mana,0,manaMax);
}

function magicSwitch(int AbilityNumber);

/**
 * Starts blocking by going into the blocking-state
 */
function startBlocking(){
	if ( !bIsStunned && bCanBlock ){
		goToState( 'Blocking' );
	}
}

/**
 * Stop blocking by going into the LandMovementState
 */
function stopBlocking(){
	goToState( LandMovementState );
}

/**
 * Sets bCanBlock to true.
 */
function resetCanBlock(){
	bCanBlock = true;
}

/**
 * Stuns the pawn for a given time.
 */
function stun( float duration ){
	velocity.x = 0.0;
	velocity.y = 0.0;
	velocity.z = 0.0;
	controller.goToState( 'Stunned' );
	setTimer( duration , false , 'endStun' );
}

/**
 * Ends the stun.
 */
function endStun(){
	`log( "***************************" );
	`log( "###########################" );
	`log( ">>>>>>>>>>>>>>>>>> END STUN" );
	`log( "###########################" );
	`log( "***************************" );
	controller.goToState( 'Idle' );
}

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

		//If in look mode, rotate the pawn according to the camera's rotation
		//if ( bLockedToCamera ){
		//	self.SetRotation( newRotation );
		//}
		//else{
			Controller.SetRotation( newRotation );
		//}

		if (Trace(HitLocation, HitNormal, out_CamLoc, Location, false, vect(12, 12, 12)) != none){
			out_CamLoc = HitLocation;
		}
	}

    return true;
}

/**
 * In this event the pawn will slowly regain health and mana.
 */
event Tick( float deltaTime ){
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

/**
 * Regenerates health and mana.
 */
private function regenerate(){
	health = Clamp( health + healthRegeneration , 0 , healthMax );
	mana = Clamp( mana + manaRegeneration , 0 , manaMax );
}

/**
 * Spawns the pawn's controller and deletes the previous one.
 */
function SpawnController(){
	`log( "Spawn controller. ControllerClass: " $ControllerClass );
	if ( controller != none )
		controller.Destroy();

	controller = spawn( ControllerClass );
	controller.Pawn = self;
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

/**
 * Knocks the pawn back.
 * @param intensity float   The power of the knockback. The higher the intensity the more the pawn should be knocked back.
 * @param direction Vector  The vector that will be the direction (i.e.: selfToPlayer, selfToPawn ).
 */
function knockBack( float intensity , vector direction ){
	local DELKnockbackForce knockBack;

	knockBack = spawn( class'DELKnockbackForce' );
	knockBack.setPower( intensity );
	knockBack.myPawn = self;
	knockBack.direction = direction;
	knockBack.beginZ = location.Z;
	knockBack.pawnsPreviousState = controller.GetStateName();
	controller.GotoState( 'KnockedBack' );
	bBlockActors = false;
}

simulated exec function turnLeft(){
	`log( self$" TurnLeft" );
}

simulated exec function turnRight(){
	`log( self$" TurnRight" );
}

/**
 * Pawn starts firing!
 * Called from PlayerController::StartFiring
 * Network: Local Player
 *
 * @param	FireModeNum		fire mode number
 */
simulated function StartFire(byte FireModeNum){
	if(/* sword != None */true){
		weapon.StartFire(0);
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
	if(/*FireModeNum == 0 && sword != None*/true){
		weapon.StopFire(0);
	}
}

/**
 * Performs an attack.
 */
function attack(){
	/*
	 * TODO:
	 * Play anim
	 * Check if hit someone.
	 * Go to attacking state.
	 */
	if ( !controller.IsInState( 'Attacking' ) ){
		playAttackAnimation();
		controller.goToState( 'Attacking' );
		setTimer( attackInterval + 0.2 , false , 'resetAttackCombo' ); //Reset the attack combo if not immidiatly attacking again.
		increaseAttackNumber();
		say( "AttackSwing" );
	}

	//weapon.StartFire(0);
}

/**
 * Play an attack animation.
 */
function playAttackAnimation(){
	self.SwingAnim.PlayCustomAnim(animname[ attackNumber ], 1.0 , 0.1 , 0.1f , false , true );
}

/**
 * Sets the attack number to 0
 */
function resetAttackCombo(){
	attackNumber = 0;
}

/**
 * Increases the attackNumber after an attack so that we'll play a different animation.
 */
function increaseAttackNumber(){
	attackNumber ++;
	if ( attackNumber >= 3 ){
		resetAttackCombo();
	}
}

/**
 * Say a line from the sound set. Only one sound can be played per 2 seconds.
 */
function say( String dialogue ){
	`log( ">>>>>>>>>>>>>>>>>>>> "$self$" said something ( "$dialogue$" )" );
	if ( mySoundSet != none && mySoundSet.bCanPlay ){
		mySoundSet.PlaySound( mySoundSet.getSound( dialogue ) );
		mySoundSet.bCanPlay = false;
		mySoundSet.setTimer( 0.5 , false , nameOf( mySoundSet.resetCanPlay ) );
	}
}

DefaultProperties
{
	bCanPickUpInventory = true
	UInventory = DELInventoryManager

	MaxFootstepDistSq=9000000.0
	health = 100
	healthMax = 100
	healthRegeneration = 1
	mana = 100
	manaMax = 100
	manaRegeneration = 1
	meleeRange = 100.0
	physicalResistance = 0.0
	magicResistance = 0.0
	GroundSpeed = 100
	detectionRange = 960.0
	regenerationTimer = 1.0
	weaponClass = class'DELMeleeWeaponRatClaws'
	attackInterval = 1.0

	bIsStunned = false

	camOffsetDistance = 200.0
	camTargetDistance = 200.0
	defaultCameraHeight = 48.0
	cameraTargetHeight = 48.0
	cameraZoomHeight = 64.0
	camPitch = -5000.0
	bLookMode = false
	bLockedToCamera = false

	ControllerClass = class'DELNpcController'

	//Collision cylinder
	Begin Object Name=CollisionCylinder
		CollisionRadius = 16.0;
		CollisionHeight = +44.0;
	end object

	//Mesh
	Begin Object Class=SkeletalMeshComponent Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'UTExampleCrowd.Mesh.SK_Crowd_Robot'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimtreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=-42.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)

	swordClass = class'DELMeleeWeaponDemonSlayer';

	ArmsMesh[0] = none
	ArmsMesh[1] = none

	mySoundSet = none

	animname[ 0 ] = ratman_attack1
	animname[ 1 ] = ratman_attack2
	animname[ 2 ] = ratman_jumpattack

	attackNumber = 0
}