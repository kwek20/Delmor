class DELInterfaceCreditsText extends DELInterfaceQuestText;

var() int startDelay;

var() int nextDelay;

var() int endDelay;

var bool ended;

function load(DELPlayerHud hud){
	super.load(hud);
	SetTimer(startDelay, false, 'ScrollTimer');
}

function ScrollTimer(){
	if (percent >= 100 || downLock) {
		SetTimer(endDelay, false, 'end');
		return;
	}
	
	percent+=1;
	SetTimer(nextDelay, false, 'ScrollTimer');
}

function end(){
	ended = true;
}

function draw(DELPlayerHud hud){
	if (ended){
		hud.getPlayer().swapState('Pauses'); 
		return;
	}

	super.draw(hud);
}

function bool requiresUse(DELInputMouseStats stats){
	return false;
}

DefaultProperties
{
	ended=false
	startDelay=5
	nextDelay=1
	endDelay=2;
	text=("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut nulla commodo, pellentesque enim convallis, iaculis lectus. Sed ut tristique justo. Donec rhoncus, metus a imperdiet venenatis, nisl eros commodo urna, eget facilisis odio tortor sed turpis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Pellentesque quis varius dui, eu sodales augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec risus mauris, molestie nec nunc a, mattis molestie lectus. Ut id ligula dapibus orci molestie feugiat. Aliquam a mi non velit fermentum sagittis ultrices eu massa. Nullam bibendum est id consequat hendrerit. Aliquam ornare efficitur tellus, ac posuere arcu. Mauris euismod finibus massa eget finibus. Vivamus efficitur convallis enim eget fermentum. In hac habitasse platea dictumst.", "Proin fermentum mauris magna, iaculis malesuada metus fringilla quis. Aenean non feugiat orci, varius faucibus mauris. Maecenas auctor ornare est, nec eleifend diam congue et. Nunc pharetra varius faucibus. Maecenas ante tortor, facilisis nec nibh quis, tristique feugiat mauris. Sed a lectus sit amet nulla imperdiet tempus at eget nibh. Cras eu commodo nisl. Mauris tincidunt blandit elit non blandit. Quisque fermentum, massa id ultricies viverra, leo neque aliquet nunc, luctus interdum diam velit in nulla. Fusce hendrerit erat ac euismod congue.", "Nunc pellentesque orci at magna ultrices mattis. Curabitur facilisis mollis ex, sed interdum ligula sollicitudin id. Proin non ipsum eget sem iaculis elementum sed at lacus. Donec eu risus felis. Nam efficitur, augue ut pulvinar auctor, lectus purus rhoncus libero, nec iaculis ex quam non neque. Integer lacinia enim vitae risus interdum laoreet. Quisque imperdiet interdum porta. Vestibulum elementum vehicula ante in hendrerit. Nam ac ligula sit amet metus suscipit euismod. Integer eget turpis ut nisl sodales tincidunt id at mauris. Morbi viverra porttitor turpis, sit amet posuere dolor vulputate in. Quisque lobortis sodales mi, vel pretium est dignissim at. Aenean vel elit lorem. Phasellus quis ultricies neque. Nullam viverra nec risus ut vestibulum.", "Suspendisse ex turpis, tristique sit amet risus id, fringilla posuere urna. Praesent diam dui, pharetra a vehicula in, auctor vel dolor. Nunc diam mauris, ultrices vel finibus ac, finibus nec sem. Suspendisse suscipit finibus libero sed posuere. Nulla vitae malesuada erat. Aenean in nulla in ligula malesuada tempor. In ullamcorper neque at orci tristique interdum. Cras felis purus, luctus eget nunc at, dapibus semper orci. Fusce congue felis at augue imperdiet, in pulvinar orci faucibus.", "Ut consequat vulputate lacus, eget facilisis libero maximus ut. Nulla id ligula lorem. Curabitur vel mauris pulvinar, consequat ex a, sagittis urna. Vivamus egestas, mi ac accumsan sollicitudin, eros risus auctor risus, eu elementum metus nisl vel tortor. Nullam gravida nunc eu posuere elementum. Donec eget fermentum urna, a aliquet nibh. Sed nec pulvinar lectus, rhoncus fringilla justo. Praesent placerat sem et purus commodo vehicula. Integer tincidunt arcu sed laoreet malesuada.", "", "", "", "", "", "The end")
}
