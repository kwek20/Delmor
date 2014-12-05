/**
 * Pawn class for the medium enemy
 * @author Bram
 */
class DELMediumMonsterPawn extends DELHostilePawn
      placeable
	  Config(Game);

/**
 * This soundset contains the pawn's voice
 */
var DELSoundSetMediumPawn mySoundSet;

simulated event PostBeginPlay(){
	super.PostBeginPlay();

	assignSoundSet();
}

/**
 * Assigns a soundSet to the pawn.
 */
private function assignSoundSet(){
	if ( mySoundSet != none ){
		mySoundSet.Destroy();
	}
	mySoundSet = spawn( class'DELSoundSetMediumPawn' );
}

/**
 * Say a line from the sound set. Only one sound can be played per 2 seconds.
 */
function say( String dialogue ){
	if ( mySoundSet.bCanPlay ){
		mySoundSet.PlaySound( mySoundSet.getSound( dialogue ) );
		mySoundSet.bCanPlay = false;
		mySoundSet.setTimer( 2.0 , false , nameOf( mySoundSet.resetCanPlay ) );
	}
}

defaultproperties
{
	ControllerClass=class'Delmor.DELMediumMonsterController'

	//Mesh
	Components.Remove(ThirdPersonMesh)
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimtreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		Scale3D=(X=1, Y=1, Z=1)
		HiddenGame=False
		HiddenEditor=False
		bHasPhysicsAssetInstance=True
		bAcceptsLights=true
		Translation=(Z=12.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)

	health = 150
	healthMax = 150
	healthRegeneration = 4
	walkingSpeed = 80.0
	detectionRange = 512.0

	mySoundSet = none
}