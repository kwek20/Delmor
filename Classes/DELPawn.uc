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

/**
 * How long the gettingHit animation is in seconds.
 */
var float getHitTime;

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

/**
 * The sound to play when taking damage.
 */
var SoundCue hitSound;

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
var name getHitAnimName;
var name blockAnimName;
/**
 * The time in an attack animation when the swing should hit the player.
 */
var array<float> attackAnimationImpactTime;
/**
 * An int to point to the attack-animation array.
 */
var int attackNumber;

var() Texture2D healthBar, manaBar, edge;

/**
 * If this Pawn has been hit recently
 */
var bool hit;

/**
 * The time in seconds a pawn stays hit
 */
var int hitTime;

/**
 * The length and width of a health bar
 */
var float barLength, barWidth;


/**
 * In this event, the pawn will get his movement physics, camera offset and controller.
 */
simulated event PostBeginPlay(){
	super.PostBeginPlay(); 

	spawnDefaultController();
	SetMovementPhysics();

	SetTimer( 1.0 , true , nameOf( regenerate ) ); 

	 //Set up custom inventory manager
     if (UInventory != None){
		UManager = Spawn(UInventory, Self);
		if ( UManager == None )
			`log("Warning! Couldn't spawn InventoryManager" @ UInventory @ "for" @ Self @  GetHumanReadableName() );
	}

	AddDefaultInventory();
}

event tick( float deltaTime ){
	super.tick( deltaTime );

	blockActorsAgain();

	//Sometimes the controller gets destroyed for no reason, spawn it again.
	/*if ( controller == none && !isInState( 'Dead' ) ){
		`log( "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" );
		`log( "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" );
		`log( "#####################################################" );
		`log( "SPAWNED A NEW CONTROLLER" );
		`log( "#####################################################" );
		`log( "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" );
		`log( "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" );
		SpawnDefaultController();
	}*/
}

/**
 * Process the damage and kill the pawn if the health is smaller than 0.
 */
function ProcessDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	if ( !isInState( 'Dead' ) ){
		health -= Damage;
	
		DELNPCController( controller ).pawnTookDamage( DamageCauser );
		hit = true;
		SetTimer( hitTime, false, 'hitOff' );

		if ( health < 0 ){
			self.Died( none , DamageType , HitLocation );
		}
	}
}
/**
 * If the bBlockActors = false, check if there's no pawn and we're not being knockedBack
 * if so, set bBlockActors to true.
 */
function blockActorsAgain(){
	if ( !bBlockActors ){
		if ( !IsInState( 'knockedBack' )  && !IsInState( 'Dead' ) ){
			if ( true ){
				bBlockActors = true;
			}
		}
	}
}

/**
 * Returns true when there are no pawns (other than him self) in the pawn's collisionRadius.
 */
function bool noPawnsInCollisionRadius(){
	local DELPawn p;

	foreach worldInfo.AllPawns( class'DELPawn' , p , location , GetCollisionRadius() * 2 ){
		if ( CheckSphereCollision( self.location , GetCollisionRadius() , p.Location , p.GetCollisionRadius() ) ){
			return false;
		}
	}
	return true;
}

function drawBar(Canvas c, float x, float y, float length, float width, DELPawn pawn, Texture2D bar, optional Texture2D edge, optional float U = 0.f, optional float V = 0.f){
	c.SetPos(x, y);  
	c.DrawTile(bar, length * (float(pawn.Health) / float(pawn.HealthMax)),width, U, V, bar.SizeX, bar.SizeY);

	if (edge != None){
		c.SetPos(x-1, y-1);   
		c.SetDrawColor(255,255,255,255);
		c.DrawTile(edge, length*1.15, width*1.6+2, U, V, edge.SizeX, edge.SizeY);
	}
}

/**
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
 * When taking damage, notify the controller.
 */
event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser ){
	super.TakeDamage( damage , InstigatedBy , HitLocation , Momentum , DamageType , HitInfo , DamageCauser );
	DELNPCController( controller ).pawnTookDamage( DamageCauser );
	hit=true;
	SetTimer(hitTime, false, 'hitOff');
}

function hitOff(){hit=false;}

/**
 * Spawn a blood effect to indicate that the pawn has been hit..
 */
function spawnBlood( vector hitlocation ){
	local ParticleSystem p;
	local rotator spawnRot;

	p = ParticleSystem'Delmor_Character.Particles.p_blood_squib';

	spawnRot = rotator( hitlocation - location );
	worldInfo.MyEmitterPool.SpawnEmitter( p , hitlocation , spawnRot );
}

