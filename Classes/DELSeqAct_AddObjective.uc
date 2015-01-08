class DELSeqAct_AddObjective extends DELSequenceAction;

var() String quest;
var() String objective;
var() int totalAmount;

function getValues(out String questTitle, out String objectiveText, out int totalAmountToComplete){
	questTitle = quest;
	objectiveText = objective;
	totalAmountToComlpete = totalAmount;
}

DefaultProperties
{
	VariableLinks(0)=(bModifiesLinkedObject=true)
	VariableLinks(1) = (ExpectedType = class'SeqVar_String' , LinkDesc = "Quest Title"                  , PropertyName = quest)
	VariableLinks(2) = (ExpectedType = class'SeqVar_String' , LinkDesc = "objective text"               , PropertyName = objective)
	VariableLinks(3) = (ExpectedType = class'SeqVar_int'    , LinkDesc = "amount needed to complete"    , PropertyName = totalAmount)
	ObjColor=(R=255,G=0,B=255,A=255)

	HandlerName = OnAddObjective
	ObjName="add objective to quest"
	ObjCategory ="Delmor"
}
