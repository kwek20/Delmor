/**
 * @author Bram
 * Controller class for the easy enemy
 */
class DELEasyMonsterController extends DELHostileController;

/**
 * The pawn will flock around a medium-monster if one is nearby. Which monster to flock around 
 * is determined here.
 */
var DELMediumMonsterPawn commander;
/**
 * The angle to commander. This will be used when forming a group around the commander.
 */
var int angleToCommander;
/**
 * Pawns will try to be this close to one another.
 */
var float maximumDistance;
/**
 * Pawns shouldn't get closer to one another than this number.
 */
var float minimumDistance;

/*
 * ====================================================
 * Utility functions
 * ====================================================
 */

/**
 * Returns true when there is another easyMonsterPawn near the pawn.
 * The 'near'-distance is based on the flockingDistance.
 * 
 * @return bool
 * @author Anders Egberts
 */
private function bool monsterNearby(){
	local DELEasyMonsterController c;

	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , c ){
		if ( VSize( c.Pawn.Location - pawn.Location ) < maximumDistance && c != self ){
			return true;
		}
	}

	return false;
}

/**
 * Gets a nearby MediumMonsterPawn, these will command the EasyMonsterPawns
 * and it's smart to flock around these.
 * @return DELMediumMonsterPawn when one is nearby else it will return none.
 */
private function DELMediumMonsterPawn getNearbyCommander(){
	local float smallestDistance , distance;
	local DELMediumMonsterController c;
	local DELMediumMonsterPawn cmmndr;

	cmmndr = none;
	smallestDistance = maximumDistance;

	foreach WorldInfo.AllControllers( class'DELMediumMonsterController' , c ){
		distance = VSize( c.Pawn.Location - pawn.Location );
		if ( distance < smallestDistance ){
			cmmndr = DELMediumMonsterPawn( c.Pawn );
			smallestDistance = distance;
		}
	}

	//If we've found a commander also set the angleToCommander.
	if ( cmmndr != none ){
		angleToCommander = rotator( pawn.Location - cmmndr.location ).Yaw;
		ajustAngleToCommander();
	}
	return cmmndr;
}

/**
 * Returns true when the pawn is too close to another monster.
 */
private function bool tooCloseToMonster(){
	local DELEasyMonsterController c;

	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , c ){
		if ( VSize( c.Pawn.Location - pawn.Location ) < minimumDistance && c != self ){
			return true;
		}
	}

	return false;
}

/**
 * Returns true when the pawn is too close to the commander.
 */
private function bool tooCloseToCommander(){
	if ( distanceToPoint( commander.Location ) < minimumDistance ){
		return true;
	} else {
		return false;
	}
}

/**
 * If the angle is already taken by another pawn, adjust it so you won't get in the way later.
 */
private function ajustAngleToCommander(){
	local int nTries , maxTries;
	nTries = 0;
	maxTries = 100;
	while( angleIsTaken() && nTries < maxTries ){
		angleToCommander += 500;
		nTries ++;
	}
}

private function bool angleIsTaken(){
	local DELEasyMonsterController c;
	/**
	 * How much the angle is allowed to deviate. If the difference between the angles is smaller than this number,
	 * the angle is taken.
	 */
	local int maxDiff;
	local int difference;
	maxDiff = 1000;

	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , c ){
		difference = max( c.angleToCommander , angleToCommander ) - min( c.angleToCommander , angleToCommander );
		if ( c != self && c.commander == commander && difference < maxDiff ){
			return true;
		}
	}

	return false;
}

/**
 * Checks whether a nearby MediumMonsters wants to flee or maintain distance to player.
 * @return DELMediumMonsterPawn that wants to flee/maintain distance
 */
private function DELMediumMonsterPawn isInTheWay(){
	local DELMediumMonsterPawn obstructed;
	local DELMediumMonsterController c;
	local vector adjustedLocation;

	obstructed = none;

	foreach WorldInfo.AllControllers( class'DELMediumMonsterController' , c ){
		//If the pawn is nearby
		if ( VSize( pawn.Location - c.Pawn.Location ) <= minimumDistance && ( c.IsInState( 'Flee' ) || c.IsInState( 'maintainDistanceFromPlayer' )/* || c.IsInState( 'Charge' ) */) ){

			adjustedLocation.X = c.Pawn.Location.X + lengthDirX( c.Pawn.GroundSpeed * 2 , c.Pawn.Rotation.Yaw * UnrRotToDeg + 180.0 );
			adjustedLocation.Y = c.Pawn.Location.Y + lengthDirY( c.Pawn.GroundSpeed * 2 , c.Pawn.Rotation.Yaw * UnrRotToDeg + 180.0 );
			adjustedLocation.Z = c.Pawn.Location.Z;

			//if ( CheckCircleCollision( adjustedLocation , c.Pawn.GetCollisionRadius() * 4 , pawn.Location , pawn.GetCollisionRadius() ) ){
				obstructed = DELMediumMonsterPawn( c.Pawn );
				break;
			//}
		}
	}

	return obstructed;
}

/*
 * ====================================================
 * Action functions
 * ====================================================
 */

/**
 * Makes sure that the pawns stick together.
 * Returns a vector that will be used in the movement later.
 * @return Vector
 * @author Anders Egberts
 */
