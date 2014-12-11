/**
 * @author Bram
 * Pawn class for the hard enemy
 */
class DELHardMonsterLargePawn extends DELHostilePawn
      placeable
	  Config(Game);

defaultproperties
{
	ControllerClass=class'Delmor.DELHardMonsterLargeController'

	health = 1000
	healthMax = 1000
	healthRegeneration = 0
	walkingSpeed = 80.0
}