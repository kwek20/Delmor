/**
 * Pawn class used for the goat.
 */
class DELChickenPawn extends DELAnimalPawn
      placeable
	  Config(Game);
var SoundCue kickSound;
var bool canPlaySound;

simulated function PostBeginPlay() {
	super.PostBeginPlay();
	assignSoundSet();
	`log(self);
}

/**
 * Assigns a soundSet to the pawn.
 */
private function assignSoundSet(){
	if ( mySoundSet != none ){
		mySoundSet.Destroy();
	}
	mySoundSet = spawn( class'DELSoundSetChicken' );
}

function kick() {
	if(canPlaySound) {
		say( "TakeDamage" );
		canPlaySound = false;
		SetTimer(0.5, false, 'resetPlaySound');
	}
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
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_chicken'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Chicken_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Chicken_animTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.chicken_Physics'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=-19.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	
	Begin Object Name=CollisionCylinder
	CollisionRadius = 22.0;
	CollisionHeight = +16.0;
	end object

	ControllerClass=class'DELChickenController'
	GroundSpeed=50
	kickSound = SoundCue'Delmor_sound.90132_killChicken_Cue'
}
