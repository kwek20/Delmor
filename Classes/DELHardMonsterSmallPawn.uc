/**
 * The pawn for the HardMonster. It will be weak but later it should transform in a more 
 * formidable opponent.
 * 
 * @author Anders Egberts.
 */
class DELHardMonsterSmallPawn extends DELHostilePawn
      placeable
	  Config(Game);

/**
 * Replaces the the small version of the pawn with a large version.
 */
function transform(){
}

DefaultProperties
{
	ControllerClass=class'Delmor.DELHardMonsterSmallController'

	health = 100
	healthMax = 100
	healthRegeneration = 0
	walkingSpeed = 90.0
}
