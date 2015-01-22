class DELItemWeaponTheButcher extends DELItemWeapon
	placeable;

DefaultProperties
{
	itemName="The Butcher"
	itemDescription="A mighty weapon feared by monsters and men alike. Great for critical-strikes. (Right-Click to equip)"
	weaponClass = class'DELMeleeWeaponTheButcher'
	texture=Texture2D'DelmorHud.Textures.te_ui_the_butcher'

	Begin Object Class=SkeletalMeshComponent Name=Sword
		SkeletalMesh=SkeletalMesh'Delmor_Weapons.Meshes.sk_the_butcher'
		HiddenGame=false
		HiddenEditor=false
		Scale=3.0

		Translation=(Z=35.0)
	End Object

	amount = 1

	Mesh=Sword
	Components.Add(Sword);
}
