class DELInterfaceStringText extends Object;

var float lineSize;

var string text;

var bool completed;

function draw(DELPlayerHud h, float x, float y, Color c, optional Color lc=c){
	local float xl,yl;

	h.Canvas.SetDrawColorStruct(c);
	h.Canvas.SetPos(x, y);
	h.Canvas.DrawText(text);

	if (completed){
		h.Canvas.TextSize(text, xl, yl);
		h.Draw2DLine(x, y+yl/2-lineSize/2, x+xl, y+yl/2-lineSize/2, lc);
	}
}

DefaultProperties
{
	lineSize = 1
}
