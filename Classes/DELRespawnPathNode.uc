/**
 * Class that is used to respawn
 * @author Brord van Wierst
 */
class DELRespawnPathNode extends Pathnode placeable;

Var() float zOffset;

DefaultProperties
{
	bCollideActors=false
	bHidden = true
	zOffset = 0.f
	bDestinationOnly = true
}
