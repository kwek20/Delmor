class DELSeqAct_AddObjective extends DELSequenceAction;

var() DELQuest quest;
var() String objective;
var() int totalAmount;

DefaultProperties
{
	VariableLinks(0)=(bModifiesLinkedObject=true)
	VariableLinks(1) = (ExpectedType = class'DELSeqVar_Quest', LinkDesc = "Quest", PropertyName = quest)
	//VariableLinks(2) = (ExpectedType = class'SeqVar_String', LinkDesc = "Quest description", PropertyName = description)
	ObjColor=(R=255,G=0,B=255,A=255)

	HandlerName = OnAddObjective
	ObjName="add ovjective to quest"
	ObjCategory ="Delmor"
}
