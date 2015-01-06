class DELSeqAct_CreateQuest extends DELSequenceAction;

//var() object player;
var() String title;
var() String description;


function array<String> getQuestInfo(){
	local array<String> strings;
	strings.InsertItem(0,title);
	strings.InsertItem(1,description);
	return strings;
}

function activated(){
}

DefaultProperties
{
	VariableLinks(0)=(bModifiesLinkedObject=true)
	//VariableLinks(0) = (ExpectedType = class'SeqVar_Player', LinkDesc = "player", PropertyName = player)
	VariableLinks(1) = (ExpectedType = class'SeqVar_String', LinkDesc = "Quest title", PropertyName = title)
	VariableLinks(2) = (ExpectedType = class'SeqVar_String', LinkDesc = "Quest description", PropertyName = description)
	ObjColor=(R=255,G=0,B=255,A=255)

	HandlerName = OnCreateQuest
	ObjName="create Quest"
	ObjCategory ="Delmor"
}
