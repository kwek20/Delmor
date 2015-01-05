/**
 * This controller controls the hard enemy. This enemy will try to attack the player
 * when there are not too many smaller enemies nearby.
 * If there's too many smaller enemies the hard monster will keep a safe distance between him and the player.
 * 
 * @author Anders Egberts
 */
class DELHardMonsterLargeController extends DELHostileController;

/**
 * The interval at which the monster makes a decision like: HealPawn or GiveOrderToPawn.
 */
var float decisionInterval;

/*
 * =================================
 * States
 * =================================
 */

auto state Idle{

	event tick( float deltaTime ){
		super.tick( deltaTime );

		`log( " >>>>>> player: "$player );

		if ( player != none ){
			`log( " >>>>>>> Engage madafaqa" );
			engagePlayer( player );
		}
	}
}

DefaultProperties
{
	decisionInterval = 0.5
}