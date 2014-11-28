/**
 * This controller controls the hard enemy. This enemy will try to attack the player
 * when there are not too many smaller enemies nearby.
 * If there's too many smaller enemies the hard monster will keep a safe distance between him and the player.
 * 
 * @author Anders Egberts
 */
class DELHardMonsterController extends DELHostileController;

/*
 * =================================
 * Utility functions
 * =================================
 */

/**
 * Gets the number of easypawns and mediumpawns near the player.
 * @return int.
 */
private function int nPawnsNearPlayer(){
	local DELEasyMonsterController ec;
	local DELMediumMonsterController mc;
	local int nPawns;
	/**
	 * The distance at wich a pawn is considered near the player.
	 */
	local float nearDistance;

	nPawns = 0;
	nearDistance = 192.0;

	//Count the easyminions
	foreach WorldInfo.AllControllers( class'DELEasyMonsterController' , ec ){
		if ( VSize( ec.Pawn.Location - attackTarget.Location ) <= nearDistance ){
			nPawns ++;
		}
	}
	//Count the mediumminions
	foreach WorldInfo.AllControllers( class'DELMediumMonsterController' , mc ){
		if ( VSize( mc.Pawn.Location - attackTarget.Location ) <= nearDistance ){
			nPawns ++;
		}
	}

	return nPawns;
}

/*
 * =================================
 * States
 * =================================
 */

DefaultProperties
{
}
