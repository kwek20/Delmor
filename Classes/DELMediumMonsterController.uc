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
	//First we'll check if the pawn's health is low
	if ( pawn.Health <= pawn.HealthMax / 4 ){
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

	if ( distanceToPoint( attackTarget.location ) < 256.0 || !bCanCharge || getNumberOfMinions() > 0 /*|| hitLocation == empty || hitNormal == empty */){
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

	//Change the animtree so that we can show a charge animation.
	//DELPawn( pawn ).Mesh.SetAnimTreeTemplate( AnimTree'Delmor_Character.AnimTrees.Rhinoman_Charge_AnimTree' );
	DELPawn( Pawn ).SwingAnim.PlayCustomAnim('Rhinoman_Charge_run', 1.0 , 0.0 , 0.0 , true , true );
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

state attack{

	function beginState( name previousStateName ){
		super.beginState( previousStateName );

		if ( shouldCharge() ){
			startCharge();
		}

		if ( getNumberOfMinions() > 0 ){
			orderNearbyMinionsToAttackPlayer();
		} else {
			DELMediumMonsterPawn( Pawn ).say( "TauntPlayer" );
		}

		SetTimer( decisionInterval , true , 'decisionTimer' );
	}

	/**
	 * Make a decision for your next move.
	 */
	function decisionTimer(){

		//Wait till the player has killed the easypawns before attacking
		if ( nPawnsNearPlayer() > 2 ){
			changeState( 'maintainDistanceFromPlayer' );
		}
	}
}

/**
 * When the distance to the player is greater than this number, stop fleeing and heal yourself.
 */
state flee{
	/**
	 * Only stop fleeing when we have enough hp.
	 */
	function endFlee(){
		if ( VSize( pawn.Location - attackTarget.location ) >= fleeDistance ){
			//If we have enough hitpoints, return to attack state.
			if ( pawn.Health >= pawn.HealthMax * 0.6 ){
				nextMove();
			}
		}
	}

	/**
	 * Decide the next move, Charge or attack.
	 */
	function nextMove(){
		if ( shouldCharge() ){
			startCharge();
		} else {
			goToState( 'Attack' );
		}
	}
}


/**
 * In this state the mediumMonster will stay a few meters away from the player as long as there's easypawns nearby the player.
 */
state maintainDistanceFromPlayer{

	function beginState( name previousStateName ){
		SetTimer( decisionInterval , true , 'decisionTimer' );
	}
	
	event tick( float deltaTime ){
		local vector targetLocation;

		targetLocation = calculateTargetLocation();

		//Move away
		if ( VSize( pawn.Location - targetLocation ) <= pawn.GroundSpeed * deltaTime + 1 ){
			stopPawn();
		} else {
			moveTowardsPoint( targetLocation , deltaTime );
		}

		clearDesiredDirection();
		pawn.SetRotation( rotator( attackTarget.location - pawn.Location ) );
	}

	/**
	 * Make a decision for your next move.
	 */
	function decisionTimer(){
		if ( /*nPawnsNearPlayer() <= maximumPawnsNearPlayer*/ getNumberOfMinions() == 0 && shouldCharge() ){
			orderHardMonsterToTransform();
			startCharge();
		}
	}

	function vector calculateTargetLocation(){
		local rotator selfToTarget;
		local vector targetLocation;

		selfToTarget = rotator( pawn.Location - attackTarget.location );
		targetLocation.X = attackTarget.Location.X + lengthDirX( 384.0 , - ( selfToTarget.Yaw%65536 ) );
		targetLocation.Y = attackTarget.Location.Y + lengthDirY( 384.0 , - ( selfToTarget.Yaw%65536 ) );
		targetLocation.Z = attackTarget.Location.Z;

		return targetLocation;
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
			if ( nothingInTheWay( playerPosition ) ){
				moveInDirection( playerPosition - pawn.Location , deltaTime * 6 );
			} else {
				moveTowardsPoint( playerPosition , deltaTime * 6.0 );
			}
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
	 * Returns true when there is no geometry in the way.
	 */
	function bool nothingInTheWay( vector traceEnd ){
		local vector hitLocation , hitNormal , emptyVector;

		if ( trace( hitLocation , hitNormal , traceEnd, pawn.Location , false ) == none ){
			return false;
		} else {
			return true;
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
				p.knockBack( 250.0 , selfToPawn );
				p.TakeDamage( 25 , Instigator.Controller , location , momentum , class'DELDmgTypeMelee' , , self );
				stopPawn();
				DELPawn( Pawn ).SwingAnim.PlayCustomAnim( 'Rhinoman_Charge_ending', 1.0 , 0.0 , 0.0 , true , true );
				goToState( 'Attack' );
				DELMediumMonsterPawn( pawn ).spawnChargeHit( ( pawn.Location + p.location ) / 2 , rotator( p.location - pawn.Location ) );
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
		DELPawn( pawn ).Mesh.SetAnimTreeTemplate( AnimTree'Delmor_Character.AnimTrees.Rhinoman_AnimTree' );
		setTimer( 5.0 , false , 'resetCanCharge' );
	}
}

state NonMovingState{

	function getPreviousState( name previousStateName ){
		//Save the previous state in a variable.
		if ( previousStateName != 'KnockedBack' /*&& previousStateName != 'Blocking'*/ && previousStateName != 'GettingHit' ){
			prevState = previousStateName;
		} else{
			if ( pawn.Health <= pawn.HealthMax / 2 ){
				prevState = 'Flee';
			} else {
				prevState = 'Attack';
			}
		}
	}
}

/**
 * When the pawn is blocking, also go to a blocking state so that the pawn will not move.
 * When un-blocking see if you should perform a charge attack.
 */
state Blocking{

	function beginState( name previousStateName ){
		super.beginState( previousStateName );

		//Stop after five seconds
		setTimer( 5.0 , false , 'stopBlocking' );
	}

	event tick( float deltaTime ){
		super.Tick( deltaTime );

		pawn.SetRotation( self.adjustRotation( rotator( attackTarget.location - pawn.Location ) , rotation.Yaw ) );
	}
}

/**
 * Called when hit a by player's force attack.
 * When the block is broken the pawn will not be able to block for five seconds.\
 * Also notify the controller that our block was broken.
 */
function breakBlock(){
	DELHostilePawn( Pawn ).stopBlocking();
	fleeFrom( attackTarget );
	DELHostilePawn( Pawn ).bCanBlock = false;
	Pawn.SetTimer( 10.0 , false , 'resetCanBlock' );
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
	nTimesHit ++;

	if( nTimesHit >= 3 && pawn.Health < pawn.HealthMax * 0.75 ){
		//block();
		DELPawn( pawn ).startBlocking();
	}

	if ( pawn.Health < pawn.HealthMax / 4 ){
		fleeFrom( attackTarget );
	}

	setTimer( 2.0 , false , 'resetNumberOfTimesHit' );
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

DefaultProperties
{ 
	bCanCharge = true;
	decisionInterval = 0.5
	commandRadius = 512.0
}