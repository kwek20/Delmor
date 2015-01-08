/**
 * @author Anders Egberts
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

/**
 * Determines whether the pawn is allowed to charge.
 */
var bool bCanCharge;

/**
 * Counts the number of times the pawn has been hit by the player's melee attack.
 * If it's hit three times in a row, it should start blocking.
 */
var int nTimesHit;

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
	//local vector hitLocation , hitNormal , empty;
	//Trace( hitLocation , hitNormal , attackTarget.location , pawn.Location , false );

	if ( distanceToPoint( attackTarget.location ) < 256.0 || !bCanCharge/* || hitLocation == empty || hitNormal == empty */){
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

/**
 * Sends the transformation order to the hardpawns.
 */
function orderHardMonsterToTransform(){
	local DELHardMonsterSmallController c;

	foreach WorldInfo.AllControllers( class'DELHardMonsterSmallController' , c ){
		if ( c.commander == pawn ){
			c.commanderOrderedAttack();
		}
	}
}

/**
 * Start the charge attack.
 */
function startCharge(){
	bCanCharge = false;
	changeState( 'Charge' );
}

/**
 * Sets bCanCharge to true
 */
function resetCanCharge(){
	bCanCharge = true;
}

/**
 * Sets the nTimesHit variable to 0.
 */
function resetNumberOfTimesHit(){
	nTimesHit = 0;
}

/**
 * Starts blocking.
 * While blocking, the pawn cannot be hit by mêlee-attacks but is still vurnable to magic.
 */
function block(){
	`log( ">>>>>>>>>>>>>>> BLOCK" );

	goToState( 'Blocking' );
	DELMediumMonsterPawn( pawn ).startBlocking();
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
				startCharge();
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
		} else {
			stopPawn();
		}

		clearDesiredDirection();
		pawn.SetRotation( rotator( attackTarget.location - pawn.Location ) );

		//Return to the fight when the easy pawns have died.
		if ( timer <= 0.0 ){
			if ( /*nPawnsNearPlayer() <= maximumPawnsNearPlayer*/ getNumberOfMinions() == 0 && shouldCharge() ){
				orderHardMonsterToTransform();
				startCharge();
			}

			//Reset timer
			timer = decisionInterval;
		}
	}

}
/**
 * Charge towards the player in hopes to stun him and knock him back.
 */
state Charge{
	local vector playerPosition;
	/**
	 * At the start of the state the position somewhere behind the player will be calculated and the mediumPawn will run to that point.
	 */
	function beginState( name previousStateName ){
		local rotator selfToPlayer;

		super.BeginState( previousStateName );

		//Set the playerPosition to the player's position PLUS a bit extra so that the MediumEnemy will charge a bit further and thus appear more realistic.
		selfToPlayer = rotator( attackTarget.location - pawn.Location );
		playerPosition.X = attackTarget.location.X + lengthDirX( 512.0 , -selfToPlayer.yaw % 65536 );
		playerPosition.Y = attackTarget.location.Y + lengthDirY( 512.0 , -selfToPlayer.yaw % 65536 );
		playerPosition.Z = attackTarget.location.Z;

		DELMediumMonsterPawn( Pawn ).say( "InitCharge" );
	}

	event tick( float deltaTime ){
		local DELPawn collidingPawn;

		if ( distanceToPoint( playerPosition ) > Pawn.GroundSpeed * deltaTime * 6.0 + 10.0 ){
			//moveInDirection( playerPosition - pawn.Location , deltaTime * 6 /*We run to the player, so we move faster*/ );
			moveTowardsPoint( playerPosition , deltaTime * 6 );
			//self.moveInDirection( playerPosition - pawn.Location , deltaTime * 6 );
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
	 * @param p DELPawn The pawn that has been hit by the mediumPawn's charge attack.
	 */
	event collisionWithPawn( DELPawn p ){
		local vector selfToPawn , momentum;

		if ( p != none ){
			selfToPawn = adjustLocation( p.location , pawn.location.Z ) - adjustLocation( pawn.Location , pawn.location.Z );

			switch( p.Class ){
			//Knock the player back and deal damage.
			case class'DELPlayer': 
				p.TakeDamage( 25 , Instigator.Controller , location , momentum , class'DELDmgTypeMelee' , , self );
				stopPawn();
				goToState( 'Attack' );
				p.knockBack( 250.0 , selfToPawn );
				break;
			//Knock the monster back
			default:
				p.knockBack( 250.0 , selfToPawn );
				break;
			}
		}
	}

	/**
	 * When we're done charging, set a timer that will eventually set bCanCharge to through.
	 */
	event EndState( name NextStateName ){
		super.EndState( NextStateName );
		setTimer( 5.0 , false , 'resetCanCharge' );
	}
}

/**
 * When the pawn is blocking, also go to a blocking state so that the pawn will not move.
 * When un-blocking see if you should perform a charge attack.
 */
state Blocking{

	event tick( float deltaTime ){
		super.Tick( deltaTime );

		pawn.SetDesiredRotation( rotator( player.location - pawn.Location ) );
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
	if ( getNumberOfMinions() > 1 ){
		DELMediumMonsterPawn( Pawn ).say( "MinionDied" );
	} else {
		DELMediumMonsterPawn( Pawn ).say( "NoMoreMinions" , true );
	}
}

/**
 * Called when the pawn has been hit by a mêlee attack.
 * If the pawn has been hit three times in a row it should block.
 */
event pawnHit(){
	`log( ">>>>>>>>>>>>>>>>>> My pawn has been hit" );
	nTimesHit ++;

	`log( "nTimesHit: "$nTimesHit );
	if( nTimesHit >= 3 ){
		`log( "Start blocking" );
		block();
	}

	setTimer( 1.0 , false , 'resetNumberOfTimesHit' );
}

/**
 * When un-blocking see if you should perform a charge attack.
 */
event PawnStoppedBlocking(){
	if ( shouldCharge() ){
	//	startCharge();
	} else {
		changeState( 'Attack' );
	}
}
/**
 * When the block is broken. Go to flee state
 */
event PawnBlockBroken(){
	changeState( 'Flee' );
}

DefaultProperties
{ 
	bCanCharge = true;
	decisionInterval = 0.5
	commandRadius = 512.0
	wanderRadius = 512.0
}