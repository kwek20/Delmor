class DELInterfaceQuestText extends DELInterfaceScrollbar;

function load(DELPlayerHud hud){
	super.load(hud);
	text = calculateActualStrings(hud.Canvas, text);
}

function drawPartial(DELPlayerHud hud, float percent){
	local float xString, yString, yLength, yStart, yEnd;
	local int i, y;

	hud.Canvas.Font = class'Engine'.static.GetMediumFont();
	hud.Canvas.SetDrawColorStruct(color);
	hud.Canvas.TextSize("1", xString, yString);

	//max length of the text field, amount of y in a char * size of the text array
	yLength = yString * text.Length;
	//Start of the y position, the percentage start of the total
	yStart = class'DELMath'.static.floor(yLength / 100 * percent);
	if (yStart > yLength - (position.W - offset*2)) {
		yStart = yLength - (position.W - offset*2);
		lockdown();
	}
	
	//The start plus the size of the textfield (-2x offset for the start and end)
	yEnd = yStart + position.W - offset*2;
	

	//The actual start in the array, startpos devided by the size of 1 string
	yStart = class'DELMath'.static.floor(yStart/yString);
	//The actual end in the array, endpos devided by the size of a string, clamped to min and max
	yEnd = Clamp(class'DELMath'.static.round(yEnd/yString),yStart,text.Length);

	for (i=yStart; i<yEnd; i++){
		hud.Canvas.SetPos(position.X+offset, position.Y + offset + y*yString);
		hud.Canvas.DrawText(text[i]);
		y++;
	}
}

function array< String > calculateActualStrings(Canvas c, array< String > messages){
	local array< string > newMessages;
	local string s;
	local float x, y, xString, yString;
	local int xMax, xCharMax;

	c.Font = class'Engine'.static.GetMediumFont();
	c.TextSize("1", x, y);
	xMax = position.Z - 2*offset;
	xCharMax = xMax / x;
	foreach messages(s){
		do {
			c.TextSize(s, xString, yString);
			newMessages.AddItem(Left(s, xCharMax));
			s = Mid(s, xCharMax); 
		} until (xString <= xMax);
	}
	return newMessages;
}

DefaultProperties
{
	text=("Quest1", "12234567", "dfhgbho sdfgoj sdfog sdfjgsdfjg sodg sdofjg sdsdpfjg sdfgpjsdfg sdfgpij sdfg sdfgj dfg sdpofg sdfg psdfg sdfjgg j3b9b93  sidfjg 93", "line 4", "12234567", "dfhgbho sdfgoj sdfog sdfjgsdfjg sodg sdofjg sdsdpfjg sdfgpjsdfg sdfgpij sdfg sdfgj dfg sdpofg sdfg psdfg sdfjgg j3b9b93  sidfjg 93", "12234567", "dfhgbho sdfgoj sdfog sdfjgsdfjg sodg sdofjg sdsdpfjg sdfgpjsdfg sdfgpij sdfg sdfgj dfg sdpofg sdfg psdfg sdfjgg j3b9b93  sidfjg 93", "12234567", "dfhgbho sdfgoj sdfog sdfjgsdfjg sodg sdofjg sdsdpfjg sdfgpjsdfg sdfgpij sdfg sdfgj dfg sdpofg sdfg psdfg sdfjgg j3b9b93  sidfjg 93", "12234567", "dfhgbho sdfgoj sdfog sdfjgsdfjg sodg sdofjg sdsdpfjg sdfgpjsdfg sdfgpij sdfg sdfgj dfg sdpofg sdfg psdfg sdfjgg j3b9b93  sidfjg 93", "12234567", "dfhgbho sdfgoj sdfog sdfjgsdfjg sodg sdofjg sdsdpfjg sdfgpjsdfg sdfgpij sdfg sdfgj dfg sdpofg sdfg psdfg sdfjgg j3b9b93  sidfjg 93")
	offset = 100;
	color=(R=50,G=100,B=100,A=255)
}
