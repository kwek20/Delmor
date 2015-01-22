class DELItemWeaponDagger extends DELItemWeapon
	placeable;

DefaultProperties
{
	itemName="Dagger"
	itemDescription="Not very strong, but it's weight allows for speedy attacks. (Right-Click to equip)"
	weaponClass = class'DELMeleeWeaponDagger'
	texture=Texture2D'DelmorHud.Textures.te_ui_dagger'

	Begin Object Class=SkeletalMeshComponent Name=Sword
		SkeletalMesh=SkeletalMesh'Delmor_Weapons.Meshes.sk_dagger'
		HiddenGame=false
		HiddenEditor=false
		Scale=4.0
		Translation=(Z=15.0)
	End Object

	amount = 1

	Mesh=Sword
	Components.Add(Sword);
}
