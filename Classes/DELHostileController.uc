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
		engagePlayer( p );
	}
}

/**
 * Alert nearby monsters to the player's presence so they'll attack the player.
 * @param p DELPawn The player.
 */
function alertNearbyHostiles( DELPawn p ){
	local DELHostileController c;

	`log( "alertNearbyHostiles" );
	foreach WorldInfo.AllControllers( class'DELHostileController' , c ){
		//If the pawn is whitin the alert-radius
		if ( VSize( c.Pawn.Location - Pawn.Location ) < alertDistance
		&& !c.isInCombatState() ){
			c.attackTarget = p;
			c.goToState( 'Attack' );
		}
	}
}

/**
 * Start an assault on the player if you are close enough.
 * Also alert nearby monsters.
 */
function engagePlayer( Pawn p ){
	if ( VSize( p.Location - Pawn.Location ) <= DELPawn( Pawn ).detectionRange ){ //The player has to be whitin the detection range.
		`log( self$" See player: "$p );
		attackTarget = DELPawn( p );
		goToState( 'Attack' );

		alertNearbyHostiles( DELPawn( p ) );
	}
}

DefaultProperties
{
	alertDistance = 1920.0
}