class DELFirstQuestPathnode extends Actor placeable;

/**
 * It's number in the pathsequence.
 */
var() int index;

DefaultProperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'UDKHUD.scoreboard_flag_blue_png'
		HiddenGame=True
		AlwaysLoadOnClient=false
		AlwaysLoadOnServer = False
		Name = "Sprite"
		End Object
	Components(0) = Sprite
	bCollideActors=false
	bHidden = true
}