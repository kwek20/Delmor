/**
 * @autor Bram
 * Pawn class for the easy enemy
 */
class DELEasyMonsterPawn extends DELHostilePawn
      placeable
	  Config(Game);

defaultproperties
{
	ControllerClass=class'DELEasyMonsterController'
	magicResistance = 1.0
}