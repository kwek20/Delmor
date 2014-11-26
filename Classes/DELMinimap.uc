class DELMinimap extends DELCompass;

var() MaterialInstanceConstant Minimap;
var() MaterialInstanceConstant CompassOverlay;
var() Const EditConst DrawSphereComponent MapExtentsComponent;
var() Bool bForwardAlwaysUp;

var Vector2D MapRangeMin;
var Vector2D MapRangeMax;
var Vector2D MapCenter;

function PostBeginPlay()
{
   Super.PostBeginPlay();
   MapCenter.X = Location.X;
   MapCenter.Y = Location.Y;
   MapRangeMin.X = MapCenter.X - MapExtentsComponent.SphereRadius;
   MapRangeMax.X = MapCenter.X + MapExtentsComponent.SphereRadius;
   MapRangeMin.Y = MapCenter.Y - MapExtentsComponent.SphereRadius;
   MapRangeMax.Y = MapCenter.Y + MapExtentsComponent.SphereRadius;
}

defaultproperties
{
   Begin Object Class=DrawSphereComponent Name=DrawSphere0
        SphereColor=(R=0,G=255,B=0,A=255)
        SphereRadius=1024.000000
   End Object
   MapExtentsComponent=DrawSphere0
   Components.Add(DrawSphere0)
   
   bForwardAlwaysUp=True
	Minimap=MaterialInstanceConstant'CompassContent.M_minimap_INST'
	CompassOverlay=MaterialInstanceConstant'CompassContent.M_compass_INST'
}