class DELSaveGameStateKActor extends KActor implements(DELSaveGameStateInterface);

function String Serialize() {
    local JSonObject KJSonObject;

    // Instance the JSonObject, abort if one could not be created
    KJSonObject = new class'JSonObject';

    if (KJSonObject == None) {
        `Warn(Self$" could not be serialized for saving the game state.");
		return "";
    }

    // Save the location
    KJSonObject.SetFloatValue("Location_X", Location.X);
    KJSonObject.SetFloatValue("Location_Y", Location.Y);
    KJSonObject.SetFloatValue("Location_Z", Location.Z);

    // Save the rotation
    KJSonObject.SetIntValue("Rotation_Pitch", Rotation.Pitch);
    KJSonObject.SetIntValue("Rotation_Yaw", Rotation.Yaw);
    KJSonObject.SetIntValue("Rotation_Roll", Rotation.Roll);

    // Send the encoded JSonObject
    return class'JSonObject'.static.EncodeJson(KJSonObject);
}

function Deserialize(JSonObject Data) {
    local Vector SavedLocation;
    local Rotator SavedRotation;

    // Deserialize the location and set it
    SavedLocation.X = Data.GetFloatValue("Location_X");
    SavedLocation.Y = Data.GetFloatValue("Location_Y");
    SavedLocation.Z = Data.GetFloatValue("Location_Z");

    // Deserialize the rotation and set it
    SavedRotation.Pitch = Data.GetIntValue("Rotation_Pitch");
    SavedRotation.Yaw = Data.GetIntValue("Rotation_Yaw");
    SavedRotation.Roll = Data.GetIntValue("Rotation_Roll");

    if (self.StaticMeshComponent != None) {
        self.StaticMeshComponent.SetRBPosition(SavedLocation);
        self.StaticMeshComponent.SetRBRotation(SavedRotation);
    }
}