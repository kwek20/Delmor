/**
 * Pawn class used for the goat.
 */
class DELGoatPawn extends DELAnimalPawn
      placeable
	  Config(Game);
var SoundCue goatSound;
var bool canPlaySound;
var int minGoatTime, maxGoatTime;

simulated function PostBeginPlay() {
	super.PostBeginPlay();
	assignSoundSet();
	`log(self);
	SetTimer((Rand(maxGoatTime-minGoatTime) + minGoatTime), true, 'playGoatSound');
	
}

/**
 * Assigns a soundSet to the pawn.
 */
private function assignSoundSet(){
	if ( mySoundSet != none ){
		mySoundSet.Destroy();
	}
	mySoundSet = spawn( class'DELSoundSetGoat' );
}

function playGoatSound() {
	PlaySound( goatSound );
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
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_goat'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Goat_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Goat_AnimTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.sk_goat_Physics'
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
	minGoatTime = 10
	maxGoatTime = 30

	ControllerClass=class'DELGoatController'
	GroundSpeed=50
	goatSound = SoundCue'Delmor_sound.Goat_cue'
}
