/**
 * A simple controller the is extended from DELNpcController (For combat functions).
 * When the controller sees the player, it will alert nearby monsters to attack the player.
 * 
 * ENEMIES SHOULD EXTEND FROM THIS CONTROLLER!
 * @author Anders Egberts
 */
class DELHostileController extends DELNpcController;

/**
 * All hostileControllers whose pawns are whitin this radius will be alerted to the player's presence,
 * when the pawn sees the player.
 */
var float alertDistance;

auto state Idle{
	function beginState( Name previousStateName ){
		super.BeginState( previousStateName );
	}
	/**
	 * When the pawn sees the player, go to attack attack state.
	 */
	event SeePlayer( Pawn p ){
		`log( self$" See player" );
		attackTarget = DELPawn( p );
		goToState( 'Attack' );

		alertNearbyHostiles( DELPawn( p ) );
	}
}

/**
 * Alert nearby monsters to the player's presence so they'll attack the player.
 * @param p DELPawn The player.
 */
function alertNearbyHostiles( DELPawn p ){
	local DELHostileController c;

	foreach WorldInfo.AllControllers( class'DELHostileController' , c ){
		//If the pawn is whitin the alert-radius
		if ( VSize( c.Pawn.Location - Pawn.Location ) < alertDistance
		&& c.IsInState( 'Idle' ) ){
			c.attackTarget = p;
			c.goToState( 'Attack' );
		}
	}
}
DefaultProperties
{
	alertDistance = 500.0
}