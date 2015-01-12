class DELInterfaceHealthBarFloating extends DELInterface;

function draw(DELPlayerHud hud){
	local DELHostilePawn dPawn;
	ForEach hud.DynamicActors(class'DELHostilePawn', dPawn){
		dPawn.PostRenderFor(hud.getPlayer(), hud.Canvas, hud.getPlayer().Location, Vector(hud.getPlayer().Rotation));
	}
}

DefaultProperties
{
}
