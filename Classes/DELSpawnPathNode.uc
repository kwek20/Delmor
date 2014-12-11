/**
 * Class that is used to spawn an enemy on.
 * @author Bram Arts
 */
class DELSpawnPathNode extends Actor placeable;

DefaultProperties
{
	bCollideActors=false
	bTriggered = false
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Pickup'
	End Object
	Components.Add(Sprite)
}
