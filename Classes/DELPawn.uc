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

/*
 * =========================================
 * Animation
 * =========================================
 */

/**
 * Reference to the swing animation in the anim tree.
 */
var() const array<Name> SwingAnimationNames;
var AnimNodePlayCustomAnim SwingAnim;
var AnimNodePlayCustomAnim DeathAnim;

var array<name> animname;
var name deathAnimName;
var name knockBackAnimName;
/**
 * An int to point to the attack-animation array.
 */
var int attackNumber;

/**
 * In this event, the pawn will get his movement physics, camera offset and controller.
 */
simulated event PostBeginPlay(){
	super.PostBeginPlay(); 

	spawnDefaultController();
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
		DeathAnim = AnimNodePlayCustomAnim(SkelComp.FindAnimNode('DeathCustomAnim'));
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

	playknockBackAnimation();
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
}

/**
 * Play a die sound and dying animation upon death.
 */
function bool died( Controller killer , class<DamageType> damageType , vector HitLocation ){
	super.Died( killer , damageType , hitlocation );

	//Play died sound
	say( "Die" );
	goToState( 'Dead' );
	Controller.GotoState( 'Dead' );
	setTimer( 5.0 , false , 'destroyMe' );
	//Play death animation
	playDeathAnimation();
}

/**
 * Plays an attack animation.
 */
function playAttackAnimation(){
	SwingAnim.PlayCustomAnim(animname[ attackNumber ], 1.0 , 0.0 , 0.1f , false , true );
}

/**
 * Plays a death-animation.
 */
function playDeathAnimation(){
	SwingAnim.PlayCustomAnim(deathAnimName, 1.0 , 0.0 , 0.0 , false , true );
}

/**
 * Plays a knockdown-animation.
 */
function playKnockBackAnimation(){
	SwingAnim.PlayCustomAnim(knockBackAnimName, 1.0 , 0.0 , 0.0 , false , true );
}

/**
 * Removes the pawn and its controller from the level and memory.
 */
function destroyMe(){
	controller.Destroy();
	destroy();
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

/*
 * ========================================
 * States
 * ========================================
 */

/**
 * Used to override the die and takeDamage functions.
 */
state dead{
	/**
	 * Do nothing.
	 */
	function bool died( Controller killer , class<DamageType> damageType , vector HitLocation ){
		return false;
	}

	/**
	 * Do nothing.
	 */
	event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
	class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
		//Do nothing
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

	attackNumber = 0
}