/**
 * Spawn the smoke that should appear after being knocked back.
 */
function spawnLandSmoke(){
	local ParticleSystem p;
	p = ParticleSystem'Delmor_Character.Particles.p_land_smoke';

	worldInfo.MyEmitterPool.SpawnEmitter( p , location );
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
		DELNPCController( Controller ).changeState( 'Blocking' );
	}
	interrupt();
	playBlockingAnimation();
}

/**
 * Stop blocking by going into the LandMovementState
 */
function stopBlocking(){
	DELNpcController( controller ).returnToPreviousState();
	returnToPreviousState();
}

/**
 * Sets bCanBlock to true.
 */
function resetCanBlock(){
	bCanBlock = true;
}

/**
 * Stuns the pawn for a given time.
 * @param duration	float    How long the stun lasts in seconds.
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
	controller.goToState( 'Idle' );
}

/**
 * Regenerates health and mana.
 */
private function regenerate(){
	if ( !isInState( 'Dead' ) ){
		health = Clamp( health + healthRegeneration , 0 , healthMax );
		mana = Clamp( mana + manaRegeneration , 0 , manaMax );
	}
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
 * @param intensity     float   The power of the knockback. The higher the intensity the more the pawn should be knocked back.
 * @param direction     Vector  The vector that will be the direction (i.e.: selfToPlayer, selfToPawn ).
 * @param bNoAnimation  bool    When true, the knockback animation will NOT be played.
 */
function knockBack( float intensity , vector direction , optional bool bNoAnimation ){
	spawnKnockBackForce( intensity , direction );
	controller.goToState( 'KnockedBack' );
	//goToState( 'KnockedBack' );
	bBlockActors = false;

	if ( !bNoAnimation ){
		playknockBackAnimation();
	}

	interrupt();
}

/**
 * Spawns the knockbackforce and assigns some variables to it.
 * @param intensity float   The power of the knockback. The higher the intensity the more the pawn should be knocked back.
 * @param direction Vector  The vector that will be the direction (i.e.: selfToPlayer, selfToPawn ).
 */
function spawnKnockBackForce( float intensity , vector direction ){
	local DELKnockbackForce knockBack;
	knockBack = spawn( class'DELKnockbackForce' );
	knockBack.setPower( intensity );
	knockBack.myPawn = self;
	knockBack.direction = direction;
	knockBack.beginZ = location.Z;
	if ( controller.IsChildState( controller.GetStateName() , 'NonMovingState' ) ){
		knockBack.pawnsPreviousState = DELNPCcontroller( controller ).getPreviousState();
	}
	else{
		knockBack.pawnsPreviousState = controller.GetStateName();
	}
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
 * Changes the state if the pawn is not dead.
 * @param newState  Name    The name of the new state.
 */
function changeState( Name newState ){
	if ( !IsInState( 'Dead' ) ){
		goToState( newState );
	}
}

/**
 * Performs an attack by playing an animation and setting a timer, when the timer finishes, actual damage will be dealt.
 */
function attack(){
	if ( !controller.IsInState( 'Attacking' ) ){
		playAttackAnimation();
		controller.goToState( 'Attacking' );
		setTimer( attackInterval + 0.2 , false , 'resetAttackCombo' ); //Reset the attack combo if not immidiatly attacking again.
		setTimer( attackAnimationImpactTime[ attackNumber ] , false , 'dealAttackDamage' ); //A short delay before dealing actual damage.
		increaseAttackNumber();
		say( "AttackSwing" );
	}
}

/**
 * Renders the pawn unable to attack for a very short time and plays the gettingHit animation.
 */
function getHit(){
	playGetHitAnimation();
	controller.goToState( 'GettingHit' );
	controller.SetTimer( getHitTime , false , 'returnToPreviousState' ); //Reset the attack combo if not immidiatly attacking again.
	interrupt();
}

/**
 * Interrupts any attack that the pawn was performing.
 */
function interrupt(){
	Velocity.X = 0.0;
	Velocity.Y = 0.0;
	Velocity.Z = 0.0;
	ClearTimer( 'dealAttackDamage' ); //Reset this function so that the pawn's attack will be interrupted.
	DELNPCController( controller ).returnToPreviousState();
}

/**
 * Play a die sound and dying animation upon death.
 */
function bool died( Controller killer , class<DamageType> damageType , vector HitLocation ){
	//super.Died( killer , damageType , hitlocation );

	if ( !isInState( 'Dead' ) ){
		//Make it so that the player can walk over the corpse and will not be blocked by the collision cylinder.
		bBlockActors = false;
		bCollideWorld = true;

		//Stop friggin rotatin'
		SetRotation( rotation );
		SetDesiredRotation( rotation , true , false , 0.0 , true );
		ResetDesiredRotation();
		interrupt();

		//Play died sound
		say( "Die" , true );
		Controller.pawnDied( self );
		setTimer( 5.0 , false , 'destroyMe' );
		//Play death animation
		playDeathAnimation();
		goToState( 'Dead' );
	}
}

/**
 * Transforms the pawn into a given class.
 * Hitpoint percentage, rotation and location will be preserved.
 * @param toTransformInto   class<DELPawn> The class to transform into.
 */
function shapeShift( class<DELPawn> toTransformInto ){
	local DELPawn p;

	p = spawn( toTransformInto , , , , , , true );
	p.health = ( p.healthMax / healthMax ) * health;
	p.setRotation( rotation );
	p.setLocation( location );
	//Stop blocking actors; if the monster transforms while the player
	//is near, the player dies if the collides with the new pawn.
	p.bBlockActors = false;

	//Remove old pawn from memory.
	controller.Destroy();
	destroy();
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
	SwingAnim.PlayCustomAnim(knockBackAnimName, 1.0 , 1.0 , 0.0 , false , true );
}

/**
 * Plays a get hit animation.
 */
function playGetHitAnimation(){
	SwingAnim.PlayCustomAnim(getHitAnimName, 1.0 , 0.0 , 0.0 , false , true );
}

/**
 * Plays a get hit animation.
 */
function playBlockingAnimation(){
	SwingAnim.PlayCustomAnim(blockAnimName, 1.0 , 0.0 , 0.0 , false , true );
}

/**
 * Removes the pawn and its controller from the level and memory.
 */
function destroyMe(){
	//controller.Destroy();
	spawnDespawnEffect();
	destroy();
}

/**
 * Creates a particle effect that will be shown when the pawn's corps is deleted.
 */
function spawnDespawnEffect(){
	local ParticleSystem p;
	//local rotator spawnRot;
	//local UTParticleSystemComponent psc;

	p = ParticleSystem'Delmor_Character.Particles.p_flash';
	//psc.SetTemplate( p );

	//psc.ActivateSystem();
	//spawnRot = rotator( location - hitlocation );
	worldInfo.MyEmitterPool.SpawnEmitter( p , getASocketsLocation( 'FlashSocket' ) );
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
 * @param dialoge   String  A text representation of what to say. An adapter in the soundset will look for the appropriate soundcue.
 * @param bForce    bool    Play the sound even if bCanPlay = false.
 */
function say( String dialogue , optional bool bForce ){
	//`log( ">>>>>>>>>>>>>>>>>>>> "$self$" said something ( "$dialogue$" )" );
	if ( mySoundSet != none && ( mySoundSet.bCanPlay || bForce ) ){
		mySoundSet.PlaySound( mySoundSet.getSound( dialogue ) );
		mySoundSet.bCanPlay = false;
		mySoundSet.setTimer( 0.5 , false , nameOf( mySoundSet.resetCanPlay ) );
	}
}

/*
 * ========================================
 * Attacking
 * ========================================
 */

/**
 * Deal damage from the melee attack to any pawn in front of this pawn.
 */
function dealAttackDamage(){
	local pawn hitPawn;
	local int damage;
	local vector momentum;

	hitPawn = checkPawnInFront();
	damage = DELMeleeWeapon( sword ).CalculateDamage();

	if ( hitPawn != none ){
		hitPawn.TakeDamage( damage , Instigator.Controller , ( location + hitPawn.Location ) / 2 , momentum , class'DELDmgTypeMelee' , , self );
	}
}

/**
 * Return the player's position plus 16 in the player's direction.
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

	newLocation.X = location.X + lengthDirX( meleeRange , -useYaw );
	newLocation.Y = location.Y + lengthDirY( meleeRange , -useYaw );
	newLocation.Z = Location.Z;

	return newLocation;
}

/**
 * Returns a pawn when it is in front of this pawn.
 */
function Pawn checkPawnInFront(){
	local controller c;
	local vector inFrontLocation;
	local float checkDistance;
	local pawn hitPawn;
	local float averageHeight;

	inFrontLocation = getInFrontLocation();
	checkDistance = meleeRange + GetCollisionRadius();

	foreach WorldInfo.AllControllers( class'controller' , c ){
		if ( VSize( Location - c.Pawn.Location ) < checkDistance + c.Pawn.GetCollisionRadius() && c.Pawn != self ){
			if ( CheckCircleCollision( inFrontLocation , GetCollisionRadius() , c.Pawn.Location , c.Pawn.GetCollisionRadius() ) && hitPawn.Class != class'DELPlayer' ){
				hitPawn = c.Pawn;
			}
		}
	}
	
	return hitPawn;
}

/**
 * Sets the attack number to 0
 */
function resetAttackCombo(){
	attackNumber = 0;
}

/*
 * ========================================
 * States
 * ========================================
 */

state NonMovingState{
	local name previousState;

	function beginState( name PreviousStateName ){
		super.beginState( PreviousStateName );

		previousState = PreviousStateName;
	}

	function returnToPreviousState(){
		goToState( previousState );
	}
}

function returnToPreviousState(){
	goToState( LandMovementState );
}
/**
 * Used to override the die and takeDamage functions.
 */
state Dead extends NonMovingState{
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

	/**
	 * Overriden so that the pawn can't come back to life after dying.
	 */
	//final function changeState( optional name newState , optional name Label , optional bool bForceEvents , optional bool bKeepStack ){
	//}
}

state Blocking extends NonMovingState{
}

/**
 * This function calculates a new x based on the given direction.
 * @param   dir Float   The direction in UnrealDegrees.
 */
function float lengthDirX( float len , float dir ){
	local float Radians;
	Radians = UnrRotToRad * dir;
	return len * cos( Radians );
}

/**
 * This function calculates a new y based on the given direction.
 * @param   dir Float   The direction in UnrealDegrees.
 */
function float lengthDirY( float len , float dir ){
	local float Radians;
	Radians = UnrRotToRad * dir;

	return len * -sin( Radians );
}

/**
 * Checks whether two spheres (3D circles) collide. Useful for collision-checking between Pawns.
 * @return bool
 */
function bool CheckSphereCollision( vector circleLocationA , float circleRadiusA , vector circleLocationB , float circleRadiusB ){
	local float distance , totalRadius;

	distance = VSize( circleLocationA - circleLocationB );
	totalRadius = circleRadiusA + circleRadiusB;

	if ( distance <= totalRadius ){
		return true;
	} else {
		return false;
	}
}
/**
 * Checks whether two circles collide. Useful for collision-checking between Pawns.
 * @return bool
 */
function bool CheckCircleCollision( vector circleLocationA , float circleRadiusA , vector circleLocationB , float circleRadiusB ){
	local float distance , totalRadius;
	local vector lA , lB;

	lA.X = circleLocationA.X;
	lA.Y = circleLocationA.Y;

	lB.X = circleLocationB.X;
	lB.Y = circleLocationB.Y;

	distance = VSize( lA - lB );
	totalRadius = circleRadiusA + circleRadiusB;

	if ( distance <= totalRadius ){
		return true;
	} else {
		return false;
	}
}

/**
 * Returns to location of a socket in the pawn's mesh.
 * @param socketName    name    The name of the socket.
 */
function vector getASocketsLocation( name socketName ){
	local vector SocketLocation;
	//if ( Mesh.class != SkeletalMeshComponent ){
	//	SkeletalMeshComponent( Mesh ).GetSocketWorldLocationAndRotation( socketName , SocketLocation );
	//} else {
		Mesh.GetSocketWorldLocationAndRotation( socketName , SocketLocation );
	//}
	return SocketLocation;
}

/**
 * Adjusts a given location so that it's z-variable will be set to a given value while ignoring
 * the other values.
 * Useful for locking z-values.
 */
function vector adjustLocation( vector inLocation , float targetZ ){
	local vector newLocation;

	newLocation.X = inLocation.X;
	newLocation.Y = inLocation.Y;
	newLocation.Z = targetZ;

	return newLocation;
}

/**
 * Adjust a rotation so that it's yaw-value will be locked to a given value.
 */
function rotator adjustRotation( rotator inRotation , float targetYaw ){
	local rotator adjustedRotation;

	adjustedRotation.Pitch = inRotation.Pitch;
	adjustedRotation.Roll = inRotation.Roll;
	adjustedRotation.Yaw = targetYaw;

	return adjustedRotation;
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

	swordClass = class'DELMeleeWeaponFists'

	ArmsMesh[0] = none
	ArmsMesh[1] = none

	mySoundSet = none

	attackNumber = 0
	getHitTime = 1.0

	healthBar=Texture2D'DelmorHud.health_balk'
	manaBar=Texture2D'DelmorHud.mana_balk'
	edge=Texture2D'DelmorHud.bar_edge'

	hitTime=5
	barLength=50
	barWidth=10

	hitSound = SoundCue'Delmor_sound.Weapon.sndc_sword_monster_impact'
}