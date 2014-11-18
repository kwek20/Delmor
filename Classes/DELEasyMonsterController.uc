class DELEasyMonsterController extends AIController;

var float range, amount;
var int idleSeconds;

auto state Idle {

	event SeePlayer(Pawn Seen) {
		super.SeePlayer(Seen);
		//Als afstand klein genoeg is
		if (VSize(Pawn.Location - Seen.Location) < range) {
			//Zet gespotten speler neer in global vars
			GotoState('Spawner');
		}
	}

Begin:
	  `Log("Huidige state idle:Begin: " $GetStateName()$"");
	   self.Pawn.Velocity.x = 0.0;
	   self.Pawn.Velocity.Y = 0.0;
	   self.Pawn.Velocity.Z = 0.0;
}

state Spawner {

Begin:
	Focus = enemy;
	
	Pawn.StartFire(0);
	Sleep(0.1f);
	Goto 'Begin';

}

DefaultProperties {
	range=500;
	amount=5;
	idleSeconds=10;
}