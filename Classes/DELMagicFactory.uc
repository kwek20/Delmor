/**
 * the factory of each magical ability
 * needs to be called for each user of magical abilities
 * @author Harmen Wiersma
 */
class DELMagicFactory extends actor;
/**
 * list of magical abilities available to magician
 */
var array< class<DElMagic> > magicClasses;
/**
 * location of active ability within spell list
 */
var int ActiveAbilityNumber;

/**
 * array of magical abilities
 */
var array<DELMagic> magics;
/**
 * if this class is initialised
 */
var bool bInitialized;

/**
 * if a spell is active or not
 */
var bool magicCharging;

/**
 * checks if there is a magical ability active
 * @return if a spell is charging
 */
simulated function bool isCharging(){
	return magicCharging;
}

/**
 * sets that a magical ability is active
 */
simulated function startCharge(){
	magicCharging = true;
}

/**
 * sets the magical ability on inactive
 */
simulated function stopCharge(){
	magicCharging = false;
}

/**
 * initialises the class
 */
simulated event PreBeginPlay(){
	super.PreBeginPlay();
	initialize();
}

/**
 * creates some values that need to be used
 * stops if it is already done
 */
simulated function initialize(){
	local class<DELMagic> magicClass;
	local int index;
	local DELMagic magic;

	if (bInitialized) return;
	
	//for each magicclass place an initialised version in the array on the same place
	foreach magicClasses(magicClass, index){
		magic = spawn(magicClass);
		magics.InsertItem(index,magic);
	}
	bInitialized = true;
}


/**
 * gets the amount of spells the player knows
 */
simulated function int getMaxSpells(){
	return magics.Length;
}


/**
 * returns the magic the player want to use
 * @param Number number of the spell you want to use (1,2,3....)
 * @return returns the spell. if a number is given it also switches magic
 */
function DELMagic getMagic(optional int Number=0){
	if(isCharging()){ 
		//if there is magic active, return the active magic
		return magics[ActiveAbilityNumber];
	}
	if(Number != 0){
		//if there is a number, change activenumber ability
		ActiveAbilityNumber = Number-1;
	}
	//return the magic
	return magics[ActiveAbilityNumber];
}

/**
 * gets the number of the active abiity
 * @return number of ability (1,2,.....)
 */
simulated function int getActiveNumber(){
	return ActiveAbilityNumber+1;
}

/**
 * gets a list of icons of each magical ability.
 * location of each spell is the same as the location of the icon in the array
 * @return an array of 2d magical icon textures
 */
simulated function array<Texture2D> getIcons(){
	local DELMagic magic;
	local array<Texture2D> Icons;
	local int index;
	//for each magic, get its icon and place it in a array on the same place as the magic
	foreach magics(magic, index){
		icons.InsertItem(index,magic.IconTexture);
	}
	`log("magical icons:"@icons.Length);
	return icons;
}



DefaultProperties
{
	// the magic classes. i dont care at what place as long as the places follow up on each other and it starts with 0
	magicClasses[0] = class'DELMagicForce'
	magicClasses[2] = class'DELMagicHeal'
	magicClasses[1] = class'DELMagicParalyze'
	ActiveAbilityNumber = 0;
	bInitialized = false;
}
