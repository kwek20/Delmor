/**
 * This controller controls the hard enemy. This enemy will try to attack the player
 * when there are not too many smaller enemies nearby.
 * If there's too many smaller enemies the hard monster will keep a safe distance between him and the player.
 * 
 * @author Anders Egberts
 */
class DELHardMonsterController extends DELHostileController;

/**
 * The interval at which the monster makes a decision like: HealPawn or GiveOrderToPawn.
 */
var float decisionInterval;
/*
 * =================================
 * Utility functions
 * =================================
 */

/**
 * Gets the number of easypawns and mediumpawns near the player.
 * @return int.
 */
private function int nPawnsNearPlayer(){
	local DELEasyMonsterController ec;
	local DELMediumMonsterController mc;
	local int nPawns;
	/**
	 * The distance at wich a pawn is considered near the player.
	 */
	local float nearDistance;

	nPawns = 0;
	nearDistance = 192.0;

	//Count the easyminions
	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , ec ){
		if ( VSize( ec.Pawn.Location - attackTarget.Location ) <= nearDistance ){
			nPawns ++;
		}
	}
	//Count the mediumminions
	foreach WorldInfo.AllControllers( class'DELMediumMonsterController' , mc ){
		if ( VSize( mc.Pawn.Location - attackTarget.Location ) <= nearDistance ){
			nPawns ++;
		}
	}

	return nPawns;
}

/*
 * =================================
 * States
 * =================================
 */

state attack{
	/**
	 * Timer for decisions.
	 */
	local float timer;

	function beginState( name previousStateName ){
		super.beginState( previousStateName );

		timer = 0.0;
	}

	event tick( float deltaTime ){
		super.Tick( deltaTime );

		timer -= deltaTime;

		if ( timer <= 0.0 ){
			`log( self$" It is time to make a decision" );

			//Wait till the player has killed the easypawns before attacking
			if ( nPawnsNearPlayer() > 4 ){
				goToState( 'maintainDistanceFromPlayer' );
			}

			//Reset the timer
			timer = decisionInterval;
		}
	}
}

/**
 * In this state the mediumMonster will stay a few meters away from the player as long as there's easypawns nearby the player.
 */
state maintainDistanceFromPlayer{
	/**
	 * The distance to keep from the player.
	 */
	local float distanceToPlayer;
	/**
	 * When the number of easymonsterpawns is smaller than this number, the medium pawn should attack.
	 */
	local int maximumPawnsNearPlayer;
	local float timer;

	function beginState( name previousStateName ){
		distanceToPlayer = 384.0;
		maximumPawnsNearPlayer = 5;
		timer = decisionInterval;

		`log( "Maintain your distance" );
	}
	
	event tick( float deltaTime ){
		local vector selfToPlayer;

		timer -= deltaTime;

		//Calculate direction
		selfToPlayer = pawn.Location - attackTarget.location;

		//Move away
		if ( VSize( selfToPlayer ) < distanceToPlayer ){
			moveInDirection( selfToPlayer , deltaTime );
			pawn.SetRotation( rotator( attackTarget.location - pawn.Location ) );
		}
		else{
			stopPawn();
		}

		//Return to the fight when the easy pawns have died.
		if ( timer <= 0.0 ){
			if ( nPawnsNearPlayer() <= maximumPawnsNearPlayer ){
				goToState( 'attack' );
			}

			//Reset timer
			timer = decisionInterval;
		}
	}

}

DefaultProperties
{
	decisionInterval = 0.5
}