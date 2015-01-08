/**
 * Abstract controller that contains a few combat functions.
 * ALL NPCControllers SHOULD BE EXTENDED FROM THIS ONE!
 * @author Anders Egberts
 */
class DELNpcController extends DELCharacterController;

/**
 * A special variable to save the player-pawn in.
 */
var DELPlayer player;
/**
 * When in attack-state. The pawn should strive to attack this pawn.
 */
var DELPawn attackTarget;
/**
 * When fleeing, the pawn will try be this far away from the agressor.
 */
var float fleeDistance;
/**
 * When a pawn is closer the controller's pawn than this number, it will be "too close".
 */
var float tooCloseDistance;

/*
 * ==============================================
 * States
 * ==============================================
 */

event Possess( Pawn inPawn , bool bVehicleTransition ){
	super.Possess( inPawn , bVehicleTransition );
}

/**
 * Called when the pawn took damage.
 */
event pawnTookDamage( optional Actor DamageCauser ){
	`log( "!!!!!!!!!!!!!!!!!!!!!!" );
	`log( "Being hit" ); 
	if ( DamageCauser != none ){
		if ( DamageCauser.IsA( 'DELPlayer' ) ){
			`log( "DELPlayer" );
			`log( "Retaliate" );
			attackTarget = DELPawn( DamageCauser );
			changeState( 'Attack' );
		}
		if ( DamageCauser.IsA( 'DELMagicProjectile' ) ){
			`log( "DELMagicProjectile" );
			`log( "Retaliate" );
			//Attack target will be set to the player since he's to only one who can cast magic in-game.
			attackTarget = findPlayer();
			changeState( 'Attack' );
		}
	}
}

auto state Idle{
	event Tick( float deltaTime ){

		super.Tick( deltaTime );

		if ( player == none ){
			//Find the player
			player = findPlayer();
			`log( "findPlayer: player: "$player );
		}
	}
}

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
		} else {
			moveTowardsPoint( attackTarget.location , deltaTime ); //Move to our target (Should stop when target is whitin range.
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
		adjustedLocation = adjustLocation( attackTarget.location , Pawn.Location.Z );

		//Turn pawn to the target
		Pawn.setRotation( rotator( adjustedLocation - Pawn.Location ) );

		meleeAttack();
	}
}

/**
 * Flee from the player
 */
state flee{

	event tick( float deltaTime ){
		local vector selfToPlayer;
		
		super.Tick( deltaTime );

		selfToPlayer = pawn.Location - player.location;

		if ( VSize( selfToPlayer ) < fleeDistance ){
			moveInDirection( selfToPlayer , deltaTime );
		}
		else{
			stopPawn();
		}
	}
}

/**
 * A state in which the pawn is not allowed to move on its own.
 */
state NonMovingState{
	local Rotator startingRotation;
	local name previousState;

	function beginState( name previousStateName ){
		super.BeginState( previousStateName );
		
		//Save the previous state in a variable.
		previousState = previousStateName;

		startingRotation = pawn.Rotation;
		pawn.SetDesiredRotation( startingRotation );
		stopPawn();
	}

	event Tick( float deltaTime ){
		pawn.SetRotation( startingRotation );
	}
	/**
	 * These functions are now made empty so that the pawn will not move while blocking.
	 * NOTE: This function is to be used ONLY in the Tick-event!
	 * @param l         Vector  The location to where the pawn should move.
	 * @param deltaTime float   The deltaTime from the Tick-event
	 */
	function moveTowardsPoint( Vector l , float deltaTime ){
	}

	/**
	 * These functions are now made empty so that the pawn will not move while blocking.
	 * @param to   Vector A vector between to points (i.e.: selfToPlayer ).
	 * @param deltaTime float   The deltaTime from the Tick-event
	 */
	function moveInDirection( vector to , float deltaTime ){
	}

	/**
	 * Returns to the previous state.
	 */
	function returnToPreviousState(){
		goToState( previousState );
	}

	/**
	 * Returns idle, but will return the previous state when in a nonmoving state.
	 */
	function name getPreviousState(){
		return previousState;
	}

}

/**
 * Empty state, will be filled in the NonMovingState-state
 */
function returnToPreviousState(){
}

state Blocking extends NonMovingState{
}

state GettingHit extends NonMovingState{
}

state knockedBack extends NonMovingState{
}

state Stunned extends NonMovingState{
}

/**
 * In this state the pawn is performing an actual attack (i.e.: sword swing).
 * The pawn is not allowed to move and the controller should return to it's previous state once the swing is done.
 */
state Attacking extends NonMovingState{
	function beginState( name previousStateName ){
		super.BeginState( previousStateName );

		//Set a timer to end the state.
		setTimer( DELPawn( pawn ).attackInterval , false , 'SwingFinished' );
	}

	function SwingFinished(){
		`log( "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& Swing Finished" );
		goToState( previousState );
	}
}

/*
 * ==============================================
 * Utility functions
 * ==============================================
 */

/**
 * Returns idle, but will return the previous state when in a nonmoving state.
 */
function name getPreviousState(){
	return 'Idle';
}

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
	distanceToPawn = VSize( adjustLocation( p.Location , pawn.Location.Z ) - Pawn.Location );
	
	if ( distanceToPawn > DELPawn( pawn ).meleeRange ){
		return false;
	} else {
		return true;
	}
}

/**
 * Returns true if the pawn exists and has more than one health.
 */
function bool targetIsAlive(){
	if ( attackTarget.health > 0 && attackTarget != none ){
		return true;
	} else {
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
	} else {
		return false;
	}
}

/**
 * Returns whether the controller is in a combat-related state.
 * Combat states are (Amongst others): Attack, Keep distance, flee.
 * States that won't be seen as combat states are: Idle, Flock, Wander.
 */
