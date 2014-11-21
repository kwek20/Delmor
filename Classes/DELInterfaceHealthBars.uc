class DELInterfaceHealthBars extends DELInterface;

var() int barSize;

simulated function draw(DELPlayerHud hud){
	local int length, startX, startY;

	hud.Canvas.Font = class'Engine'.static.GetLargeFont();   
	length = hud.SizeX/5;
	startX = 30;
	startY = 15;

	`log("length: " $ length $ " " $ hud.SizeX);

	hud.Canvas.SetDrawColor(255, 0, 0); // Red
	hud.Canvas.SetPos(startX, startY);   

	hud.Canvas.DrawRect(length * (float(hud.getPlayer().getPawn().Health) / float(hud.getPlayer().getPawn().HealthMax)), barSize); 

	hud.Canvas.SetDrawColor(0, 0, 255); // blue
	hud.Canvas.SetPos(startX, startY+barSize);   
	hud.Canvas.DrawRect(length, barSize); 
}

DefaultProperties
{
	barSize=30;
}
