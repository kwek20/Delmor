/**
 * Class that is used to spawn an enemy on.
 * @author Bram Arts
 */
class DELSpawnPathNode extends Pathnode placeable;

Var() float zOffset;

DefaultProperties
{
	bCollideActors=false
	bHidden = true
	zOffset = 0.f
	bDestinationOnly = true
}
