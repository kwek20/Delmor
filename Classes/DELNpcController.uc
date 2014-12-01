/**
 * Abstract controller that contains a few combat functions.
 * ALL NPCControllers SHOULD BE EXTENDED FROM THIS ONE!
 * @author Anders Egberts
 */
class DELNpcController extends DELCharacterController;

/**
 * When in attack-state. The pawn should strive to attack this pawn.
 */
var DELPawn attackTarget;

/*
 * ==============================================
 * Action functions
 * ==============================================
 */

/**
 * In this state the NPC will chase it's target and attack if it's close enough.
 */
state Attack{
	function beginState( Name previousStateName ){
		super.beginState( previousStateName );
	}

	event tick( float deltaTime ){
		
		//If the target is whitin range call targetInRange(), which in turn starts the melee attack pipe-line.
		if ( checkTargetWhitinRange( attackTarget ) ){
			targetInRange();
		}
		else{
			moveTowardsActor( attackTarget , deltaTime ); //Move to our target (Should stop when target is whitin range.
		}

		//The attacktarget is gone, return to idle state.
		if ( !targetIsAlive() || targetIsTooFarAway() ){
			goToState( 'Idle' );
		}
	}

	/**
	 * Called when the target whitin the pawn's attack range.
	 */
	event targetInRange(){
		/**
		 * We'll adjust the location so the pawn will not point upwards or downwards when the player jumps.
		 */
		local vector adjustedLocation;
		//`log( self$" Target In Range" );
		//Don't attack while moving, set the pawn still.
		stopPawn();

		//Adjust the location so the pawns will not suddenly point upwards or downwards when the player jumps.
		adjustedLocation.X = attackTarget.location.X;
		adjustedLocation.Y = attackTarget.location.Y;
		adjustedLocation.Z = Pawn.Location.Z;

		//Turn pawn to the target
		Pawn.setRotation( rotator( adjustedLocation - Pawn.Location ) );

		meleeAttack();
	}
}

/*
 * ==============================================
 * Utility functions
 * ==============================================
 */

/**
 * Returns the distance between two points.
 */
function float distanceToPoint( vector l ){
	return VSize( pawn.Location - l );
}

/**
 * Checks whether a pawn is whitin the pawn's attack range.
 * Returns true when pawn is whitin range.
 * @param p DELPawn The pawn that should be whitin range.
 * @return boolean.
 */
function bool checkTargetWhitinRange( DELPawn p ){
	local float distanceToPawn;
	distanceToPawn = VSize( p.Location - Pawn.Location );
	
	if ( distanceToPawn > DELPawn( pawn ).meleeRange ){
		return false;
	}
	else{
		return true;
	}
}

/**
 * Returns true if the pawn exists and has more than one health.
 */
function bool targetIsAlive(){
	if ( attackTarget.health > 0 && attackTarget != none ){
		return true;
	}
	else{
		return false;
	}
}

/**
 * Returns true when attackTarget is too far away.
 */
function bool targetIsTooFarAway(){
	local float distanceToPawn;

	distanceToPawn = VSize( attackTarget.Location - Pawn.Location );

	if( distanceToPawn > DELPawn( Pawn ).detectionRange && !pawn.LineOfSightTo( attackTarget ) ){
		return true;
	}
	else{
		return false;
	}
}

/**
 * Returns whether the controller is in a combat-related state.
 * Combat states are (Amongst others): Attack, Keep distance, flee.
 * States that won't be seen as combat states are: Idle, Flock, Wander.
 */
function bool isInCombatState(){
	if ( isInState( 'attack' )
	|| isInState( 'flee' )
	|| isInState( 'maintainDistanceFromPlayer' )
	){
		return true;
	}
	else{
		return false;
	}
}

/*
 * ==============================================
 * Action functions
 * ==============================================
 */

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
	moveTowardsPoint( a.Location , deltaTime );
}

/**
 * This functions should move the controller's pawn towards a given point.
 * NOTE: This function is to be used ONLY in the Tick-event!
 * @param l         Vector  The location to where the pawn should move.
 * @param deltaTime float   The deltaTime from the Tick-event
 */
function moveTowardsPoint( Vector l , float deltaTime ){
	local Vector selfToPoint;
	local DELPawn dPawn;
	/**
	 * We'll adjust the location so the pawn will not point upwards or downwards when the player jumps.
	 */
	local Vector adjustedLocation;

	//We'll have to cast it so we can use the walkingSpeed variable of DELPawn.
	dPawn = DELPawn( Pawn );

	adjustedLocation.X = l.X;
	adjustedLocation.Y = l.Y;
	adjustedLocation.Z = Pawn.Location.Z;
	
	//Caluclate direction
	selfToPoint = adjustedLocation - Pawn.Location;

	//Move Pawn
	Pawn.velocity.X = Normal( selfToPoint ).X * dPawn.walkingSpeed;
	Pawn.velocity.Y = Normal( selfToPoint ).Y * dPawn.walkingSpeed;
	Pawn.setRotation( rotator( selfToPoint ) );
	Pawn.move( Pawn.velocity * deltaTime );
}

/**
 * Move the pawn in a certain direction.
 * This direction will be calculated from a vector.
 * NOTE: This function is to be used ONLY in the Tick-event!
 * @param to   Vector A vector between to points (i.e.: selfToPlayer ).
 * @param deltaTime float   The deltaTime from the Tick-event
 */
function moveInDirection( vector to , float deltaTime ){
	local rotator adjustedRotation;

	//Adjust the rotation so that only the Yaw will be modified.
	adjustedRotation.Pitch = Pawn.Rotation.Pitch;
	adjustedRotation.Roll = Pawn.Rotation.Roll;
	adjustedRotation.Yaw = rotator( to ).Yaw;

	//Move Pawn
	Pawn.velocity.X = Normal( to ).X * DELPawn( pawn ).walkingSpeed;
	Pawn.velocity.Y = Normal( to ).Y * DELPawn( pawn ).walkingSpeed;
	Pawn.setRotation( adjustedRotation  );
	Pawn.move( Pawn.velocity * deltaTime );
}

/**
 * Sets the controller's pawn still.
 */
function stopPawn(){
	//www`log( self$" Stop pawn" );
	Pawn.Velocity.X = 0.0;
	Pawn.Velocity.Y = 0.0;
	//Pawn.Velocity.Z = 0.0;
}

DefaultProperties
{
}
