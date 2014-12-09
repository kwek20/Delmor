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

/**
 * Any easyMonsterPawn that is this close to the MediumMonster pawn will be commanded by it.
 */
var float commandRadius;

/**
 * The radius to wander in.
 */
var float wanderRadius;

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

/**
 * Gets the number of easy pawns near the player.
 * @return int.
 */
private function int nPawnsNearPlayer(){
	local DELEasyMonsterController c;
	local int nPawns;
	/**
	 * The distance at wich a pawn is considered near the player.
	 */
	local float nearDistance;

	nPawns = 0;
	nearDistance = 256.0;

	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , c ){
		if ( VSize( c.Pawn.Location - player.Location ) <= nearDistance ){
			nPawns ++;
		}
	}

	return nPawns;
}

/**
 * Gets a random position within the pawn's wanderRadius.
 */
private function vector getRandomLocation(){
	local vector randomLoc;

	randomLoc.X = pawn.Location.X - wanderRadius + rand( wanderRadius * 2 );
	randomLoc.Y = pawn.Location.Y - wanderRadius + rand( wanderRadius * 2 );
	randomLoc.Z = pawn.Location.Z;

	`log( self$" randomLoc: "$randomLoc );
	return randomLoc;
}

/**
 * Returns the number minions the pawn has.
 */
function int getNumberOfMinions(){
	local DELEasyMonsterController c;
	local int nMinions;

	nMinions = 0;

	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , c ){
		if ( c.commander == pawn ){
			nMinions ++;
		}
	}

	return nMinions;
}

/**
 * Returns whether the pawn should charge. It should not charge when he is too far from the player.
 */
function bool shouldCharge(){
	if ( distanceToPoint( attackTarget.location ) < 256.0 ){
		return false;
	} else {
		return true;
	}
}

/*
 * ===============================================================
 * Action-functions
 * ===============================================================
 */

/**
 * Sets all nearby minions into attack state and sets their attackTarget to the controller's attacktarget.
 */
function orderNearbyMinionsToAttackPlayer(){
	local DELEasyMonsterController c;

	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , c ){
		if ( VSize( c.Pawn.Location - attackTarget.Location ) <= commandRadius ){
			c.engagePlayer( attackTarget );
		}
	}

	DELMediumMonsterPawn( Pawn ).say( "OrderAttack" );
}

/*
 * ===============================================================
 * States
 * ===============================================================
 */

auto state idle{
	/**
	 * Go to wander-state as soon as you enter idle-state.
	 */
	function beginState( name previousStateName ){
		super.beginState( previousStateName );
		
	}

	event tick( float deltaTime ){
		super.Tick( deltaTime );
		
		if( pawn != none ){
			changeState( 'wander' );
		}
	}
}
/**
 * Wander randomly on the map.
 */
state wander{
	local vector targetLocation;
	local float timeAtLocation;
	local float maxTimeAtPoint;

	function beginState( name previousStateName ){
		targetLocation = getRandomLocation();
		resetTimer();
	}

	event tick( float deltaTime ){
		if ( distanceToPoint( targetLocation ) > 32.0 ){
			self.moveTowardsPoint( targetLocation , deltaTime );
		} else {
			stopPawn();
			timeAtLocation += deltaTime;

			if ( timeAtLocation > maxTimeAtPoint ){
				targetLocation = getRandomLocation();
				resetTimer();
			}
		}
	}

	/**
	 * Assault the player when you see him.
	 */
	event seePlayer( pawn p ){
		engagePlayer( p );
	}

	/**
	 * Sets timeAtLocation to 0.0 and gets a new maxTimeAtPoint.
	 */
	private function resetTimer(){
		timeAtLocation = 0.0;
		maxTimeAtPoint = 1 + rand( 5 );
	}
}

state attack{
	/**
	 * Timer for decisions.
	 */
	local float timer;

	function beginState( name previousStateName ){
		super.beginState( previousStateName );

		timer = 0.0;

		if ( getNumberOfMinions() > 0 ){
			orderNearbyMinionsToAttackPlayer();
		}
		else{
			DELMediumMonsterPawn( Pawn ).say( "TauntPlayer" );
		}
	}

	event tick( float deltaTime ){
		super.Tick( deltaTime );
		timer -= deltaTime;
		if ( timer <= 0.0 ){
			//Flee from the player if the health is low and the player is too close.
			if ( checkIsInDanger() ){
				`log( self$" I'm in danger" );
				changeState( 'Flee' );

				//Call for backup
				orderNearbyMinionsToAttackPlayer();
			}

			//Wait till the player has killed the easypawns before attacking
			if ( nPawnsNearPlayer() > 2 ){
				changeState( 'maintainDistanceFromPlayer' );
			}

			//Reset the timer
			timer = decisionInterval;
		}
	}
}