function bool isInCombatState(){
	if ( isInState( 'Attack' )
	|| isInState( 'Flee' )
	|| isInState( 'MaintainDistanceFromPlayer' )
	|| isInState( 'Charge' )
	){
		return true;
	} else {
		return false;
	}
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

/**
 * Checks whether a pawn to too close to this pawn.
 */
function bool tooCloseToPawn( DELPawn p ){
	if ( VSize( p.location - Pawn.Location ) < tooCloseDistance ){
		return true;
	}
	else
		return false;
}

/**
 * Get the player-pawn.
 */
function DELPlayer findPlayer(){
	local DELPlayer playerPawn;

	playerPawn = none;
	foreach WorldInfo.AllPawns( class'DELPlayer' , playerPawn ){
		return playerPawn;
	}
	return playerPawn;
}

/**
 * Same as GoToState exept this one will only change states
 * if the player variable is not null.
 */
function changeState( name newState ){
	if ( player != none ){
		goToState( newState );
	}
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
 * Checks whether the pawn collides and if so,
 * returns the instance of the pawn that the controller's
 * pawn collides with.
 * @return DELPawn
 */
function DELPawn checkCollision(){
	local Controller c;

	foreach WorldInfo.AllControllers( class'Controller' , c ){
		if ( distanceToPoint( c.Pawn.Location ) < 64.0 + self.Pawn.GetCollisionRadius() && c != self ){
			if ( DELPawn( pawn ).CheckCircleCollision( c.Pawn.Location , c.Pawn.GetCollisionRadius() + 4.0 , Pawn.Location , Pawn.GetCollisionRadius() + 4.0 )/* && c.Pawn.isA( class'DELPawn' )*/ ){
				return DELPawn( c.Pawn );
			}
		}
	}
	return none;
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
	DELPawn( pawn ).attack();
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
	local Vector tempDest;
	/**
	 * The next location to move. This will be tempDest if the NavMesh works
	 * succesful. It will be l if the NavMesh doesn't.
	 */
	local Vector nextMoveLocation;
	/**
	 * We'll adjust the location so the pawn will not point upwards or downwards when the player jumps.
	 */
	local Vector adjustedLocation;

	//Set nextMoveLocation to l, we'll move directly towards the targetLocation in case the navMesh fails.
	nextMoveLocation = l;

	if ( !DELPawn( Pawn ).bIsStunned ){//You may only move if you are not stunned
		adjustedLocation = adjustLocation( l , Pawn.Location.Z );
		if(FindNavMeshPathVect(adjustedLocation)){
			//A mesh has been found
			NavigationHandle.SetFinalDestination(l);
			FlushPersistentDebugLines();
			if ( NavigationHandle.GetNextMoveLocation(tempDest, Pawn.GetCollisionRadius())){
				nextMoveLocation = tempDest;
			}
		}
		moveInDirection( nextMoveLocation - pawn.Location , deltaTime );
	}
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
	
	if ( !DELPawn( pawn ).bIsStunned ){
		//Adjust the rotation so that only the Yaw will be modified.
		adjustedRotation = adjustRotation( Pawn.Rotation , rotator( to ).Yaw );
		Pawn.velocity.X = Normal( to ).X * DELPawn( pawn ).GroundSpeed;
		Pawn.velocity.Y = Normal( to ).Y * DELPawn( pawn ).GroundSpeed;
		Pawn.setRotation( adjustedRotation );
		clearDesiredDirection();
		Pawn.move( Pawn.velocity * deltaTime );		
	}
}

/**
 * Does all kinds of desiredDirection things.
 */
function clearDesiredDirection(){
	Pawn.setDesiredRotation( pawn.Rotation );
	pawn.ResetDesiredRotation();
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


/**
* This function should let the pawn calculate a path to a point, and then follow it.
* Returns 0 if still walking, 1 if reached the point and 2 if the point is unreachable.
* @param l Vector The target location
* @param deltaTime float The deltaTime from the Tick-event
*/
function smartMoveToPoint(Vector l, float deltaTime){  
	local Vector tempDest;
	if (NavigationHandle.PointReachable(l)){
		moveTowardsPoint(l, deltaTime);
	} else if(FindNavMeshPathVect(l)){
		//The player is not reachable so use the navmesh path to move towards him
		NavigationHandle.SetFinalDestination(l);
		FlushPersistentDebugLines();
		//NavigationHandle.DrawPathCache(,TRUE);
		if ( NavigationHandle.GetNextMoveLocation(tempDest, Pawn.GetCollisionRadius())){
			//DrawDebugLine( Pawn.Location, tempDest , 0 , 255 , 0 , true );
			//DrawDebugSphere( tempDest , 16 , 20 , 0 , 255 , 0 , true );
			//MoveTo( TempDest , Player );
			moveTowardsPoint(tempDest, DeltaTime);
		}
	}
}


/**
 * A function for A* to get a next path to the goal
 * @param goal the location where the goat should walk to.
 */
function bool FindNavMeshPathVect(Vector goal)
{
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;
    class'NavMeshPath_Toward'.static.TowardPoint(NavigationHandle,goal);
    class'NavMeshGoal_At'.static.AtLocation(NavigationHandle, goal,32 );
    return NavigationHandle.FindPath();
}

function bool FindNavMeshPathAct(Actor goal)
{
    NavigationHandle.PathConstraintList = none;
    NavigationHandle.PathGoalList = none;
    class'NavMeshPath_Toward'.static.TowardGoal(NavigationHandle,goal);
    class'NavMeshGoal_At'.static.AtActor(NavigationHandle, goal,32 );
    return NavigationHandle.FindPath();
}


DefaultProperties
{
	player = none
	fleeDistance = 512.0
	tooCloseDistance = 256.0
}
