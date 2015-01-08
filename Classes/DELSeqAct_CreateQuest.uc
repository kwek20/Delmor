class DELSeqAct_CreateQuest extends SequenceAction;

//var() object player;
var() String title;
var() String description;
var DELQuest Quest;
var bool returned;

event Activated(){
	while(!returned){
		`log("wait for responce");
	}
}

function array<String> getQuestInfo(){
	local array<String> strings;
	strings.InsertItem(0,title);
	strings.InsertItem(1,description);
	return strings;
}

DefaultProperties
{
	VariableLinks(0)=(bModifiesLinkedObject=true)
	VariableLinks(1) = (ExpectedType = class'SeqVar_String', LinkDesc = "Quest title", PropertyName = title)
	VariableLinks(2) = (ExpectedType = class'SeqVar_String', LinkDesc = "Quest description", PropertyName = description)
	ObjColor=(R=255,G=0,B=255,A=255)
	returned = false
	HandlerName = OnCreateQuest
	ObjName="create Quest"
	ObjCategory ="Delmor"
}