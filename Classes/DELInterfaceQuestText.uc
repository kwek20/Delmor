/**
 * Text used in DELInterfaceQuest
 */
class DELInterfaceQuestText extends DELInterfaceScrollbar;

function load(DELPlayerHud hud){
	local DELInterfaceStringText msg;
	msg = new class'DELInterfaceStringText';
	msg.text = "dfhs dfbgisjdf hijsdhgsdfh sg924tj";
	msg.completed = true;
	text.AddItem(msg);

	msg = new class'DELInterfaceStringText';
	msg.text = "dfhs 46833 457457b5h sg924sjtj";
	msg.completed = true;
	text.AddItem(msg);

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
	for (i=yStart; i<=yEnd; i++){
		text[i].draw(hud, position.X+offset, position.Y + offset + y*yString, color);
		y++;
	}
}

/**
 * Calculate the strings based on image size
 * @param c
 * @param messages An array of messages/strings
 */
function array< DELInterfaceStringText > calculateActualStrings(Canvas c, array< DELInterfaceStringText > messages){
	local array< DELInterfaceStringText > newMessages;
	local float xString, yString;
	local int xMax;

	local DELInterfaceStringText s, temp;
	
	//set max size
	xMax = position.Z - 2*offset;

	//for every message in the array
	foreach messages(s){
		//loop as long as the message is not empty
		do {
			//calculate message length
			c.TextSize(s.text, xString, yString);
			//add the left part of the message to the new array
			temp = new class'DELInterfaceStringText';
			temp.text = splitLoc(c, s.text, xMax);
			temp.completed = s.completed;

			newMessages.AddItem(temp);
			if (s.text=="") break;
		} until (temp.text=="");
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
	offset = 90;
	color=(R=50,G=100,B=100,A=255)
}
