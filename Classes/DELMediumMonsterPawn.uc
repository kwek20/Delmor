/**
 * Pawn class for the medium enemy
 * @author Bram
 */
class DELMediumMonsterPawn extends DelCharacterPawn
      placeable
	  Config(Game);

defaultproperties
{
   ControllerClass=class'Delmor.DELMediumMonsterController'

	health = 150
	healthMax = 150
	healthRegeneration = 4
}