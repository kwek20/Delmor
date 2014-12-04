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

/**
 * Timer for regeneration. If it hit zero, the timer will reset to 1.0 and the pawn will regain health and mana.
 */
var float regenerationTimer;

var array< class<Inventory> > DefaultInventory;

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
/**
 * In this event, the pawn will get his movement physics, camera offset and controller.
 */

var class<U_InventoryManager> UInventory;
var repnotify U_InventoryManager UManager;

simulated event PostBeginPlay(){
	super.PostBeginPlay(); 

	spawnDefaultController();
	setCameraOffset( 0.0 , 0.0 , 64.0 );
	SetThirdPersonCamera( true );
	SetMovementPhysics();
	//Mesh.GetSocketByName("");
	//Mesh.GetSocketByName(socketName);

	 //Set up custom inventory manager
        if (UInventory != None)
	{
		UManager = Spawn(UInventory, Self);
		if ( UManager == None )
			`log("Warning! Couldn't spawn InventoryManager" @ UInventory @ "for" @ Self @  GetHumanReadableName() );

	}
}

function AddDefaultInventory()
{
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

		if (Trace(HitLocation, HitNormal, out_CamLoc, Location, false, vect(12, 12, 12)) != none)
		{
			out_CamLoc = HitLocation;
		}
	}

    return true;
}

/**
 * In this event the pawn will slowly regain health and mana.
 */
event Tick( float deltaTime ){
	regenerationTimer -= deltaTime;

	if ( regenerationTimer <= 0.0 ){
		regenerationTimer = 1.0;
		health = Clamp( health + healthRegeneration , 0 , healthMax );
		mana = Clamp( mana + manaRegeneration , 0 , manaMax );
	}

	if ( bLockedToCamera )
		camTargetDistance = 150.0;
	else
		camTargetDistance = 300.0;

	if ( controller.IsA( 'DELPlayerController' ) && DELPlayerController( controller ).canWalk ){
		//Animate the camera
		adjustCameraDistance( deltaTime );
	}
}

/*/**
 * Spawns the pawn's controller and deletes the previous one.
 */
function SpawnController(){
	`log( "Spawn controller. ControllerClass: " $ControllerClass );
	if ( controller != none )
		controller.Destroy();

	controller = spawn( ControllerClass );
	controller.Pawn = self;
}*/

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

simulated exec function turnLeft(){
	`log( self$" TurnLeft" );
}

simulated exec function turnRight(){
	`log( self$" TurnRight" );
}

DefaultProperties
{
	bCanPickUpInventory = true
	UInventory = U_InventoryManager


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
	walkingSpeed = 100.0
	detectionRange = 960.0
	regenerationTimer = 1.0;

	camOffsetDistance = 300.0
	camTargetDistance = 300.0
	camPitch = -5000.0
	bLookMode = false
	bLockedToCamera = false

	ControllerClass = class'DELNpcController'

	//Collision cylinder
	Begin Object Name=CollisionCylinder
	CollisionRadius = 32.0;
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

	ArmsMesh[0] = none
	ArmsMesh[1] = none
}