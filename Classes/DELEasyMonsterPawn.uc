/**
 * @autor Bram
 * Pawn class for the easy enemy
 */
class DELEasyMonsterPawn extends DelCharacterPawn
      placeable
	  Config(Game);

simulated event PostBeginPlay ()
{
    Super.PostBeginPlay();
	`log(self.Controller);
}
defaultproperties {
   ControllerClass=class'Delmor.DELEasyMonsterController'
}