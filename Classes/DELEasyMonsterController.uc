/**
 * @author Bram
 * Controller class for the easy enemy
 */
class DELEasyMonsterController extends DELHostileController;

/**
 * Pawns will try to be this close to one another.
 */
var float maximumDistance;
/**
 * Pawns shouldn't get closer to one another than this number.
 */
var float minimumDistance;

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

	//Create an average of the vector
	if ( nMobs > 0 ){
		totalVector.X = totalVector.X / nMobs;
		totalVector.Y = totalVector.Y / nMobs;
	}

	return totalVector;
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
 * This function calculates a new x based on the given direction.
 * @param   dir Float   The direction in UnrealDegrees.
 */
private function float lengthDirX( float len , float dir ){
	local float Radians;
	Radians = UnrRotToRad * dir;

	return len * cos( Radians );

}

/**
 * This function calculates a new y based on the given direction.
 * @param   dir Float   The direction in UnrealDegrees.
 */
private function float lengthDirY( float len , float dir ){
	local float Radians;
	Radians = UnrRotToRad * dir;

	return len * -sin( Radians );

}

auto state Idle{
	event tick( float deltaTime ){
		super.Tick( deltaTime );

		//Go to flocking state when there's another pawn nearby
		if( monsterNearby() ){
			goToState( 'Flock' );
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
		targetLocation = cohesion();
		//targetLocation = seperation( targetLocation );

		//Go to point if you are not too close to another monster.
		if ( !tooCloseToMonster() ){
			moveTowardsPoint( targetLocation , deltaTime );
		}
		else{
			stopPawn();
		}
	}

	event seePlayer( Pawn p ){
		engagePlayer( p );
	}
}

DefaultProperties
{
	groupDistance = 1024.0
	maximumDistance = 1024.0
	minimumDistance = 128.0
}