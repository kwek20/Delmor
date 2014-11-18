/**
 * This DELPawn will later later split in to the monsters that the player has to defeat and the NPCs that
 * the player can talk to.
 * So MonsterPawns and VillagerPawns will both inherit from DELPawn.
 */
class DELPawn extends UTPawn;

/**
 * The maximum angle of the camera.
 */
var const int isoCamAngle;
/**
 * Distance of the camera to this pawn.
 */
var const float camOffsetDistance;
/**
 * The pitch of the camera.
 */
var float camPitch;

simulated event PostBeginPlay(){
	SetCamera();
}

/**
 * This function should set the third person camera.
 */
function SetCamera(){
	`log( "Set third person camera" );
	//self.SetThirdPersonCamera( true );
	SetMeshVisibility( true );
}

/**
 * Calculates a new camera position based on the postition of the pawn.
 */
simulated function bool CalcCamera(float DeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV)
{
    local Vector HitLocation, HitNormal;

    out_CamLoc = Location;
    out_CamLoc.X -= Cos(Rotation.Yaw * UnrRotToRad) * Cos(camPitch * UnrRotToRad) * camOffsetDistance;
    out_CamLoc.Y -= Sin(Rotation.Yaw * UnrRotToRad) * Cos(camPitch * UnrRotToRad) * camOffsetDistance;
    out_CamLoc.Z -= Sin(camPitch * UnrRotToRad) * camOffsetDistance;

    out_CamRot.Yaw = Rotation.Yaw;
    out_CamRot.Pitch = camPitch;
    out_CamRot.Roll = 0;

    if (Trace(HitLocation, HitNormal, out_CamLoc, Location, false, vect(12, 12, 12)) != none)
    {
        out_CamLoc = HitLocation;
    }

    return true;
}

DefaultProperties
{
	isoCamAngle = 45
	camOffsetDistance = 250.0

	//Mesh
	Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'UTExampleCrowd.Mesh.SK_Crowd_Robot'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimtreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		//Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
	End Object
	Mesh=SkeletalMeshComponent0
    Components.Add(SkeletalMeshComponent0)
}