/**
 * When the distance to the player is greater than this number, stop fleeing and heal yourself.
 */
state flee{
	event tick( float deltaTime ){
		local vector selfToPlayer;
		
		super.Tick( deltaTime );

		selfToPlayer = pawn.Location - attackTarget.location;

		if ( VSize( selfToPlayer ) >= fleeDistance ){
			//If we have enough hitpoints, return to attack state.
			if ( pawn.Health >= pawn.HealthMax / 2 && shouldCharge() ){
				changeState( 'charge' );
			}
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
		maximumPawnsNearPlayer = 3;
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
		} else {
			stopPawn();
		}

		//Return to the fight when the easy pawns have died.
		if ( timer <= 0.0 ){
			if ( nPawnsNearPlayer() <= maximumPawnsNearPlayer && shouldCharge() ){
				changeState( 'Charge' );
			}

			//Reset timer
			timer = decisionInterval;
		}
	}

}
/**
 * Charge towards the player in hopes to stun him.
 */
state Charge{
	local vector playerPosition;
	function beginState( name previousStateName ){
		local rotator selfToPlayer;

		super.BeginState( previousStateName );

		//Set the playerPosition to the player's position PLUS a bit extra so that the MediumEnemy will charge a bit further and thus appear more realistic.
		selfToPlayer = rotator( attackTarget.location - pawn.Location );
		playerPosition.X = attackTarget.location.X + lengthDirX( 256.0 , -selfToPlayer.yaw % 65536 );
		playerPosition.Y = attackTarget.location.Y + lengthDirY( 256.0 , -selfToPlayer.yaw % 65536 );
		playerPosition.Z = attackTarget.location.Z;

		DELMediumMonsterPawn( Pawn ).say( "InitCharge" );
	}

	event tick( float deltaTime ){
		local DELPawn collidingPawn;

		if ( distanceToPoint( playerPosition ) > Pawn.GroundSpeed * deltaTime * 8.0 + 5.0 ){
			moveInDirection( playerPosition - pawn.Location , deltaTime * 8 /*We run to the player, so we move faster*/ );
			//TODO: Check for collision
			
			collidingPawn = checkCollision();
			if ( collidingPawn != none ){
				collisionWithPawn( collidingPawn );
			}
		} else {
			stopPawn();
			changeState( 'attack' );
		}
	}

	/**
	 * Called when the pawn collides with another pawn.
	 * 
	 * If the pawn collides with an easyMinion it should push him away.
	 * But if the pawn collides with the player, the pawn should exit the charge state
	 * and the player should be stunned.
	 */
	event collisionWithPawn( DELPawn p ){
		local vector selfToPawn;

		selfToPawn = adjustLocation( p.location , pawn.location.Z ) - adjustLocation( pawn.Location , pawn.location.Z );

		if ( p.class != class'DELMediumMonsterPawn' ){
			p.knockBack( 250.0 , selfToPawn );
		}

		if ( p.class == class'DELPlayer' ){
			p.health -= 25;
			stopPawn();
			goToState( 'Attack' );
		}
	}
}

/*
 * ===================================
 * Events
 * ===================================
 */

/**
 * Called when a pawn that belongs to this commander dies.
 * It should play a sound belitteling the minions for their incompetence.
 */
event minionDied(){
	if ( getNumberOfMinions() > 0 ){
		DELMediumMonsterPawn( Pawn ).say( "MinionDied" );
	} else {
		DELMediumMonsterPawn( Pawn ).say( "NoMoreMinions" );
	}
}

DefaultProperties
{ 
	decisionInterval = 0.5
	commandRadius = 512.0
	wanderRadius = 512.0
}