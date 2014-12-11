class DELSaveGameState extends Object;

const VERSION = 1;                                          // SaveGameState revision number
const SAVE_LOCATION = "../../Saves/"; // Folder for saved game files

var string PersistentMapFileName;                           // File name of the map that this save game state is associated with
var array<name> StreamingMapFileNames;	                    // File names of the streaming maps that this save game state is associated with
var array<string> WorldData;                                // Serialized world data

function SaveGameState() {
    local WorldInfo SWorldInfo;
    local JsonObject SJsonObject;
    local DELSaveGameStateInterface SaveGameInterface;
    local LevelStreaming Level;
    local Actor CurrentActor;
    local string ActorData;

    // Get the world info, abort if the world info could not be found
    SWorldInfo = class'WorldInfo'.static.GetWorldInfo();

    if (SWorldInfo == none) {
        return;
    }

    // Save the persistent map file name
    PersistentMapFileName = String(SWorldInfo.GetPackageName());

    // Save the currently streamed in map file names
    foreach SWorldInfo.StreamingLevels(Level) {
	// Levels that are visible and have a load request pending should be included in the streaming levels list
        if (Level != none && (Level.bIsVisible || Level.bHasLoadRequestPending)) {				
				StreamingMapFileNames.AddItem(Level.PackageName);
		}
    }

    // Iterate through all of the actors that implement SaveGameStateInterface and ask them to serialize themselves
    foreach SWorldInfo.DynamicActors(class'Actor', CurrentActor, class'SaveGameStateInterface') {
		// Type cast to the SaveGameStateInterface
		SaveGameInterface = DELSaveGameStateInterface(CurrentActor);

		if (SaveGameInterface != none) {
			// Serialize properties that are common to every serializable actor to avoid repetition in the actor classes
			SJsonObject = class'JsonObject'.static.DecodeJson(SaveGameInterface.Serialize());
			SJsonObject.SetStringValue("Name", PathName(CurrentActor));
			SJsonObject.SetStringValue("ObjectArchetype", PathName(CurrentActor.ObjectArchetype));

			ActorData = class'JsonObject'.static.EncodeJson(SJsonObject);

			// If the serialzed actor data is valid, then add it to the serialized world data array
			if (ActorData != "") {
				WorldData.AddItem(ActorData);
			}
		}
    }
}

function LoadGameState()
{
    local WorldInfo SWorldInfo;
    local JSonObject SJSonObject;
    local DELSaveGameStateInterface SaveGameInterface;
    local Actor CurrentActor, ActorArchetype;
    local string ObjectData, ObjectName;

    // No serialized world data to load
    if (WorldData.Length <= 0) {
        return;
    }

    // Grab the world info, abort if no valid world info
    SWorldInfo = class'WorldInfo'.static.GetWorldInfo();

    if (SWorldInfo == none) {
        return;
    }

    // Iterate through each serialized data object
    foreach WorldData(ObjectData) {
        if (ObjectData != "") {
            // Decode the JSonObject from the encoded string
            SJSonObject = class'JSonObject'.static.DecodeJson(ObjectData);

            if (SJSonObject != none) {
                ObjectName = SJSonObject.GetStringValue("Name");            // Get the object name
                CurrentActor = Actor(FindObject(ObjectName, class'Actor')); // Try to find the persistent level actor

                // If the actor was not in the persistent level, then it must have been dynamic so attempt to spawn it
                if (CurrentActor == none) {
                    ActorArchetype = Actor(DynamicLoadObject(SJSonObject.GetStringValue("ObjectArchetype"), class'Actor'));
                    if (ActorArchetype != none) {
						CurrentActor = SWorldInfo.Spawn(ActorArchetype.Class,,,,, ActorArchetype, true);
					}
                }

                if (CurrentActor != none) {
				// Type cast to the SaveGameStateInterface
				SaveGameInterface = DELSaveGameStateInterface(CurrentActor);

					if (SaveGameInterface != none) {
        				// Deserialize the actor
						SaveGameInterface.Deserialize(SJSonObject);
					}
				}
            }
        }
    }
}

/**
 * Saves the Kismet game state
 */
