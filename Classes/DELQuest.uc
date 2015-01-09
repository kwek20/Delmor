/**
 * class of the quest
 * @author harmen wiersma & dave van hooren
 */
class DELQuest extends Actor;

/**
 *  list of objectives this quest holds
 */
var array<DELQuestObjective> objectives;

var String title;

var String description;

var Bool completed;

DefaultProperties
{
	completed = false
	title = "Default"
	description = "DefaultDescription"
}
