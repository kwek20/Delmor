/**
 * Text used in DELInterfaceQuest
 */
class DELInterfaceQuestText extends DELInterfaceScrollbar;

function load(DELPlayerHud hud){
	text = calculateActualStrings(hud.Canvas, text);
	super.load(hud);
}

/**
 * Draws a part of the text
 * @param hud
 * @param percent The percentage were currntly starting at
 */
function drawPartial(DELPlayerHud hud, float percent){
	local float yString, yLength, yStart, yEnd;
	local int i, y;

	yString = getLetterHeight(hud.Canvas);
	//max length of the text field, amount of y in a char * size of the text array
	yLength = yString * text.Length;
	if (yLength <= textFieldSize()){
		//fits the default screen
		yStart = 0;
		yEnd = text.Length;
	} else {
		yLength -= textFieldSize();
		//Start of the y position, the percentage start of the total
		yStart = class'DELMath'.static.floor(yLength / 100 * percent / yString);
		yEnd = yStart + textFieldSize()/yString;
	}

	yEnd-=1;
	hud.Canvas.SetDrawColorStruct(color);
	for (i=yStart; i<yEnd; i++){
		hud.Canvas.SetPos(position.X+offset, position.Y + offset + y*yString);
		hud.Canvas.DrawText(text[i]);
		y++;
	}
}

/**
 * Calculate the strings based on image size
 * @param c
 * @param messages An array of messages/strings
 */
function array< String > calculateActualStrings(Canvas c, array< String > messages){
	local array< string > newMessages;
	local string s, temp;
	local float xString, yString;
	local int xMax;
	
	//set max size
	xMax = position.Z - 2*offset;
	//for every message in the array
	foreach messages(s){
		//loop as long as the message is not empty
		do {
			//calculate message length
			c.TextSize(s, xString, yString);
			//add the left part of the message to the new array
			temp = splitLoc(c, s, xMax);
			newMessages.AddItem(temp);
			if (s=="") break;
		} until (temp=="");
	}
	return newMessages;
}

function string splitLoc(Canvas c, out string toSplit, float splitOn, optional bool splitWords=false){
	local string str;
	local int i;
	local float xLength, xTotal;
	local array<String> letterArray;

	letterArray = splitWords ? StringToArray(toSplit) : SplitString(toSplit, " ");
	for (i=0; i<letterArray.Length; i++){
		getLetterHeight(c, xLength, (splitWords?"":" ")$letterArray[i]);
		getLetterHeight(c, xTotal, str);

		if (xLength >= splitOn){
			str$=splitLoc(c, letterArray[i], splitOn-(i==0?0.0:xTotal), true);
			break;
		} else if (xTotal==splitOn || xTotal+xLength > splitOn) {break;
		} else {str$=((splitWords||i==0)?"":" ")$letterArray[i];}
	}

	
	toSplit = "";
	while(i<letterArray.Length){
		toSplit$=letterArray[i];
		if (!splitWords)toSplit$=" ";
		i++;
	}
	return str;
}

function array<string> StringToArray(string inputString){
	local array<string> letterArray;
	local int i;
	for (i = 0; i < Len(inputString); i++){
		letterArray[i]=Mid(inputString,i,1);
	}
	return letterArray;
}

DefaultProperties
{
	text=("In luctus urna tellus, sed maximus justo varius non. Vivamus eget enim odio. Nunc semper vitae purus quis suscipit. Duis vel felis placerat, finibus eros a, gravida tellus. In massa libero, scelerisque a diam eget, vulputate condimentum leo. Morbi sit amet blandit massa, sit amet commodo tellus. Duis molestie elit sit amet nulla imperdiet, eu consequat dolor sagittis. Cras rutrum venenatis augue sit amet malesuada. Vivamus efficitur ipsum sit amet nisi auctor ornare. Aenean sagittis, eros vel dignissim lacinia, ipsum nisi gravida elit, eget rutrum leo diam id dolor. Phasellus porta rhoncus turpis eu tristique. Donec nibh turpis, dictum quis massa eu, feugiat egestas arcu. Suspendisse interdum auctor erat ut blandit. Praesent porta dui eget erat posuere rutrum. Nullam fermentum turpis at nulla tempus, vel commodo nunc sollicitudin. In vel ligula aliquam tortor tempor laoreet.", "test", "", "test", "In luctus urna tellus, sed maximus justo varius non. Vivamus eget enim odio. Nunc semper vitae purus quis suscipit. Duis vel felis placerat, finibus eros a, gravida tellus. In massa libero, scelerisque a diam eget, vulputate condimentum leo. Morbi sit amet blandit massa, sit amet commodo tellus. Duis molestie elit sit amet nulla imperdiet, eu consequat dolor sagittis. Cras rutrum venenatis augue sit amet malesuada. Vivamus efficitur ipsum sit amet nisi auctor ornare. Aenean sagittis, eros vel dignissim lacinia, ipsum nisi gravida elit, eget rutrum leo diam id dolor. Phasellus porta rhoncus turpis eu tristique. Donec nibh turpis, dictum quis massa eu, feugiat egestas arcu. Suspendisse interdum auctor erat ut blandit. Praesent porta dui eget erat posuere rutrum. Nullam fermentum turpis at nulla tempus, vel commodo nunc sollicitudin. In vel ligula aliquam tortor tempor laoreet.", "test")
	offset = 90;
	color=(R=50,G=100,B=100,A=255)
}
