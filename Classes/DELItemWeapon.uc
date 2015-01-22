/**
 * Using this item will swap the weapon in the player's hand.
 */
class DELItemWeapon extends DELItemInteractible;

var class<DELMeleeWeapon> weaponClass;

function use(DELPlayerHud hud){
	//if (!usable(hud)) return;
	if (useSound != none)PlaySound( useSound );
	onUse(hud);
}

function onUse( DELPlayerHud hud ){
	DELPlayer( hud.getPlayer().getPawn() ).swapWeapon( weaponClass );
}

DefaultProperties
{
	itemName="Weapon"
	itemDescription="Right-Click the weapon to equip it."
	weaponClass = class'DELMeleeWeaponDemonSlayer'
	texture=Texture2D'DelmorHud.Textures.te_ui_demonslayer'
}
