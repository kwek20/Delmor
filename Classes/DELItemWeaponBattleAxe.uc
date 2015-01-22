class DELItemWeaponBattleAxe extends DELItemWeapon
	placeable;

DefaultProperties
{
	itemName="Battle Axe"
	itemDescription="A heavy rather slow weapon, deal massive damage on impact. (Right-Click to equip)"
	weaponClass = class'DELMeleeWeaponBattleAxe'
	texture=Texture2D'DelmorHud.Textures.te_ui_battle_axe'

	Begin Object Class=SkeletalMeshComponent Name=Sword
		SkeletalMesh=SkeletalMesh'Delmor_Weapons.Meshes.sk_battle_axe'
		HiddenGame=false
		HiddenEditor=false
		Scale=1.5

		Translation=(Z=15.0)
	End Object

	amount = 1

	Mesh=Sword
	Components.Add(Sword);
}
