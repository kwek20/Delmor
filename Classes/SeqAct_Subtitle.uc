class SeqAct_Subtitle extends SequenceAction;

var() string subtitle;

defaultproperties
{
	ObjName = "Subtitle"
	
	HandlerName="drawSubtitle"
	
	//Amount = 0
	
	variableLinks(1)=(ExpectedType=class'SeqVar_String', LinkDesc="Subtitle", bWriteable=true, PropertyName=Subtitle)
}