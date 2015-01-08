class DELSeqAct_DelmorLog extends DELSequenceAction;

var DELQuest delmorVariable;

event Activated(){
	`log("kismet delmor log" $ delmorVariable);
}

DefaultProperties
{
	ObjColor=(R=255,G=0,B=255,A=255)
	bCallHandler = false
	ObjName="delmorean log"
	ObjCategory ="Delmor"

	VariableLinks(0) = (ExpectedType = class'DELSeqVar_Quest', LinkDesc = "Delmor variable", PropertyName = delmorVariable)
}
