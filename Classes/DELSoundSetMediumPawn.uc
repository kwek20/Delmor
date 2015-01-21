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
	case "TakeDamage":
		return soundsToPlay[ 5 ];
		break;
	case "Die":
		return soundsToPlay[ 6 ];
		break;
	default:
		return none;
		break;
	}
}
DefaultProperties
{
	soundsToPlay[0] = SoundCue'Delmor_sound.MediumPawn.sndc_medium_monster_a_charge'
	soundsToPlay[1] = SoundCue'Delmor_sound.MediumPawn.sndc_medium_monster_a_order'
	soundsToPlay[2] = SoundCue'Delmor_sound.MediumPawn.sndc_medium_monster_minion_died'
	soundsToPlay[3] = SoundCue'Delmor_sound.MediumPawn.sndc_medium_monster_no_more_minions'
	soundsToPlay[4] = SoundCue'Delmor_sound.MediumPawn.sndc_medium_monster_a_taunt'
	soundsToPlay[5] = SoundCue'Delmor_sound.MediumPawn.sndc_medium_monster_a_take_damage'
	soundsToPlay[5] = SoundCue'Delmor_sound.MediumPawn.sndc_medium_monster_a_die'
}
