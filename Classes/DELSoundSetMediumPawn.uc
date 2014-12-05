/**
 * This is the soundSet for the medium pawn"s voice.
 */
class DELSoundSetMediumPawn extends DELSoundSet;

/**
 * Returns a soundCue based on a string. i.e.: InitCharge return soundsToPlay[0]
 */
function SoundCue getSound( string sName ){
	switch( sName ){
	case "InitCharge":
		return soundsToPlay[ 0 ];
		break;
	case "OrderAttack":
		return soundsToPlay[ 1 ];
		break;
	case "MinionDied":
		return soundsToPlay[ 2 ];
		break;
	case "NoMoreMinions":
		return soundsToPlay[ 3 ];
		break;
	case "TauntPlayer":
		return soundsToPlay[ 4 ];
		break;
	}
}
DefaultProperties
{
	soundsToPlay[0] = none;
	soundsToPlay[1] = none;
	soundsToPlay[2] = none;
	soundsToPlay[3] = none;
	soundsToPlay[4] = none;
}
