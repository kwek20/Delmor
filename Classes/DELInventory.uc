/**
 * An alternate inventory class.
 * @author Anders Egberts.
 */
class DELInventory extends Actor;

var Array<DELItem> itemList;

/**
 * Adds an item to the inventory based on a class-name.
 */
function addItemToInventoryFromInstance( DELItem item ){
	addItemToInventory( item.Class , item.getAmount() );
}

/**
 * Adds an item to the inventory based on a class-name.
 */
function addItemToInventory( class<DELItem> className , int amount ){
	local DELItem itm;
	local int itemIndex;

	if ( itemExists( className , itemIndex ) ){
		//Add to an existing item's amount
		itm = itemList[ itemIndex ];
		stack( itm , amount );
	} else {
		itm = Spawn( className ,,,,,,true );
		itm.bIsInInventory = true;
		itm.setAmount( amount );
		itemList.AddItem( itm );
	}
}

private function stack( DELItem stackTo , int amount ){
	local int i , left;

	left = amount;

	for( i = 0; i < amount; i ++ ){
		if ( stackTo.getAmount() < stackTo.maxSize ){
			stackTo.setAmount( stackTo.getAmount() + 1 );
			left --;
		} else {
			//Spawn a new item or something.
			addItemToInventory( stackTo.Class , left );
		}
	}
}
/**
 * Removes an item from the itemlist.
 */
function remove( DELItem item ){
	itemList.RemoveItem( item );
}

/**
 * Clears the entire inventory.
 */
function clear(){
	local int i;

	for( i = 0; i < itemList.Length; i ++ ){
		itemList.RemoveItem( itemList[ i ] );
	}
}
/**
 * Checks whether an itemClass already exists in the inventory.
 * @param className class<DELItem>  The name of the class of the item to check for.
 * @param itemIndex int             Returns the index when the itemclass already exists whitin the inventory.
 */
function bool itemExists( class<DELItem> className , optional out int itemIndex ){
	local int i;

	for( i = 0; i < itemList.Length; i ++ ){
		if ( itemList[ i ].Class == className && itemList[ i ].getAmount() < itemList[ i ].maxSize ){
			itemIndex = i;
			return true;
		}
	}

	return false;
}

/**
 * Returns the instance of an item with a given classname in the itemList.
 */
function DELItem getItem( class<DELItem> className ){
	local DELItem item;

	foreach itemList( item ){
		if ( item.Class == className ) return item;
	}

	return none;
}

/**
 * Gets to total number of items of a specific class.
 */
function int getTotalAmount( class<DELItem> className ){
	local DELItem item;
	local int count;

	foreach itemList( item ){
		if ( item.Class == className ){
			count += item.getAmount();
		}
	}

	return count;
}
/**
 * Returns a list of all items.
 */
function array<DELItem> getItemList(){
	return itemList;
}

/**
 * Gives the player a standard inventory.
 */
function StartingInventory(){
	//self.addItemToInventory( class'DELItemWeaponDemonSlayer' , 1 );
	self.addItemToInventory( class'DELItemPotionHealth' , 5 );
	//self.addItemToInventory( class'DELItemWeaponTheButcher' , 1 );
}
DefaultProperties
{
}
