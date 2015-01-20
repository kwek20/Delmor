/**
 * This class will move a pawn through the air without changing said pawn's velocity.
 * When the pawn hits the ground it should be destroyed.
 */
class DELKnockbackForce extends Actor;

/**
 * The pawn that will be affected by the knockback force.
 */
var DELPawn myPawn;
/**
 * The power of the force.
 */
var float power;
/**
 * The amount to modify the pawn's z-location with.
 */
var float zPower;
/**
 * The direction (yaw) that the force will work in.
 */
var vector direction;
/**
 * Ground height, when the pawn hits the ground the force should be destroyed.
 */
var float beginZ;

var float gravity;

/**
 * When the pawn has landed it will standup. Forces will no longer be applied.
 */
var bool bLanded;

/**
 * Number of seconds passed since the knockback began.
 */
var float timePassed;

/**
 * When landed, set the pawn's controller's state back to this state.
 */
var name pawnsPreviousState;

event Tick( float deltaTime ){
	local vector newLocation , HitLocation, HitNormal;

	if ( myPawn == none ){
		destroy();
	}

	timePassed += deltaTime; 

	if ( bLanded ) return;
	
	//Move the pawn
	newLocation.X = myPawn.location.X + ( power * normal( direction ).X * deltaTime );
	newLocation.Y = myPawn.location.Y + ( power * normal( direction ).Y * deltaTime );
	newLocation.Z = myPawn.location.Z + ( zPower * deltaTime );
	
	SetCollisionSize( myPawn.GetCollisionRadius() , myPawn.GetCollisionHeight() );

	//Collide with brushes
	if (Trace(HitLocation, HitNormal, newLocation, myPawn.location , false, vect(0.0, 0.0, 0.0)) != none ){
		//The pawn collided, the force will be stopped now.
		myPawn.setLocation( HitNormal/*adjustLocation( HitNormal , newLocation.Z )*/ );
		endForce();
	}

	myPawn.velocity = normal( newLocation - myPawn.Location ) * power * deltaTime;
	myPawn.move( myPawn.velocity );

	//We've hit the ground
	if ( myPawn.location.Z <= beginZ + 2.0 && zPower <= 0.0 ){
		endForce();
	}

	//Gravity
	zPower -= gravity;
}

/**
 * Sets the power and zPower.
 */
function setPower( float inPower ){
	power = inPower;
	zPower = inPower * 2.0;
}

/**
 * IS NOW "LANDED", The pawn has hit the ground, determine what to do next.
 */
function endForce(){
	if ( zPower < 100.0 ){
		myPawn.spawnLandSmoke();
	}

	bLanded = true;
	
	if ( myPawn.bHasSplittedKnockbackAnim ){
		myPawn.ClearTimer( 'playKnockBackDownAnimation' );
		setTimer( myPawn.knockBackStandupAnimLength , false , 'standup' );
		if ( !myPawn.isInState( 'Dead' ) ){ myPawn.playKnockBackStandUpAnimation(); }
	}
	else {
		if ( timePassed >= myPawn.knockBackAnimLength ){
			standup();
		} else {
			setTimer( myPawn.knockBackAnimLength - timePassed , false , 'standup' );
		}
	}
}

/**
 * Returns to previous-state and destroys the force effects.
 */
function standup(){
	if ( pawnsPreviousState != '' ){
		myPawn.controller.goToState( pawnsPreviousState );
	} else {
		myPawn.controller.goToState( 'Idle' );
	}
	//DELNpcController( myPawn.controller ).returnToPreviousState();
	//myPawn.returnToPreviousState();
	destroy();
}
/**
 * Adjusts a given location so that it's z-variable will be set to a given value while ignoring
 * the other values.
 * Useful for locking z-values.
 */
private function vector adjustLocation( vector inLocation , float targetZ ){
	local vector newLocation;

	newLocation.X = inLocation.X;
	newLocation.Y = inLocation.Y;
	newLocation.Z = targetZ;

	return newLocation;
}

DefaultProperties
{
	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius = 32.0
		CollisionHeight = +32.0
	end object

	gravity = 65.0
	zPower = 800.0
}
