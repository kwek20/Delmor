/**
 * class for creating a Quest and handling the requests from outer classes
 * @author harmen wiersma & dave van hooren
 */
class DELQuestManager extends actor;
/**
 * list of quests
 */
var array<DELQuest> quests;

function createQuest(String title, String description){
	local DELQuest AddQuest;
	AddQuest = Spawn(class'DELQuest');

	AddQuest.title = title;
	AddQuest.description = description;

	quests.AddItem(AddQuest);
	`log("Added Title: " $ AddQuest.title $ " Description: " $ description);
}

function addObjective(DELQuest quest, DELQuestObjective AddObjective){
	quest.objectives.AddItem(AddObjective);
}

function getQuests()
{
	
}

DefaultProperties
{
}
