/**
 * This is the Soundset for all monsters, it includes hitsounds.
 */
class DELSoundSetMonster extends DELSoundSet;

/**
 * Returns a soundCue based on a string. i.e.: InitCharge return soundsToPlay[0]
 */
function SoundCue getSound( string sName ){
	switch( sName ){
	case "TakeDamage":
		return soundsToPlay[ 0 ];
		break;
	case "AttackSwing":
		return soundsToPlay[ 1 ];
		break;
	case "Die":
		return soundsToPlay[ 2 ];
		break;
	default:
		return none;
		break;
	}
}

DefaultProperties
{
	soundsToPlay[0] = none;
	soundsToPlay[1] = none;
	soundsToPlay[2] = none;
}