/**
 * This controller controls the small version of the hard enemy. This enemy will evade the player.
 * Will transform in a large version later.
 * 
 * @author Anders Egberts
 */
class DELHardMonsterSmallController extends DELNPCController;

/*
 * ===============================================
 * Vars
 * ===============================================
 */

/**
 * When flocking with a commander, stay this close to the commander.
 */
var float desiredDistanceToCommander;

/**
 * The commander to flock with.
 */
var DELMediumMonsterPawn commander;

var float maximumDistance;

/**
 * The current node the bot is moving to
 */
var DELFirstQuestPathnodes currentNode;

/**
 * The player pawn
 */
var DELPawn Player;





/*
 * ===============================================
 * Utility functions
 * ===============================================
 */

simulated function PostBeginPlay(){
	super.PostBeginPlay();
}


/**
 * Gets a nearby MediumMonsterPawn, these will command the EasyMonsterPawns
 * and it's smart to flock around these.
 * @return DELMediumMonsterPawn when one is nearby else it will return none.
 */
private function DELMediumMonsterPawn getNearbyCommander(){
	local float smallestDistance , distance;
	local DELMediumMonsterController c;
	local DELMediumMonsterPawn cmmndr;

	cmmndr = none;
	smallestDistance = maximumDistance;

	foreach WorldInfo.AllControllers( class'DELMediumMonsterController' , c ){
		distance = VSize( c.Pawn.Location - pawn.Location );
		if ( distance < smallestDistance ){
			cmmndr = DELMediumMonsterPawn( c.Pawn );
			smallestDistance = distance;
		}
	}
	return cmmndr;
}

/*
 * ===============================================
 * Action functions
 * ===============================================
 */

/**
 * Calculates a point near a given pawn to move towards to.
 * @param   p   Pawn    The pawn to stay near.
 */
function vector cohesion( pawn p ){
	local vector newLocation , selfToPawn;

	selfToPawn = pawn.Location - p.Location;

	newLocation.X = p.Location.X + lengthDirX( desiredDistanceToCommander , - rotator( selfToPawn ).Yaw );
	newLocation.Y = p.Location.Y + lengthDirY( desiredDistanceToCommander , - rotator( selfToPawn ).Yaw );
	newLocation.Z = p.Location.Z;

	return newLocation;
}

/*
 * ===============================================
 * States functions
 * ===============================================
 */

state Idle{
	event tick( float deltaTime ){
		super.tick( deltaTime );
		super.Tick( deltaTime );

		commander = getNearbyCommander();

		if ( commander != none ){
			changeState( 'Flock' );
		}
		//Flee from the player
		if ( player != none && tooCloseToPawn( player ) ){
			goToState( 'Flee' );
		}
	}

	event SeePlayer (Pawn Seen){
		local Pawn Player;
		super.SeePlayer(Seen);
		//De speler is gezien
		Player = Seen;

		if( Player != none ){
			engagePlayer( Player );
		}
	}
}


/**
 * Flocks with the commander
 */
state Flock{

	event Tick( float deltaTime ){
		local vector targetLocation;

		super.Tick( deltaTime );
		
//		targetLocation = cohesion( commander );
		if ( self.distanceToPoint( targetLocation ) < pawn.GroundSpeed * deltaTime + 1 ){
			stopPawn();
		} else {
			moveTowardsPoint( targetLocation , deltaTime );
		}

//		if ( commander == none ){
//			commanderDied();
//		}
		
	}

	/**
	 * Overriden so that the pawn will no longer attack the player one sight.
	 */
	event SeePlayer( Pawn p ){
	}

	event commanderDied(){
		changeState( 'Flee' );
	}
}


/*
 * ================================================
 * Common events
 * ================================================
 */

/**
 * Called when the pawn's hitpoints are less than 50% of the max value.
 */
event hitpointsBelowHalf(){
	DELHardMonsterSmallPawn( pawn ).transform(); //Transform into the hard monster.
}

/**
 * When the minions are dead, the commander will attack. Also the hard monster should transform and join the fight.
 */
event commanderOrderedAttack(){
	DELHardMonsterSmallPawn( pawn ).transform(); //Transform into the hard monster.
}

DefaultProperties
{
	bIsPlayer=true
	closeEnough = 200
	bAdjustFromWalls=true
	tooCloseDistance = 512.0
	desiredDistanceToCommander = 384.0
	maximumDistance = 1024.0
}