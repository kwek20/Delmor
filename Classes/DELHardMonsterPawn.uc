/**
 * @autor Bram
 * Pawn class for the hard enemy
 */
class DELHardMonsterPawn extends DELHostilePawn
      placeable
	  Config(Game);

defaultproperties
{
	ControllerClass=class'Delmor.DELhardMonsterController'

	health = 500
	healthMax = 500
	healthRegeneration = 0
	walkingSpeed = 60.0
}