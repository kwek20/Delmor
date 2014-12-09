/**
 * =============================================================================
 * inventoryManager
 *
 * Manages all of the inventory in the game. performs checks it its full and 
 * handles removing and adding inventory
 *=============================================================================
 */
class DELInventoryManager extends Actor;

//Array of items in the inventory
var array<DELItem> UItems;

var DELPlayerHUD HUD;

simulated event PostBeginPlay(){
	super.PostBeginPlay();
	StartingInventory();
}

/**
 * @param ItemToCheck item specified in the U_WorldItemPickup class
 * @param AmountWantingToAdd the int amount that is specified in the U_WorldItemPickUp class
 * @return false if there is space in the inventory returns true if there is not enough space.
 */
function bool CheckInventorySize(class<DELItem> ItemToCheck, int AmountWantingToAdd){
  local int ItemAmountInInventory;
  local int i;

  for (i=0;i<UItems.Length;i++){
	//When the iterator reaches a class that macthes the one that you want add it to itemamountininventory
	if (UItems[i].Class == ItemToCheck){
        ItemAmountInInventory ++;
        `log(""@ItemToCheck$" Has"@ItemAmountInInventory$"Items");
	}
  }

  return (ItemAmountInInventory + AmountWantingToAdd) >= 50;
}

/**
 * default stuff in the beggining of the game (you always have a herb on game start incase the player saves the game
 * with low low health.)
 */
function StartingInventory(){
	AddInventory(class'DELItemHerb', 6);
	AddInventory(class'DELItemOre', 5);
	AddInventory(class'DELItemOre', 1);
	AddInventory(class'DELItemOre', 3);
	AddInventory(class'DELItemOre', 1);
	AddInventory(class'DELItemOre', 20);
	AddInventory(class'DELItemOre', 4);
	AddInventory(class'DELItemOre', 2);
	AddInventory(class'DELItemOre', 1);
}


//Add items to the current inventory
function AddInventory(class<DELItem> ItemType, int amount ){
	local DELItem AddItem, item;
	local int toRemove;
	
	if (ItemType == None || amount < 1) return;
	foreach UItems(item){
		if (item.class == ItemType){
			toRemove = item.getAmount() + amount > item.maxSize ? item.maxSize - item.getAmount() : amount;
			if (toRemove > 0){
				item.setAmount(item.getAmount() + toRemove);
				amount -= toRemove;
				if (amount == 0) return;
			}
		}
	}

	AddItem = Spawn(ItemType);
	AddItem.setAmount(amount);
    UItems.AddItem(AddItem);
}

//Remove items from the current inventory either when used or dropped.
function RemoveInventory(class<DELItem> ItemToRemove, int Amount){
	local int i;
    local DELItem	Item;

	for (i=0;i<UItems.Length;i++){
		//When the iterator reaches a class that macthes the one that you want to use or remove. 
        // Remove it [i] and then use it.
        if (UItems[i].Class == ItemToRemove){
			UItems.Remove(i,Amount);
            break;
        }
    }
}

defaultproperties
{
  
}