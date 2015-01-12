class DELHostilePawn extends DELNPCPawn abstract;

var bool bCanBeStunned;

var DELInterfaceHealthBarActor HBActor; 

simulated event PostBeginPlay(){
	local Vector loc;
	local Rotator rot;

	super.PostBeginPlay();
	AddDefaultInventory();

	if (Mesh != none || Mesh.getSocketByName('HealthBarSocket') != none){
		Mesh.getSocketWorldLocationAndRotation('HealthBarSocket', loc, rot);
		HBActor = Spawn(class'DELInterfaceHealthBarActor',,,loc,rot);
		if (HBActor != none){
			HBActor.setBase(self,,Mesh,'HealthBarSocket');
		}
	}
}

/**
 * Modified for the magic damage.
 * Will also play a pain sound when hit.
 */
event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	if ( !isInState( 'Dead' ) ){
		if ( !controller.IsInState( 'Blocking' ) ){
			hitWhileNotBlocking(damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
		} else {
			hitWhileBlocking( hitLocation , damageType );
		}
	}
}

/*
 * ==============================================
 * Below you can two events that are a substitute for the blocking state.
 * Because switching states in the pawn would cause a bug, I've decided to use this to solve the problem.
 */

/**
 * An event that will be called when the pawn is hit while NOT blocking.
 */
event hitWhileNotBlocking(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	local int newDamage;

	newDamage = damage;
	if(DamageType == class'DELDmgTypeMelee'){
		newDamage = damage - (damage * physicalResistance);

		//Play hit sound
		PlaySound( hitSound );
		say( "TakeDamage" );

		//Spawn blood
		spawnBlood( hitLocation );

	} else if(DamageType == class'DELDmgTypeMagical') {
		newDamage = damage - (damage * magicResistance);

	} else if(DamageType == class'DELDmgTypeStun'){
		if(bCanBeStunned == false){
			return;
		} else {
			//stun
		}
	}
	ProcessDamage(newDamage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}
/**
 * An event that will be called when the pawn is hit while blocking.
 */
event hitWhileBlocking( vector HitLocation , class<DamageType> DamageType ){
	if(DamageType == class'DELDmgTypeMelee'){
		playBlockingSound();
	}
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, vector CameraPosition, vector CameraDir){
	local Vector ScreenPos;
	if (PC == None) return;
	//super.PostRenderFor(PC, Canvas,CameraPosition,CameraDir);

	if (!hit || IsInState('Dead')) return;

	ScreenPos = Canvas.Project(HBActor != none ? HBActor.Location : Location);
	//behind us!
	if(!PC.canSee(self)) return;
		
	Canvas.SetDrawColor(255, 0, 0); // Red
	drawBar(Canvas, ScreenPos.X - barLength/2, ScreenPos.Y-barWidth, barLength, barWidth, self, healthBar, edge);
}

/**
 * Stub to play a blocking sound.
 */
function playBlockingSound(){
	PlaySound( SoundCue'Delmor_sound.Weapon.sndc_sword_impact' );
}

/**
 * Ends the stun.
 */
function endStun(){
	controller.goToState( 'Attack' );
}

DefaultProperties
{
}