protected function SaveKismetState()
{
  local WorldInfo WorldInfo;
  local array<Sequence> RootSequences;
  local array<SequenceObject> SequenceObjects;
  local SequenceEvent SequenceEvent;
  local SeqVar_Bool SeqVar_Bool;
  local SeqVar_Float SeqVar_Float;
  local SeqVar_Int SeqVar_Int;
  local SeqVar_Object SeqVar_Object;
  local SeqVar_String SeqVar_String;
  local SeqVar_Vector SeqVar_Vector;
  local int i, j;
  local JSonObject JSonObject;

  // Get the world info, abort if it does not exist
  WorldInfo = class'WorldInfo'.static.GetWorldInfo();
  if (WorldInfo == None)
  {
    return;
  }

  // Get all of the root sequences within the world, abort if there are no root sequences
  RootSequences = WorldInfo.GetAllRootSequences();
  if (RootSequences.Length <= 0)
  {
    return;
  }
  
  // Serialize all SequenceEvents and SequenceVariables
  for (i = 0; i < RootSequences.Length; ++i)
  {
    if (RootSequences[i] != None)
    {
      // Serialize Kismet Events
      RootSequences[i].FindSeqObjectsByClass(class'SequenceEvent', true, SequenceObjects);
      if (SequenceObjects.Length > 0)
      {
        for (j = 0; j < SequenceObjects.Length; ++j)
        {
          SequenceEvent = SequenceEvent(SequenceObjects[j]);
          if (SequenceEvent != None)
          {
            JSonObject = new () class'JSonObject';
            if (JSonObject != None)
            {
              // Save the path name of the SequenceEvent so it can found later
              JSonObject.SetStringValue("Name", PathName(SequenceEvent));
              // Calculate the activation time of what it should be when the saved game state is loaded. This is done as the retrigger delay minus the difference between the current world time
              // and the last activation time. If the result is negative, then it means this was never triggered before, so always make sure it is larger or equal to zero.
              JsonObject.SetFloatValue("ActivationTime", FMax(SequenceEvent.ReTriggerDelay - (WorldInfo.TimeSeconds - SequenceEvent.ActivationTime), 0.f));
              // Save the current trigger count
              JSonObject.SetIntValue("TriggerCount", SequenceEvent.TriggerCount);
              // Encode this and append it to the save game data array
              WorldData.AddItem(class'JSonObject'.static.EncodeJson(JSonObject));
            }
          }
        }
      }

      // Serialize Kismet Variables
      RootSequences[i].FindSeqObjectsByClass(class'SequenceVariable', true, SequenceObjects);
      if (SequenceObjects.Length > 0)
      {
        for (j = 0; j < SequenceObjects.Length; ++j)
        {
          // Attempt to serialize as a boolean variable
          SeqVar_Bool = SeqVar_Bool(SequenceObjects[j]);
          if (SeqVar_Bool != None)
          {
            JSonObject = new () class'JSonObject';
            if (JSonObject != None)
            {
              // Save the path name of the SeqVar_Bool so it can found later
              JSonObject.SetStringValue("Name", PathName(SeqVar_Bool));
              // Save the boolean value
              JSonObject.SetIntValue("Value", SeqVar_Bool.bValue);
              // Encode this and append it to the save game data array
              WorldData.AddItem(class'JSonObject'.static.EncodeJson(JSonObject));
            }

            // Continue to the next one within the array as we're done with this array index
            continue;
          }

          // Attempt to serialize as a float variable
          SeqVar_Float = SeqVar_Float(SequenceObjects[j]);
          if (SeqVar_Float != None)
          {
            JSonObject = new () class'JSonObject';
            if (JSonObject != None)
            {
              // Save the path name of the SeqVar_Float so it can found later
              JSonObject.SetStringValue("Name", PathName(SeqVar_Float));
              // Save the float value
              JSonObject.SetFloatValue("Value", SeqVar_Float.FloatValue);
              // Encode this and append it to the save game data array
              WorldData.AddItem(class'JSonObject'.static.EncodeJson(JSonObject));
            }

            // Continue to the next one within the array as we're done with this array index
            continue;
          }

          // Attempt to serialize as an int variable
          SeqVar_Int = SeqVar_Int(SequenceObjects[j]);
          if (SeqVar_Int != None)
          {
            JSonObject = new () class'JSonObject';
            if (JSonObject != None)
            {
              // Save the path name of the SeqVar_Int so it can found later
              JSonObject.SetStringValue("Name", PathName(SeqVar_Int));
              // Save the int value
              JSonObject.SetIntValue("Value", SeqVar_Int.IntValue);
              // Encode this and append it to the save game data array
              WorldData.AddItem(class'JSonObject'.static.EncodeJson(JSonObject));
            }

            // Continue to the next one within the array as we're done with this array index
            continue;
          }

          // Attempt to serialize as an object variable
          SeqVar_Object = SeqVar_Object(SequenceObjects[j]);
          if (SeqVar_Object != None)
          {
            JSonObject = new () class'JSonObject';
            if (JSonObject != None)
            {
              // Save the path name of the SeqVar_Object so it can found later
              JSonObject.SetStringValue("Name", PathName(SeqVar_Object));
              // Save the object value
              JSonObject.SetStringValue("Value", PathName(SeqVar_Object.GetObjectValue()));
              // Encode this and append it to the save game data array
              WorldData.AddItem(class'JSonObject'.static.EncodeJson(JSonObject));
            }

            // Continue to the next one within the array as we're done with this array index
            continue;
          }
  
          // Attempt to serialize as a string variable
          SeqVar_String = SeqVar_String(SequenceObjects[j]);
          if (SeqVar_String != None)
          {
            JSonObject = new () class'JSonObject';
            if (JSonObject != None)
            {
              // Save the path name of the SeqVar_String so it can found later
              JSonObject.SetStringValue("Name", PathName(SeqVar_String));
              // Save the string value
              JSonObject.SetStringValue("Value", SeqVar_String.StrValue);
              // Encode this and append it to the save game data array
              WorldData.AddItem(class'JSonObject'.static.EncodeJson(JSonObject));
            }

            // Continue to the next one within the array as we're done with this array index
            continue;
          }

          // Attempt to serialize as a vector variable
          SeqVar_Vector = SeqVar_Vector(SequenceObjects[j]);
          if (SeqVar_Vector != None)
          {
            JSonObject = new () class'JSonObject';
            if (JSonObject != None)
            {
              // Save the path name of the SeqVar_Vector so it can found later
              JSonObject.SetStringValue("Name", PathName(SeqVar_Vector));
              // Save the vector value
              JSonObject.SetFloatValue("Value_X", SeqVar_Vector.VectValue.X);
              JSonObject.SetFloatValue("Value_Y", SeqVar_Vector.VectValue.Y);
              JSonObject.SetFloatValue("Value_Z", SeqVar_Vector.VectValue.Z);
              // Encode this and append it to the save game data array
              WorldData.AddItem(class'JSonObject'.static.EncodeJson(JSonObject));
            }

            // Continue to the next one within the array as we're done with this array index
            continue;
          }
        }
      }
    }
  }
}

