/**
 * Pawn class used for the goat.
 */
class DELCowPawn extends DELAnimalPawn
      placeable
	  Config(Game);
var SoundCue cowSound;
var bool canPlaySound;
var int minCowTime, maxCowTime;

simulated function PostBeginPlay() {
	super.PostBeginPlay();
	assignSoundSet();
	`log(self);
	SetTimer((Rand(maxCowTime-minCowTime) + minCowTime), true, 'playCowSound');
	
}

/**
 * Assigns a soundSet to the pawn.
 */
private function assignSoundSet(){
	if ( mySoundSet != none ){
		mySoundSet.Destroy();
	}
	mySoundSet = spawn( class'DELSoundSetCow' );
}

function playCowSound() {
	PlaySound( cowSound );
}

function kick() {
	if(canPlaySound) {
		say( "TakeDamage" );
		canPlaySound = false;
		SetTimer(0.5, false, 'resetPlaySound');
	}
	//Run away from the player after being kicked.
	DELCowController( controller ).FleeFrom( DELPlayer( GetALocalPlayerController().Pawn ) );
}

function resetPlaySound() {
	canPlaySound = true;
}

/**
 * The mesh for the Goat and his speed.
 */
DefaultProperties
{
	canPlaySound = true;
	Components.Remove(ThirdPersonMesh);
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_cow'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Cow_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Cow_animtree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.sk_cow_Physics'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=-28.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	
	Begin Object Name=CollisionCylinder
	CollisionRadius = 44.0;
	CollisionHeight = +32.0;
	end object
	minCowTime = 10
	maxCowTime = 30

	ControllerClass=class'DELCowController'
	GroundSpeed=50
	cowSound = SoundCue'Delmor_sound.Cow_cue'
}
