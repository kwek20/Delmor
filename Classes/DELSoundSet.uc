/**
 * This sound set contains references to soundcues.
 * You can use a sound set to give specific voice to an enemy, amongst other things.
 */
class DELSoundSet extends Actor
	abstract;

/**
 * Determines whether the soundset can play a sound.
 */
var bool bCanPlay;
/**
 * The sounds to play.
 */
var array<SoundCue> soundsToPlay;

/**
 * Sets bCanPlay to true
 */
function resetCanPlay(){
	bCanPlay = true;
}

/**
 * Adapter function, returns sound from the array based on an input-string.
 */
function SoundCue getSound( string sName );

DefaultProperties
{
	bCanPlay = true
}
