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

DefaultProperties
{
}
