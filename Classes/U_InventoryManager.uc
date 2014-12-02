//=============================================================================
// U_InventoryManager
//
// Manages all of the inventory in the game. performs checks it its full and 
// handles removing and adding inventory

//=============================================================================

class U_InventoryManager extends Actor;

//Array of items in the inventory
var array<U_Items> UItems;

// Used to spawn and add item into inventory
var U_Items AddItem;

var  DELPlayerHUD HUD;

simulated event PostBeginPlay()
{
        super.PostBeginPlay();
	`Log("Custom Inventory up");
        //find the playercontroller and reference it

        StartingInventory();
}

//@params ItemToCheck item specified in the U_WorldItemPickup class
//@params AmountWantingToAdd the int amount that is specified in the U_WorldItemPickUp class
//
//returns false if there is space in the inventory returns true if there is not enough space.

function bool CheckInventorySize(class<U_Items> ItemToCheck, int AmountWantingToAdd)
{
  local int ItemAmountInInventory;
  local int i;

  for (i=0;i<UItems.Length;i++)
  {
                    //When the iterator reaches a class that macthes the one that you want add it to itemamountininventory
     if (UItems[i].Class == ItemToCheck)
      {
        ItemAmountInInventory ++;
        `log(""@ItemToCheck$" Has"@ItemAmountInInventory$"Items");
      }

   }
   
      if((ItemAmountInInventory + AmountWantingToAdd) >= 50)
      {
         ItemAmountInInventory = 0;
         `log("no more Space for items");
         return true;
      }
      else
      {
         ItemAmountInInventory = 0;
         `log("has Space for items");
         return false;
      }


}

  //default stuff in the beggining of the game (you always have a herb on game start incase the player saves the game with low low health.)
  function StartingInventory()
{
         AddInventory(class'U_HerbItem', 1);
		 AddInventory(class'U_HerbItem', 3);
}


//Add items to the current inventory
function AddInventory(class<U_Items> ItemType, int Amount )
{
     local int			i;

     for ( i=0; i<Amount; i++ )
      {
         //Spawn the abstract item when the physical object is picked up and store it
         AddItem = Spawn(ItemType);
         UItems.AddItem(AddItem);
      }
      `log("There are" @ UItems.length @ "Items");
}

//Remove items from the current inventory either when used or dropped.
function RemoveInventory(class<U_Items> ItemToRemove, int Amount)
{
     local int			i;
     local U_Items		Item;


        	for (i=0;i<UItems.Length;i++)
                {
                    //When the iterator reaches a class that macthes the one that you want to use or remove. 
                    // Remove it [i] and then use it.
                    if (UItems[i].Class == ItemToRemove)
                     {

                           UItems.Remove(i,Amount);
                           break;
                     }
                }

      `log("Now there are only" @ UItems.length @ "Items!");

     //Display the items left just for debugging.
      foreach UItems(Item, i)
	{
		`log("Index=" $ i @ "Value=" $ Item);
	}
}

/*
function NotifyHUDMessage(string Message, optional int Amount, optional string ItemName)
{
  foreach AllActors(class'DELPlayerHUD', HUD)
  {
   HUD.Message = Message;
   HUD.TAmount = Amount;
   HUD.ItemName = ItemName;
   HUD.bItemPickedUp = true;
  }
}*/

defaultproperties
{
  
}