/**
 * Saves the Matinee game state
 */
protected function SaveMatineeState()
{
  local WorldInfo WorldInfo;
  local array<Sequence> RootSequences;
  local array<SequenceObject> SequenceObjects;
  local SeqAct_Interp SeqAct_Interp;
  local int i, j;
  local JSonObject JSonObject;

  // Get the world info, abort if it does not exist
  WorldInfo = class'WorldInfo'.static.GetWorldInfo();
  if (WorldInfo == None)
  {
    return;
  }

  // Get all of the root sequences within the world, abort if there are no root sequences
  RootSequences = WorldInfo.GetAllRootSequences();
  if (RootSequences.Length <= 0)
  {
    return;
  }
  
  // Serialize all SequenceEvents and SequenceVariables
  for (i = 0; i < RootSequences.Length; ++i)
  {
    if (RootSequences[i] != None)
    {
      // Serialize Matinee Kismet Sequence Actions
      RootSequences[i].FindSeqObjectsByClass(class'SeqAct_Interp', true, SequenceObjects);
      if (SequenceObjects.Length > 0)
      {
        for (j = 0; j < SequenceObjects.Length; ++j)
        {
          SeqAct_Interp = SeqAct_Interp(SequenceObjects[j]);
          if (SeqAct_Interp != None)
          {
            // Attempt to serialize the data
            JSonObject = new () class'JSonObject';
            if (JSonObject != None)
            {
              // Save the path name of the SeqAct_Interp so it can found later
              JSonObject.SetStringValue("Name", PathName(SeqAct_Interp));
              // Save the current position of the SeqAct_Interp
              JSonObject.SetFloatValue("Position", SeqAct_Interp.Position);
              // Save if the SeqAct_Interp is playing or not
              JSonObject.SetIntValue("IsPlaying", (SeqAct_Interp.bIsPlaying) ? 1 : 0);
              // Save if the SeqAct_Interp is paused or not
              JSonObject.SetIntValue("Paused", (SeqAct_Interp.bPaused) ? 1 : 0);
              // Encode this and append it to the save game data array
              WorldData.AddItem(class'JSonObject'.static.EncodeJson(JSonObject));
            }
          }
        }
      }
    }
  }
}