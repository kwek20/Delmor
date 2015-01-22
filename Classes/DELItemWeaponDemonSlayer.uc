class DELItemWeaponDemonSlayer extends DELItemWeapon
	placeable;

DefaultProperties
{
	itemName="Demon Slayer"
	itemDescription="A trusty sword given to Lucian by Peony. (Right-Click to equip)"
	weaponClass = class'DELMeleeWeaponDemonSlayer'
	texture=Texture2D'DelmorHud.Textures.te_ui_demonslayer'

	Begin Object Class=SkeletalMeshComponent Name=Sword
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_lucian_sword'
		HiddenGame=false
		HiddenEditor=false
		Scale=1.0
		Translation=(Z=20.0)
	End Object

	amount = 1

	Mesh=Sword
	Components.Add(Sword);
}
