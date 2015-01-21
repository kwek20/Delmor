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

function addObjective(DELQuest quest, String questObjective){
	local DELQuestObjective AddObjective;
	local int i;
	AddObjective = Spawn(class'DELQuestObjective');

	AddObjective.objective = questObjective;

	quest.objectives.AddItem(AddObjective);

	`log("Added objective: " $ questObjective $ " to quest: " $ quest.title);
}

function completeObjective(DELQuest quest, String questObjective) {
	local int i;
	for (i=0; i < quest.objectives.Length; i++){
		if (quest.objectives[i].objective == questObjective){
			quest.objectives[i].complete = true;
			`log("Completed objective: " $ quest.objectives[i].objective);
			completeQuest(quest);
		}
	}
}

function completeQuest(DELQuest quest) {
	local int i, completeCount;

	for (i=0; i < quest.objectives.Length; i++){
		if (quest.objectives[i].complete){
			`log("Objective: " $ quest.objectives[i].objective $ " complete");
			completeCount++;
		} else {
			`log("Not all objectives completed yet");
		}
	}
    if (completeCount == quest.objectives.Length){
		quest.completed = true;
		`log("Quest: " $ quest.title $ " Completed");
	}
}

function DELQuest getQuest(String questName) {
	local int i;
	for (i=0; i < quests.Length; i++){
		if (quests[i].title == questName){
			return quests[i];
		}
	}
}

DefaultProperties
{
}
