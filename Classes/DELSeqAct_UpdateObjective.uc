class DELSeqAct_UpdateObjective extends DELSequenceAction;

var() String quest;
var() String objective;

function getInfo(out String questName, out String objectiveText){
	questName = quest;
	objectiveText = objective;
}


DefaultProperties
{
	VariableLinks(0)=(bModifiesLinkedObject=true)
	VariableLinks(1) = (ExpectedType = class'SeqVar_String' , LinkDesc = "Quest Title"                  , PropertyName = quest)
	VariableLinks(2) = (ExpectedType = class'SeqVar_String' , LinkDesc = "objective needed to update"   , PropertyName = objective)
	ObjColor=(R=255,G=0,B=255,A=255)

	HandlerName = OnUpdateObjective
	ObjName="update objective to quest"
	ObjCategory ="Delmor"
}
