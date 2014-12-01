/**
 * Interface for drawing subtitles on the screen.
 */
class DELInterfaceSubtitle extends DELInterface;

simulated function draw(DELPlayerHud hud){
	local int X, Y;
	local float Xstring, Ystring;
	local String message;

	message = hud.getPlayer().getSubtitle();
	if (message == "") return;

	hud.Canvas.Font = class'Engine'.static.GetSmallFont();    
	hud.Canvas.TextSize(message, Xstring, Ystring);

	X = hud.CenterX - (Xstring/2);
	Y = hud.SizeY/10*8.8;
	
	hud.Canvas.SetPos(X, Y);
	hud.Canvas.SetDrawColor(0, 0, 0, 120);
	
	hud.Canvas.DrawRect(Xstring, Ystring);
	
	hud.Canvas.SetPos(X, Y);
	hud.Canvas.SetDrawColor(255, 255, 255, 255);
	
	hud.Canvas.DrawText(message);
}

DefaultProperties
{
	
}
