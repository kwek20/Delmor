/**
 * The villagers greets the player when he gets close, and then looks at him for a few seconds.
 * 
 * @author Anders Egberts
 */
class DELVillagerController extends DELAnimalController;

/**
 * Determines whether the villager can greet the player.
 */
var bool bCanGreet;

/**
 * The pawn greets the player every n seconds.
 */
var float greetInterval;

/**
 * When disabling greeting, also disable greeting for all villagers in this radius.
 */
var float greetDisableRadius;

/**
 * Only greet the player when he is this close to you.
 */
var float greetRange;

event seePlayer( Pawn seen ){
	if ( seen.IsHumanControlled() && seen.IsA( 'DELPlayer' ) ){
		player = DELPlayer( seen );
		greetPlayer( seen );
	}
}

/**
 * Plays a greeting sound;
 * @param p Pawn    The player.
 */
function greetPlayer( Pawn p ){
	if ( !bCanGreet ) return;
	if ( VSize( p.Location - pawn.Location ) > greetRange ) return;

	//Play a sound
	PlaySound( SoundCue'Delmor_sound.Greetings.sndc_greeting_male' );

	disableGreetingForNearbyVillagers();

	goToState( 'LookingAtLucian' );
}

/**
 * Disables greeting for greetInterval seconds.
 */
function disableGreet(){
	bCanGreet = false;
	setTimer( greetInterval , false , 'resetCanGreet' );
}

/**
 * Sets bCanGreet to true, so that we can greet again.
 */
function resetCanGreet(){
	bCanGreet = true;
}

/**
 * Disables greeting for all nearby villagers (Including himself) so the player won't be spawmmed by all the greetings.
 */
function disableGreetingForNearbyVillagers(){
	local DELVillagerPawn p;

	foreach worldInfo.AllPawns( class'DELVillagerPawn' , p , Pawn.location , greetRange ){
		DELVillagerController( p.controller ).disableGreet();
	}
}

/**
 * In this state the pawn's rotation will points towards the player for a few seconds.
 */
state LookingAtLucian{

	function beginState( name PreviousStateName ){
		super.BeginState( PreviousStateName );

		setTimer( greetInterval / 2 , false , 'stopLooking' );
	}

	event Tick( float deltaTime ){
		pawn.SetRotation( adjustRotation( Pawn.Rotation , rotator( player.location - pawn.Location ).Yaw ) );
	}

	/**
	 * Stops looking at the player.
	 */
	function stopLooking(){
		goToState( 'Walk' );
	}
}

DefaultProperties
{
	bCanGreet = true
	greetInterval = 10.0
	greetDisableRadius = 512.0
	greetRange = 256.0
}