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

function returnAssign(DELQuest questMade){
	Quest = questMade;
	`log("assigned return value: " $ Quest);
	PopulateLinkedVariableValues();
	`log("log for science: ");
	returned = true;
}

DefaultProperties
{
	VariableLinks(0)=(bModifiesLinkedObject=true)
	VariableLinks(1) = (ExpectedType = class'SeqVar_String', LinkDesc = "Quest title", PropertyName = title)
	VariableLinks(2) = (ExpectedType = class'SeqVar_String', LinkDesc = "Quest description", PropertyName = description)
	VariableLinks(3) = (ExpectedType = class'SeqVar_Object', LinkDesc = "Quest", PropertyName = Quest, bWriteable =true, bModifiesLinkedObject=true, bSequenceNeverReadsOnlyWritesToThisVar= true)
	ObjColor=(R=255,G=0,B=255,A=255)
	returned = false
	HandlerName = OnCreateQuest
	ObjName="create Quest"
	ObjCategory ="Delmor"
}