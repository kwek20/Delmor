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

/**
 * The distance to keep from the player.
 */
var float distanceToPlayer;

/**
 * The player pawn
 */
var DELPawn Player;

/**
 * Minimum distance for triggering new state
 */
var int minimumDistance;

/*
 * =================================
 * Utility functions
 * =================================
 */

simulated function PostBeginPlay(){
	super.PostBeginPlay();
}





/*
 * =================================
 * States
 * =================================
 */

state Idle{

	event tick( float deltaTime ){
		super.tick( deltaTime );
	}

	event SeePlayer (Pawn Seen){
		local Pawn Player;
		super.SeePlayer(Seen);
		//De speler is gezien
		Player = Seen;

		if( Player != none ){
			engagePlayer( Player );
		}
	}

}


DefaultProperties
{
	decisionInterval = 0.5
	bIsPlayer=true
	bAdjustFromWalls=true
}