function Vector cohesion(){
	local DELEasyMonsterController c;
	local int nMobs;
	local Vector totalVector;
	local int i;

	nMobs = 1;
	//Set the z-location of the total vector.
	totalVector.X += Pawn.Location.X;
	totalVector.Y += Pawn.Location.Y;
	totalVector.Z = Pawn.Location.Z;

	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , c ){
		if ( VSize( c.Pawn.Location - pawn.Location ) < maximumDistance
		&& c.Pawn != self.Pawn ){
			//Add the controller's pawn's location to the total vector, ignore z.
			totalVector.X += c.Pawn.Location.X;
			totalVector.Y += c.Pawn.Location.Y;

			nMobs ++;
		}
	}

	//Move slightly towards a medium monster pawn.
	if ( commander != none ){
		for( i = 0; i < 100; i ++ ){
			totalVector.X += commander.Location.X;
			totalVector.Y += commander.Location.Y;

			nMobs ++;
		}
	}

	//Create an average of the vector
	if ( nMobs > 0 ){
		totalVector.X = totalVector.X / nMobs;
		totalVector.Y = totalVector.Y / nMobs;
	}

	return totalVector;
}

/**
 * Stay near the commander.
 */
function vector cohesionCommander(){
	local vector targetLocation;

	targetLocation.X = commander.location.X + lengthDirX( minimumDistance + 50.0 , angleToCommander );
	targetLocation.Y = commander.location.Y + lengthDirY( minimumDistance + 50.0 , angleToCommander );
	targetLocation.Z = commander.location.Z;

	return targetLocation;
}

/*/**
 * Makes sure that the pawns don't get too close to one another.
 * 
 * Finds the nearest other pawn and sets a new target location if you are too close to the pawn.
 * @return Vector
 * @author Anders Egberts
 */
function Vector seperation( Vector targetLocation ){
	local DELEasyMonsterController c;
	local float smallestDistance;
	local float distance;
	local Pawn nearestPawn;
	local Rotator selfToPawn;

	smallestDistance = maximumDistance;

	//Find nearest pawn
	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , c ){
		distance = VSize( c.Pawn.Location - targetLocation );
		if ( distance < smallestDistance && c != self ){
			nearestPawn = c.Pawn;
			smallestDistance = distance;
		}
	}

	//Find target location
	if ( VSize( nearestPawn.Location - targetLocation ) < minimumDistance ){
		selfToPawn = rotator( nearestPawn.Location - pawn.Location );
		targetLocation.X = nearestPawn.location.X + lengthDirX( minimumDistance + 12.0 , selfToPawn.Yaw );
		targetLocation.Y = nearestPawn.location.Y + lengthDirY( minimumDistance + 12.0 , selfToPawn.Yaw );
	}
	
	return targetLocation;
}
*/

/**
 * returns a vector that move away from the commander if the pawn is too close the commander.
 */
private function vector seperation( vector targetLocation ){
	local rotator selfToCommander;

	if ( commander != none ){
		if ( tooCloseToCommander() ){
			selfToCommander = rotator( pawn.Location - commander.location );

			targetLocation.X = commander.location.X + lengthDirX( minimumDistance , selfToCommander.Yaw );
			targetLocation.Y = commander.location.Y + lengthDirY( minimumDistance , selfToCommander.Yaw );
		}
	}

	return targetLocation;
}

/**
 * The Pawn has died, notify a commander if you have one.
 */
function PawnDied( Pawn inPawn ){
	if ( commander != none ){
		DELMediumMonsterController( commander.controller ).minionDied();
	}

	super.PawnDied( inPawn );

	destroy();
}

/*
 * =================================================
 * States
 * =================================================
 */

auto state Idle{
	event tick( float deltaTime ){
		super.Tick( deltaTime );

		//Go to flocking state when there's another pawn nearby
		if( monsterNearby() ){
			//Find a commander
			commander = getNearbyCommander();
			changeState( 'Flock' );
		}
	}
}

state Attack{
	event tick( float deltaTime ){
		/**
		 * The mediummonsterpawn is that is being obstructed by this pawn.
		 */
		local DELMediumMonsterPawn obstructing;

		super.tick( deltaTime );

		//Evade medium monsters the want to flee.
		if ( distanceToPoint( attackTarget.location ) < 512.0 ){
			obstructing = isInTheWay();
			if ( obstructing != none ){
				moveInDirection( pawn.Location - obstructing.location , deltaTime );
			}
		}
	}
}

/**
 * In this state, the pawns will try to form a small group.
 * @author Anders Egberts
 */
state Flock{
	event tick( float DeltaTime ){
		/**
		 * The location to move towards to.
		 * This location will probably amidst other pawns.
		 */
		local vector targetLocation;

		//Calculate target location based on flocking rules
		//Pawns will flock differently when a commander is near.
		if ( commander == none ){
			targetLocation = cohesion();
			
			//There's no commander, find one
			commander = getNearbyCommander();
		} else {
			targetLocation = cohesionCommander();
		}
		targetLocation = seperation( targetLocation );

		//Go to point if you are not too close to another monster.
		//if ( !tooCloseToMonster() ){
		if ( distanceToPoint( targetLocation ) > 32.0 ){
			moveTowardsPoint( targetLocation , deltaTime );
		} else {
			stopPawn();
		}
	}

	event seePlayer( Pawn p ){
		engagePlayer( p );
	}
}

DefaultProperties
{
	maximumDistance = 1024.0
	minimumDistance = 128.0
}