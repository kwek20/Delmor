/**
 * @author Bram
 * Pawn class for the easy enemy
 */
class DELEasyMonsterPawn extends DELHostilePawn
      placeable
	  Config(Game);

/**
 * Overriden so the pawn will receive a soundSet.
 */
simulated event PostBeginPlay(){
	super.PostBeginPlay();

	assignSoundSet();
}

/**
 * Assigns a soundSet to the pawn.
 */
private function assignSoundSet(){
	if ( mySoundSet != none ){
		mySoundSet.Destroy();
	}
	mySoundSet = spawn( class'DELSoundSetEasyMonster' );
	`log( self$" mySoundSet: "$mySoundSet );
}

event hitWhileNotBlocking(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, 
class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser){
	/*local int newDamage;

	`log("damage: "$damage);
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
		}
	}*/

	`log( self$" hitWhileNotBlocking" );


	//Block randomly
	if ( rand( 3 ) > 1 ){
		`log( "Ratman gethit" );
		getHit();
	} else {
		if ( bCanBlock && rand( 3 ) == 1 ){
			`log( "Start blocking" );
			startBlocking();
			setTimer( 1.0 , false , 'stopBlocking' );
		}
	}

	super.hitWhileNotBlocking(damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

	//ProcessDamage(newDamage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}

event hitWhileBlocking( vector HitLocation , class<DamageType> DamageType ){
	//When hit by a melee attack the block will be broken and the pawn will be knocked back.
	switch( DamageType ){
	case class'DELDmgTypeMelee':
		playBlockingSound();
		breakBlock();
		break;
	}
}

/**
 * Called when hit a by player's melee attack.
 * When the block is broken the pawn will not be able to block for five seconds.
 */
function breakBlock(){
	stopBlocking();
	bCanBlock = false;
	setTimer( 5.0 , false , 'resetCanBlock' );
	knockBack( 50.0 , location - DELHostileController( controller ).player.location , true );
}

function setUpDropList(){
	super.setUpDropList();
	//dropableItems.AddItem( createDroppableItemParams( class'DELItemWeaponDagger' , 5 , 1 , 1 ) );
}

defaultproperties
{	
	swordClass = class'DELMeleeWeaponFists'
	//swordClass = class'DELMeleeWeaponBattleAxe'
	//swordClass = class'DELMeleeWeaponDagger'

	//dropableItems = (dropItemStruct = (toDrop = class 'DELItemPotionHealth' , dropChance = 75  , minDrops = 1 , maxDrops = 10 ),
	//dropItemStruct = (toDrop = class 'DELItemPotionMana' , dropChance = 75  , minDrops = 1 , maxDrops = 10 ))
	
	//Collision cylinder
	Begin Object Name=CollisionCylinder
		CollisionRadius = 32.0;
		CollisionHeight = +44.0;
	end object

	Components.Remove(ThirdPersonMesh);
	Begin Object Name=ThirdPersonMesh
		SkeletalMesh=SkeletalMesh'Delmor_Character.Meshes.sk_ratman'
		AnimSets(0)=AnimSet'Delmor_Character.AnimSets.Ratman_anim'
		AnimtreeTemplate=AnimTree'Delmor_Character.AnimTrees.Ratman_AnimTree'
		PhysicsAsset=PhysicsAsset'Delmor_Character.PhysicsAsset.sk_ratman_Physics'
		HiddenGame=False
		HiddenEditor=False
		Scale3D=(X=1, Y=1, Z=1)
		bHasPhysicsAssetInstance=false
		bAcceptsLights=true
		Translation=(Z=-42.0)
	End Object
	Mesh=ThirdPersonMesh
    Components.Add(ThirdPersonMesh)
	ControllerClass=class'DELEasyMonsterController'
	magicResistance = 0.8
	groundSpeed = 276.0
	meleeRange = 75.0
	bCanBlock = true

	animname[ 0 ] = ratman_attack1
	attackAnimationImpactTime[ 0 ] = 0.3732
	animname[ 1 ] = ratman_attack2
	attackAnimationImpactTime[ 1 ] = 0.5215
	animname[ 2 ] = ratman_jumpattack
	attackAnimationImpactTime[ 2 ] = 0.7219
	deathAnimName = ratman_death
	getHitAnimName = ratman_gettinghit

	knockBackStartAnimName = ratman_knockback_start
	knockBackStartAnimLength = 0.6
	knockBackAnimName = ratman_knockback_down
	knockBackStandupAnimName = ratman_knockback_standup
	knockBackStandupAnimLength = 2.7

	bHasSplittedKnockbackAnim = true

	deathAnimationTime = 0.6387
	bloodDecalSize = 96.0
}