class DELPlayerInput extends PlayerInput;

/**
 * The default rotation speed to rotate the pawn with when the player presses a or b.
 */
var float defaultRotationSpeed;
var float pawnRotationSpeed;
/**
 * Counts the number of keys pressed. These will be movement keys only, and will be used for movement.
 */
var int nKeysPressed;
/**
 * An instance of DELmath. This instance will later be used to execute various mathematical functions.
 */
var DELMath math;

var DELInputMouseStats stats;

var int targetYaw;

simulated event postBeginPlay(){
	setBindings();
}

/**
 * Move in the camera's direction.
 */
simulated exec function moveForward( float deltaTime ){
	local Vector camToPawn;
	if ( Pawn != none ){
		camToPawn = cameraToPawn( 0.0 );
		if ( !DELPlayer( Pawn ).bLookMode ){
			//Pawn.SetRotation( Rotator( camToPawn ) );
			targetYaw = Rotator( camToPawn ).Yaw ;
		}
		//Pawn.Velocity = Normal( camToPawn );
	}
}
/**
 * Move right in aspect to the camera.
 */
simulated exec function moveRight( float deltaTime ){
	local Vector camToPawn;
	if ( Pawn != none ){
		camToPawn = cameraToPawn( 22.5 );
		if ( !DELPlayer( Pawn ).bLookMode ){
			//Pawn.SetRotation( Rotator( camToPawn ) );
			targetYaw = Rotator( camToPawn ).Yaw ;
			`log( "targetYaw: "$targetYaw);
		}
		//Pawn.Velocity = Normal( camToPawn );
	}
}
/**
 * Move left in aspect to the camera.
 */
simulated exec function moveLeft( float deltaTime ){
	local Vector camToPawn;
	if ( Pawn != none ){
		camToPawn = cameraToPawn( -22.5 );
		if ( !DELPlayer( Pawn ).bLookMode ){
			//Pawn.SetRotation( Rotator( camToPawn ) );
			targetYaw = Rotator( camToPawn ).Yaw ;
		}
		//Pawn.Velocity = Normal( camToPawn );
	}
}
/**
 * Move down in aspect to the camera.
 */
simulated exec function moveBackward( float deltaTime ){
	local Vector camToPawn;
	if ( Pawn != none ){
		camToPawn = cameraToPawn( -180.0 );
		if ( !DELPlayer( Pawn ).bLookMode ){
			//Pawn.SetRotation( Rotator( camToPawn ) );
			targetYaw = Rotator( camToPawn ).Yaw ;
		}
		//Pawn.Velocity = Normal( camToPawn );
	}
}

/*
 * ========================================
 * Start moving function.
 * ========================================
 */

/**
 * Goes to state movingForward
 */
exec function startMovingForward(){
	if (!getController().canWalk || pawn.IsInState( 'Dead' ) ) return;
	goToState( 'movingForward' );
	nKeysPressed ++;
}

/**
 * Goes to state movingLeft
 */
exec function startMovingLeft(){
	if (!getController().canWalk || pawn.IsInState( 'Dead' ) ) return;
	goToState( 'movingLeft' );
	nKeysPressed ++;
}

/**
 * Goes to state movingLeft
 */
exec function startMovingRight(){
	if (!getController().canWalk || pawn.IsInState( 'Dead' ) ) return;
	goToState( 'movingRight' );
	nKeysPressed ++;
}
/**
 * Goes to state movingBackward
 */
exec function startMovingBackward(){
	if (!getController().canWalk || pawn.IsInState( 'Dead' ) ) return;
	goToState( 'movingBackward' );
	nKeysPressed ++;
}

exec function startSprint() {
	DelPlayer( Pawn ).startSprint();
}

exec function stopSprint() {
	DelPlayer( Pawn ).stopSprint();
}

/**
 * This function should rotate the playerinput's pawn along the yaw-axis to the target-yaw.
 * @param targetYaw	    int The targetYaw in unrealDegrees.
 * @param rotationSpeed int The number of unrealdegrees to rotate per tick.
 */
function rotatePawnToDirection( int targetYaw , int rotationSpeed , float deltaTime ){
	local int yaw;
	local rotator newRotation;

	math = GetMath();
	yaw = pawn.Rotation.Yaw % 65536;
	targetYaw = targetYaw % 65536;

	if ( yaw < targetYaw - ( rotationSpeed  - 10 ) || yaw > targetYaw + ( rotationSpeed - 10 ) ){
        yaw += math.sign( ( ( ( targetYaw - yaw % 65536 ) + 98304 ) % 65536 ) - 32768 ) * rotationSpeed;
	} else {
        yaw = targetYaw;
    }

	newRotation.Pitch = pawn.Rotation.Pitch;
	newRotation.Roll = pawn.Rotation.Roll;
	newRotation.Yaw = yaw % 65536;
	pawn.SetRotation( newRotation );
}

/**
 * This function should rotate the pawn's controller (thus the camera) to the player's direction.
 * @param targetYaw	    int The targetYaw in unrealDegrees.
 * @param rotationSpeed int The number of unrealdegrees to rotate per tick.
 */
function rotateCameraToPlayer( int targetYaw , int rotationSpeed , float deltaTime ){
	local int yaw;
	local rotator newRotation;

	math = GetMath();
	yaw = pawn.Controller.Rotation.Yaw;

	if ( yaw < targetYaw - rotationSpeed || yaw > targetYaw + rotationSpeed ){
        yaw += round( math.sign( math.modulo( ( ( targetYaw - math.modulo( yaw , 360 * DegToUnrRot ) ) + 540 * DegToUnrRot ) , 360 * DegToUnrRot ) - 180 * DegToUnrRot ) * rotationSpeed );
	} else {
        yaw = targetYaw;
    }

	newRotation.Pitch = pawn.Controller.Rotation.Pitch;
	newRotation.Roll = pawn.Controller.Rotation.Roll;
	newRotation.Yaw = yaw;
	pawn.controller.SetRotation( newRotation );
}

/*
 * =================================================
 * Utility functions
 * =================================================
 */

/**
 * Spawns a new instance of DELMath if none exists and returns it OR - if
 * an instance of DELMath already exists - return that instance.
 * @return DELMath.
 */
private function DELMath GetMath(){
	//Spawn a math
	if ( math == none ){
		math = spawn( class'DELMath' );
	}

	return math;
}

/**
 * Calculates a vector based on the pawn's location and the player's camera's location.
 * Additionally you can set an offset.
 */
function vector cameraToPawn( float offSet ){
	local vector camPositionPlusOffset;

	camPositionPlusOffset.X = Pawn.Location.X + lengthDirX( 80 , - ( Rotation.Yaw + offset * DegToUnrRot ) );
	camPositionPlusOffset.Y = Pawn.Location.Y + lengthDirY( 80 , - ( Rotation.Yaw + offset * DegToUnrRot ) );
	camPositionPlusOffset.Z = Pawn.Location.Z;

	return camPositionPlusOffset - Pawn.location;
}

/**
 * This function calculates a new x based on the given direction.
 * @param   dir Float   The direction in UnrealDegrees.
 */
private function float lengthDirX( float len , float dir ){
	local float Radians;
	Radians = UnrRotToRad * dir;

	return len * cos( Radians );

}

/**
 * This function calculates a new y based on the given direction.
 * @param   dir Float   The direction in UnrealDegrees.
 */
private function float lengthDirY( float len , float dir ){
	local float Radians;
	Radians = UnrRotToRad * dir;

	return len * -sin( Radians );

}

/**
 * Starts the look mode in the pawn. When in lookMode, the player can rotate the view and the pawn with the mouse.
 */
exec function startLookMode(){
	if (!getController().canWalk) return;
	DELPlayer( Pawn ).bLookMode = true;
}

/**
 * Ends the look mode.
 */
exec function endLookMode(){
	if (!getController().canWalk) return;
	DELPlayer( Pawn ).bLookMode = false;
	//goToState( 'idle' );
}

/**
 * Enter aim mode before performing a spell.
 */
exec function startAimMode(){
	if (!getController().canWalk) return;
	DELPlayer( Pawn ).bLockedToCamera = true;
}

/**
 * Exit aim mode before performing a spell.
 */
exec function endAimMode(){
	if (!getController().canWalk) return;
	DELPlayer( Pawn ).bLockedToCamera = false;
}

exec function openInventory() {
	getController().openInventory();
}

exec function closeHud() {
	if (getController().getStateName() == 'Playing' || getController().getStateName() == 'Pauses'){
		getController().closeHud();
	} else {
		getController().goToPreviousState();
	}
}

exec function openQuestlog(){
	getController().swapState('Questlog');
}

exec function openMap(){
	getController().swapState('Map');
}

function DELPlayerController getController(){
	return DELPlayerController(Pawn.Controller);
}

/*
 * ==========================================
 * States
 * ==========================================
 */

state idle{
}

state moving{
	event tick( float deltaTime ){
		super.tick( deltaTime );
	}
}

exec function stopMoving(){
	nKeysPressed --;

	if ( nKeysPressed < 0 ){
		nKeysPressed = 0;
	}

	if ( nKeysPressed == 0 ){
		goToState( 'idle' );
	}
}

state movingForward extends moving{
	event tick( float deltaTime ){
		super.tick( deltaTime );

		moveForward( deltaTime );
	}
}
state movingBackward{
	event tick( float deltaTime ){
		super.tick( deltaTime );

		moveBackward( deltaTime );
	}
}

state movingLeft{
	event tick( float deltaTime ){
		super.tick( deltaTime );

		moveLeft( deltaTime );
		//rotateCameraToPlayer( pawn.Rotation.Yaw + 90 * DegToUnrRot , defaultRotationSpeed , deltaTime );
	}
}

state movingRight{
	event tick( float deltaTime ){
		super.tick( deltaTime );

		moveRight( deltaTime );
	}
}

// Handle mouse inputs
function HandleMouseInput(EMouseEvent MouseEvent, EInputEvent InputEvent){
	// Detect what kind of input this is
	if (InputEvent == IE_Pressed){
		// Handle pressed event
		switch (MouseEvent){
			case LeftMouseButton:
				stats.PendingLeftPressed = true;
				stats.PendingLeftReleased = false;
				break;

			case RightMouseButton:
				stats.PendingRightPressed = true;
				stats.PendingRightReleased = false;
				break;

			case MiddleMouseButton:
				stats.PendingMiddlePressed = true;
				stats.PendingMiddleReleased = false;
				break;

			case ScrollWheelUp:
				stats.PendingScrollUp = true;
				stats.PendingScrollDown = false;
				break;

			case ScrollWheelDown:
				stats.PendingScrollDown = true;
				stats.PendingScrollUp = false;
				break;

			default:
				 break;
		}
	} else if (InputEvent == IE_Released) {
		// Handle released event
		switch (MouseEvent){
			case LeftMouseButton:
				stats.PendingLeftReleased = true;
				stats.PendingLeftPressed = false;
				break;

			case RightMouseButton:
				stats.PendingRightReleased = true;
				stats.PendingRightPressed = false;
				break;

			case MiddleMouseButton:
				stats.PendingMiddleReleased = true;
				stats.PendingMiddlePressed = false;
				break;

			default:
				break;
		}
	}
	DELPlayerController(Pawn.Controller).onMouseUse(stats);
	stats.clear();
}

exec function numberPress(name inKey){
	DELPlayerController(Pawn.Controller).onNumberPress(int(string(inKey)));
}

exec function mousePress(bool left=false){
	HandleMouseInput(left ? LeftMouseButton : RightMouseButton, IE_Pressed);

	if (!getController().canWalk) return;
	if (stats.PendingRightPressed) StartAimMode();
	if ( !DELPlayer( Pawn ).isInState( 'Dead' ) ){
		DELPlayer( Pawn ).startFire(int(!left));
	}
}

exec function mouseRelease(bool left=false){
	HandleMouseInput(left ? LeftMouseButton : RightMouseButton, IE_Released);
	
	if (!getController().canWalk) return;
	if (stats.PendingRightReleased) EndAimMode();
	if ( !DELPlayer( Pawn ).isInState( 'Dead' ) ){
		DELPlayer( Pawn ).stopFire(int(!left));
	}
}

// Called when the middle mouse button is pressed
exec function MiddleMousePressed(){
  HandleMouseInput(MiddleMouseButton, IE_Pressed);
  if (stats.PendingMiddlePressed) StartLookMode();
}

// Called when the middle mouse button is released
exec function MiddleMouseReleased(){
  HandleMouseInput(MiddleMouseButton, IE_Released);
  if (stats.PendingMiddleReleased) EndLookMode();
}

// Called when the middle mouse wheel is scrolled up
exec function MiddleMouseScrollUp(){
  HandleMouseInput(ScrollWheelUp, IE_Pressed);
}

// Called when the middle mouse wheel is scrolled down
exec function MiddleMouseScrollDown(){
  HandleMouseInput(ScrollWheelDown, IE_Pressed);
}

exec function save(){
	DELPlayerController(Pawn.Controller).SaveGameState("DelmorSave");
}

exec function load(){
	DELPlayerController(Pawn.Controller).LoadGameState("DelmorSave");
}


/**
 * Sets all keybindings for Delmor.
 */
function setBindings(optional name inKey, optional String inCommand, optional bool change){
	if(!change) {
		stats = Spawn(class'DELInputMouseStats');
		setKeyBinding( 'W' , "startMovingForward | Axis aBaseY Speed=1.0 | OnRelease stopMoving" );
		setKeyBinding( 'A' , "startMovingLeft | Axis aBaseY Speed=1.0 | OnRelease stopMoving" );
		setKeyBinding( 'D' , "startMovingRight | Axis aBaseY Speed=1.0 | OnRelease stopMoving" );
		setKeyBinding( 'S' , "startMovingBackward | Axis aBaseY Speed=1.0 | OnRelease stopMoving" );
		setKeyBinding( 'LeftShift' , "StartSprint | OnRelease StopSprint" );

		setKeyBinding('MouseScrollUp', "GBA_PrevWeapon | MiddleMouseScrollUp");
		setKeyBinding('MouseScrollDown', "GBA_NextWeapon | MiddleMouseScrollDown");

		setKeyBinding('MiddleMouseButton', "MiddleMousePressed | OnRelease MiddleMouseReleased");
		setKeyBinding( 'LeftMouseButton' , "mousePress true | OnRelease mouseRelease true" );
		setKeyBinding( 'RightMouseButton' , "mousePress false | OnRelease mouseRelease false" );

		setKeyBinding( 'I' , "openInventory" );
		setKeyBinding( 'F10' , "openInventory" );
		setKeyBinding( 'l' , "openQuestlog" );
		setKeyBinding( 'm' , "openMap" );
		ChangeInputBinding("ToggleInventory", 'I');

		setKeyBinding('Escape', "closeHud");

		setKeyBinding('Z', "save");
		setKeyBinding('X', "load");

		setKeyBinding('one', "numberPress 1");
		setKeyBinding('two', "numberPress 2");
		setKeyBinding('three', "numberPress 3");
		setKeyBinding('four', "numberPress 4");
		setKeyBinding('five', "numberPress 5");
	} else {
		setKeyBinding(inKey, inCommand);
	}
}

/**
 * Changes the bound key from a command
 */
simulated exec function ChangeInputBinding(string Command, name BindName){
	local int BindIndex;

	if (Command == "none") Command = "";

	for( BindIndex = Bindings.Length-1; BindIndex >= 0; BindIndex--){
		if(Bindings[BindIndex].Command == Command){
			Bindings[BindIndex].Name = BindName;
			SaveConfig();
			return;
		}
	}
}

function setMousePos(int x, int y){
	// Add the aMouseX to the mouse position and clamp it within the viewport width
    stats.MousePosition.X = Clamp(x, 0, myHUD.SizeX); 
    // Add the aMouseY to the mouse position and clamp it within the viewport height
    stats.MousePosition.Y = Clamp(y, 0, myHUD.SizeY); 
}

event PlayerInput(float DeltaTime){
  // Handle mouse 
  // Ensure we have a valid HUD
  if (myHUD != None) {
	setMousePos(stats.MousePosition.X + aMouseX, stats.MousePosition.Y - aMouseY);
    // Add the aMouse to the mouse position and clamp it within the viewport width
  }

  Super.PlayerInput(DeltaTime);
}

event tick( float deltaTime ){
	local vector v;

	//`log( "nKeysPressed: "$nKeysPressed );
	////Move player pawn
	//if ( nKeysPressed > 0 ){
	//	v = vector( pawn.Rotation ) * pawn.GroundSpeed * deltaTime;
	//	pawn.Move( -v );
	//}
	if ( !pawn.IsInState( 'Dead' ) ){
		if ( DELPlayer( Pawn ).bLockedToCamera && nKeysPressed == 0 ){
			targetYaw = pawn.Controller.Rotation.Yaw;
		}
		rotatePawnToDirection( targetYaw , defaultRotationSpeed , deltaTime );
	}
}
/**
 * Set a specific keybinding.
 */
function setKeyBinding( name inKey , String inCommand ){
	SetBind( inKey , inCommand );
}

DefaultProperties
{
	defaultRotationSpeed = 1600.0
	nKeysPressed = 0
}
