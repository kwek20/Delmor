class DELFirstQuestHardMonsterPawn extends DELHardMonsterSmallPawn
      placeable
	  Config(Game);

/**
 * Replaces the the small version of the pawn with a large version.
 */
function transform(){
}

DefaultProperties
{
	ControllerClass=class'DELFirstQuestCulpaController'

	health = 100
	healthMax = 100
	healthRegeneration = 0
	GroundSpeed = 500.0
	bKeepInRam = true
}
