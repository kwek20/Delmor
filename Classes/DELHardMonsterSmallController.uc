/**
 * This controller controls the small version of the hard enemy. This enemy will evade the player.
 * Will transform in a large version later.
 * 
 * @author Anders Egberts
 */
class DELHardMonsterSmallController extends DELHostileController;

/*
 * ===============================================
 * Utility functions
 * ===============================================
 */

/*
 * ===============================================
 * Action functions
 * ===============================================
 */

/*
 * ===============================================
 * States functions
 * ===============================================
 */

auto state Idle{

	event Tick( float deltaTime ){

		if ( player != none && tooCloseToPawn( player ) ){
			goToState( 'Flee' );
		}
	}

	/**
	 * Overriden so that the pawn will no longer attack the player one sight.
	 */
	event SeePlayer( Pawn p ){
	}
}


/**
 * Flocks with the commander
 */
state Flock{

	event Tick( float deltaTime ){
		local vector targetLocation;

		super.Tick( deltaTime );
		
	//	targetLocation = cohesion( commander );
		if ( self.distanceToPoint( targetLocation ) < pawn.GroundSpeed * deltaTime + 1 ){
			stopPawn();
		} else {
			moveTowardsPoint( targetLocation , deltaTime );
		}

	/*	if ( commander == none ){
			commanderDied();
		}*/
		
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
}
