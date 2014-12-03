/**
 * @author Bram
 * Pawn class for the easy enemy
 */
class DELEasyMonsterPawn extends DELHostilePawn
      placeable
	  Config(Game);

defaultproperties
{
	ControllerClass=class'DELEasyMonsterController'
	magicResistance = 1.0
	walkingSpeed = 120.0
	meleeRange = 50.0
}