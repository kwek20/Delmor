/**
 * @author Bram
 * Controller class for the medium enemy.
 * 
 * The medium monster will command easymonsters. Also the medium monster can perform a series of magic spells.
 * The medium monster should attempt to heal wounded monsters, organise the easymonsters to attack the player.
 */
class DELMediumMonsterController extends DELHostileController;

/*
 * ===============================================================
 * Variables
 * ===============================================================
 */

/**
 * The interval at which the monster makes a decision like: HealPawn or GiveOrderToPawn.
 */
var float decisionInterval;

/*
 * ===============================================================
 * Utility functions
 * ===============================================================
 */

/**
 * Finds a nearby monster with low health. The MediumMonster will later try to heal that monster.
 */
private function DELPawn findLowHealthMonster(){
	return none;
}

/**
 * Returns true when the pawn's health is below 25% and the player is nearby.
 */
private function bool checkIsInDanger(){
	`log( "checkIsInDanger" );
	//First we'll check if the pawn's health is low
	if ( pawn.Health <= pawn.HealthMax / 4 ){
		`log( self$" checkIsInDanger: health is low" );
		//Then we'll check if the player is close enough to attack.
		if ( VSize( pawn.Location - attackTarget.location ) < attackTarget.meleeRange ){
			return true;
		}
	}
	return false;
}

/*
 * ===============================================================
 * Action-functions
 * ===============================================================
 */

/**
 * Starts the healing pipeline for a monster.
 */
private function healMonster( DELPawn p ){
}

/*
 * ===============================================================
 * States
 * ===============================================================
 */

state attack{
	/**
	 * Timer for decisions.
	 */
	local float timer;

	function beginState( name previousStateName ){
		super.beginState( previousStateName );

		timer = decisionInterval;
	}

	event tick( float deltaTime ){
		local DELPawn monster;

		super.Tick( deltaTime );

		timer -= deltaTime;

		if ( timer <= 0.0 ){
			`log( self$" It is time to make a decision" );
			//Heal a nearby monster that is almost dead.
			monster = findLowHealthMonster();
			if ( monster != none )
				healMonster( monster );

			//Flee from the player if the health is low and the player is too close.
			if ( checkIsInDanger() ){
				`log( self$" I'm in danger" );
				goToState( 'Flee' );
			}

			//Reset the timer
			timer = decisionInterval;
		}
	}
}

state flee{
	/**
	 * When the distance to the player is greater than this number, stop fleeing and heal yourself.
	 */
	local float fleeDistance;

	function beginState( name previousStateName ){
		fleeDistance = 512.0;
	}

	event tick( float deltaTime ){
		local vector selfToPlayer;
		
		super.Tick( deltaTime );

		selfToPlayer = pawn.Location - attackTarget.location;

		if ( VSize( selfToPlayer ) < fleeDistance ){
			moveInDirection( selfToPlayer , deltaTime );
		}
		else{
			//If we have enough hitpoints, return to attack state.
			if ( pawn.Health >= pawn.HealthMax / 2 ){
				goToState( 'attack' );
			}
		}
	}
}

DefaultProperties
{
	decisionInterval = 1.0
}