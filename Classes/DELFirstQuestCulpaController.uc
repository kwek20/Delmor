/**
 * Follows a list of pathnodes for the first quest.
 * @author Anders Egberts
 */
class DELFirstQuestCulpaController extends DELHostileController;

/**
 * A list containing the pathnodes to wal trough.
 */
var Array<DELFirstQuestPathNode> waypointList;

var int currentPathnode;

/**
 * Gets all the FirstQuestPathnodes, sorts them based on distance.
 */
function Array<DELFirstQuestPathNode> getWayPoints(){
	local DELFirstQuestPathNode p;
	local Array<DELFirstQuestPathNode> tempList , pathnodesLeft;
	
	//Add all the pathnodes to a list.
	foreach WorldInfo.AllActors( class'DELFirstQuestPathNode' , p ){
		pathnodesLeft.AddItem( p );
	}

	while ( pathnodesLeft.Length > 1 ){
		p = getNearestPathnodesFromList( pathnodesLeft );
		tempList.AddItem( p );
		pathnodesLeft.RemoveItem( p );
	}

	return tempList;
}

function DELFirstQuestPathNode getNearestPathnodesFromList( Array<DELFirstQuestPathNode> list ){
	local DELFirstQuestPathNode p , toReturn;
	local float smallestDistance , distance;
	local int i;

	smallestDistance =  1000000000.0;
	for ( i = 0; i < list.Length; i ++ ){
		p = list[ i ];
		distance = VSize( p.location - pawn.Location );
		if ( distance < smallestDistance ){
			smallestDistance = distance;
			toReturn = p;
		}
	}

	return toReturn;
}

auto state idle{
	function beginState( name previousStateName ){
		goToState( 'FollowPath' );
	}
}
state FollowPath{
	local vector targetLocation;

	function beginState( name previousStateName ){

		//Get pathnode list
		waypointList = getWayPoints();

		targetLocation = waypointList[ 0 ].location;
		currentPathnode ++;
	}

	function tick( float deltaTime ){
		if ( VSize( pawn.Location - targetLocation ) < 200.0 ){
			reachedWaypoint();
		}

		self.moveTowardsPoint( targetLocation , deltaTime );
		DrawDebugLine( location , targetLocation , 255 , 0 , 0 , true );
	}

	/**
	 * Get the next targetlocation.
	 */
	event reachedWaypoint(){
		targetLocation = waypointList[ currentPathnode ].location;
		currentPathnode ++;

		if ( currentPathnode > waypointList.Length ){
			goToState( 'End' );
		}
	}
}

DefaultProperties
{
}
