class DELGame extends UTDeathMatch;

var DELMinimap GameMinimap;

function InitGame( string Options, out string ErrorMessage )
{
   local DELMinimap ThisMinimap;
   Super.InitGame(Options,ErrorMessage);
   foreach AllActors(class'Delmor.DELMinimap',ThisMinimap)
{
   GameMinimap = ThisMinimap;
   break;
}

}

DefaultProperties 
{
   HUDType=class'Delmor.DELPlayerHud'
   
   bUseClassicHUD=true
   game='DELGame'
}
