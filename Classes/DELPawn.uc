/**
 * This DELPawn will later later split in to the monsters that the player has to defeat and the NPCs that
 * the player can talk to.
 * So MonsterPawns and VillagerPawns will both inherit from DELPawn.
 * DELCharacterPawn will extend from this and if you create a new pawn, it should extend from DELCharacterPawn.
 * 
 * KNOWN ISSUES:
 * Collision, if I give the pawn a large height in the collision cylinder, it will somehow float above the ground.
 * However, if I set collisionheight to 1, the pawns will automaticly jump over one another. Problem can be solved by
 * removing the jumping from the pawn.
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


/* ==========================================
 * Camera stuff
 * ==========================================
 */

/**
 * Distance of the camera to this pawn.
 */
var const float camOffsetDistance;
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
 * When in look mode, the pawn will rotate with the camara.
 * Else the camera will rotate with the pawn.
 */
var bool bLookMode;

/**
 * In this event, the pawn will get his movement physics, camera offset and controller.
 */
simulated event PostBeginPlay(){
	super.PostBeginPlay();
	spawnDefaultController();
	setCameraOffset( 0.0 , 0.0 , 44.0 );
	SetMovementPhysics();
	`log("IK SPEEL SOUND UIT " $self.SoundGroupClass);
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
	if ( bLookMode ){
		self.SetRotation( newRotation );
	}
	//else{
	//	Controller.SetRotation( newRotation );
	//}

    if (Trace(HitLocation, HitNormal, out_CamLoc, Location, false, vect(12, 12, 12)) != none)
    {
        out_CamLoc = HitLocation;
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

simulated exec function turnLeft(){
	`log( self$" TurnLeft" );
}

simulated exec function turnRight(){
	`log( self$" TurnRight" );
}

DefaultProperties
{
	MaxFootstepDistSq=9000000.0
	health = 100
	healthMax = 100
	healthRegeneration = 0
	mana = 0
	manaMax = 0
	manaRegeneration = 0
	meleeRange = 100.0
	physicalResistance = 0.0
	magicResistance = 0.0
	walkingSpeed = 100.0
	detectionRange = 1024.0
	regenerationTimer = 1.0;


	
	SoundGroupClass=class'Delmor.DELPlayerSoundGroup'

	camOffsetDistance = 300.0
	camPitch = -5000.0
	bLookMode = false

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
	//ArmsMesh[0] = none
	//ArmsMesh[1] = none
}