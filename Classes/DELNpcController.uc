/**
 * Abstract controller that contains a few combat functions.
 * ALL NPCControllers SHOULD BE EXTENDED FROM THIS ONE!
 * @author Anders Egberts
 */
class DELNpcController extends Controller
	abstract;

/**
 * When in attack-state. The pawn should strive to attack this pawn.
 */
var DELPawn attackTarget;

state Attack{
	function beginState( Name previousStateName ){
		super.beginState( previousStateName );
	}

	event tick( float deltaTime ){
		//Move to our target (Should stop when target is whitin range.
		moveTowardsActor( attackTarget , deltaTime );
		
		//If the target is whitin range call targetInRange(), which in turn starts the melee attack pipe-line.
		if ( checkTargetWhitinRange( attackTarget ) ){
			targetInRange();
		}
	}

	/**
	 * Called when the target whitin the pawn's attack range.
	 */
	event targetInRange(){
		`log( self$" Target In Range" );
		//Don't attack while moving, set the pawn still.
		stopPawn();
		meleeAttack();
	}
}

/**
 * Starts the meleeAttack pipeline.
 */
function meleeAttack(){
	`log( self$" MeleeAttack" );

	//TODO: Melee attack
}

/**
 * This function should move a pawn towards a given actor.
 * @param a         Actor   The actor to move to.
 * @param deltaTime float   The deltaTime from the Tick-event
 */
function moveTowardsActor( Actor a , float deltaTime ){
	moveTowards( a.Location , deltaTime );
}

/**
 * This functions should move the controller's pawn towards a given point.
 * NOTE: This function is to be used ONLY in the Tick-event!
 * @param l         Vector  The location to where the pawn should move.
 * @param deltaTime float   The deltaTime from the Tick-event
 */
function moveTowards( Vector l , float deltaTime ){
	local Vector selfToPoint;
	local DELPawn dPawn;

	//We'll have to cast it so we can use the walkingSpeed variable of DELPawn.
	dPawn = DELPawn( Pawn );
	
	//Caluclate direction
	selfToPoint = l - Pawn.Location;

	//Move Pawn
	Pawn.velocity = Normal( selfToPoint ) * dPawn.walkingSpeed;
	Pawn.setRotation( rotator( selfToPoint ) );
	Pawn.move( Pawn.velocity * deltaTime );
}

/**
 * Checks whether a pawn is whitin the pawn's attack range.
 * Returns true when pawn is whitin range.
 * @param p DELPawn The pawn that should be whitin range.
 * @return boolean.
 */
function bool checkTargetWhitinRange( DELPawn p ){
	local float distanceToPawn;
	local float attackRange; //TODO: Replace attackrange with actual DELPawn's weapon range.
	distanceToPawn = VSize( p.Location - Pawn.Location );
	
	if ( distanceToPawn > attackRange ){
		return false;
	}
	else{
		return true;
	}
}

/**
 * Sets the controller's pawn still.
 */
function stopPawn(){
	Pawn.Velocity.X = 0.0;
	Pawn.Velocity.Y = 0.0;
	Pawn.Velocity.Z = 0.0;
}

DefaultProperties
{
}
