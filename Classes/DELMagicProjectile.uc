class DELMagicProjectile extends UTProjectile;

var vector ColorLevel;
var vector ExplosionColor;

/**
 * 
 */
event PreBeginPlay(){
	if (Instigator != None){
		InstigatorController = Instigator.Controller;
	}

	if (!bGameRelevant && !bStatic && WorldInfo.NetMode != NM_Client && !WorldInfo.Game.CheckRelevance(self)){
		if (bNoDelete){
			ShutDown();
		} else{
			Destroy();
		}
	}

	if (!bDeleteMe && InstigatorController != None && InstigatorController.ShotTarget != None && InstigatorController.ShotTarget.Controller != None){
		InstigatorController.ShotTarget.Controller.ReceiveProjectileWarning( Self );
	}
}

/**
 * When this actor begins its life, play any ambient sounds attached to it
 */
simulated function PostBeginPlay(){
	local AudioComponent AmbientComponent;

	if (Role == ROLE_Authority){
		// If on console, init wide check
		if ( !bWideCheck ){
			CheckRadius *= GlobalCheckRadiusTweak;
		}
		bWideCheck = bWideCheck || ((CheckRadius > 0) && (Instigator != None) && (PlayerController(Instigator.Controller) != None) && PlayerController(Instigator.Controller).AimingHelp(false));
	}

	bBegunPlay = true;

	if ( bDeleteMe || bShuttingDown)
		return;

	// Set its Ambient Sound
	if (AmbientSound != None && WorldInfo.NetMode != NM_DedicatedServer && !bSuppressSounds){
		if ( bImportantAmbientSound || (!WorldInfo.bDropDetail && (WorldInfo.GetDetailMode() != DM_Low)) ){
			AmbientComponent = CreateAudioComponent(AmbientSound, true, true);
			if ( AmbientComponent != None ){
				AmbientComponent.bShouldRemainActiveIfDropped = true;
			}
		}
	}

	// Spawn any effects needed for flight
	SpawnFlightEffects();

	// shorter lifespan on mobile devices
	if (WorldInfo.IsConsoleBuild(CONSOLE_Mobile) ){
		LifeSpan = FMin(LifeSpan, 0.5*default.LifeSpan);
	}
}


simulated function ProcessTouch (Actor Other, vector HitLocation, vector HitNormal){
	if ( Other != Instigator ){
		if ( !Other.IsA('Projectile') || Other.bProjTarget ){
			MomentumTransfer = (DELPawn(Other) != None) ? 0.0 : 1.0;
			Other.TakeDamage(Damage, InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
			Explode(HitLocation, HitNormal);
		}
	}
}

simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp){
	MomentumTransfer = 1.0;
	Super.HitWall(HitNormal, Wall, WallComp);
}

simulated function SpawnFlightEffects(){
	Super.SpawnFlightEffects();
	if (ProjEffects != None){
		ProjEffects.SetVectorParameter('LinkProjectileColor', ColorLevel);
	}
}


simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion){
	Super.SetExplosionEffectParameters(ProjExplosion);
	ProjExplosion.SetVectorParameter('LinkImpactColor', ExplosionColor);
}



defaultproperties
{
}

