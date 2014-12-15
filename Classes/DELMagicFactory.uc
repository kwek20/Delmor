class DELMagicFactory extends actor;
/**
 * list of magical abilities available to magician
 */
var array< class<DElMagic> > magicClasses;
/**
 * location of active ability within spell list
 */
var int ActiveAbilityNumber;

var array<DELMagic> magics;

var bool bInitialized;

var bool magicCharging;

simulated function bool isCharging(){
	return magicCharging;
}

simulated function startCharge(){
	magicCharging = true;
}

simulated function stopCharge(){
	magicCharging = false;
}


simulated event PreBeginPlay(){
	super.PreBeginPlay();
	initialize();
}


simulated function initialize(){
	local class<DELMagic> magicClass;
	local int index;
	local DELMagic magic;

	if (bInitialized) return;

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
 * gets the spell
 */
function DELMagic getMagic(optional int Number=0){
	if(isCharging()){ 
		return magics[ActiveAbilityNumber];
	}
	if(Number != 0){
		ActiveAbilityNumber = Number-1;
	}
	`log(magics[ActiveAbilityNumber]);
	return magics[ActiveAbilityNumber];
}

simulated function int getActiveNumber(){
	return ActiveAbilityNumber+1;
}


simulated function array<Texture2D> getIcons(){
	local DELMagic magic;
	local array<Texture2D> Icons;
	local int index;
	foreach magics(magic, index){
		icons.InsertItem(index,magic.IconTexture);
	}
	`log("magical icons:"@icons.Length);
	return icons;
}



DefaultProperties
{
	magicClasses[0] = class'DELMagicForce'
	magicClasses[2] = class'DELMagicHeal'
	magicClasses[1] = class'DELMagicParalyze'
	ActiveAbilityNumber = 0;
	bInitialized = false;
}
