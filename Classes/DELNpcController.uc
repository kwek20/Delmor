class DELNpcController extends Controller;

/**
 * When in attack-state. The pawn should strive to attack this pawn.
 */
var DELPawn attackTarget;

state Idle{
	function beginState( Name previousStateName ){
		super.beginState( previousStateName );
	}

	event tick( float deltaTime ){
		//Move to our target (Should stop when target is whitin range.
		moveTowardsActor( attackTarget );
		
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
 * @param a Actor   The actor to move to.
 */
function moveTowardsActor( Actor a ){
	moveTowards( a.Location );
}

/**
 * This functions should move the controller's pawn towards a given point.
 * @param l Vector  The location to where the pawn should move.
 */
function moveTowards( Vector l ){
	//TODO: Move towards the target.
}

/**
 * Checks whether a pawn is whitin the pawn's attack range.
 * Returns true when pawn is whitin range.
 * @param p DELPawn The pawn that should be whitin range.
 * @return boolean.
 */
function bool checkTargetWhitinRange( DELPawn p ){
	//TODO business logic.
	return false;
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
