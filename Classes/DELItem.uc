class DELItem extends Actor abstract;

var() const int maxSize;

var() private string itemName;
var() private string itemDescription;
var() Texture2D texture, hoverTexture;
var() SoundCue pickupSound, useSound;
var() private int amount;
var() bool playerBound;
/**
 * The awesome Glow effect.
 */
var ParticleSystemComponent Glow;
/**
 * Gravity.
 */
var bool bIsFlying;
var float gravity;


simulated function PostBeginPlay() {
	super.PostBeginPlay();
	`log("SPAWNED ITEM"@self);

	bIsFlying = true;
	velocity.X = -200.0 + rand( 200.0 );
	velocity.Y = -200.0 + rand( 200.0 );
	velocity.Z = 300.0;
}

function int getAmount(){
	return amount;
}

function setAmount(int amount){
	if (amount < 0)amount=-1;
	self.amount=amount;
}

function String getDescription(){
	return itemDescription;
}

function String getName(){
	return itemName;
}

function bool isBound(){
	return playerBound;
}

event tick( float deltaTime ){
	processGravity( deltaTime );
}

/**
 * Simulates gravity.
 */
function processGravity( float deltaTime ){
	local vector floorLocation , offSet;

	if ( bIsFlying ){
		move( velocity * deltaTime );
		velocity.Z -= gravity;
		floorLocation = getFloorLocation( location );
		if ( location.Z <= floorLocation.Z ){
			offSet.Z = 5.0;
			setLocation( floorLocation + offSet );
			pseudLanded();
		}
	}
}

event pseudLanded(){
	bIsFlying = false;
	Glow.SetActive( true );
}

/**
 * Returns the location of the ground beneath the given location.
 */
function vector getFloorLocation( vector l ){
	local vector groundLocation , hitNormal , traceStart , traceEnd , defaultLoc;

	traceStart = location;
	traceStart.Z = location.z + 256.0;

	traceEnd = location;
	traceEnd.Z = location.z - 1024.0;

	defaultLoc = location;
	defaultLoc.Z = -100000.0;

	//Trace and get a ground location, that way the smoke will be placed on the ground and not the air.
	if ( Trace( groundLocation , hitNormal , traceEnd , l , false ) != none ){
		return groundLocation;
	}
	return defaultLoc;
}


/**
 * Picks up the item, putting it in the player's inventory.
 * @param picker    DELPawn The pawn that has picked up the item.
 */
function pickUp( DELPawn picker ){
	`log( "Picked up: "$self );
	picker.UManager.AddInventory( self.Class , getAmount() );
	spawnPickupEffect();
	destroy();
}

/**
 * Spawn a nice particle effect.
 */
function spawnPickupEffect(){
	local ParticleSystem p;
	local vector offSet;

	p = ParticleSystem'Delmor_Effects.Particles.p_item_pickup';
	offSet.Z = 15.0;

	worldInfo.MyEmitterPool.SpawnEmitter( p , location + offSet );
}

defaultproperties
{
	itemName="None"
	itemDescription="No description"
	texture=Texture2D'DelmorHud.freeze_spell'
	pickupSound=SoundCue'Delmor_sound.Pickup_Pop_Cue'
	amount=0
	playerBound=false
	maxSize=20

	Begin Object Class=ParticleSystemComponent Name=GlowEffect
		bAutoActivate=FALSE
		Template=ParticleSystem'Delmor_Effects.Particles.p_item'
		Translation=(X=0.0,Y=0.0,Z=15.0)
		SecondsBeforeInactive=1.0f
		Scale = 1.5
	End Object
	Glow=GlowEffect
	Components.Add(GlowEffect)

	gravity = 50.0
}
