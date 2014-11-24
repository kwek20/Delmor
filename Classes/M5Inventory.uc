class M5Inventory extends Inventory;

/* 
 * This class exists, both to provide a convenience function, and also
 * because 'Inventory' is abstract.
 * It's mostly just a demo class to show off M5InvDisplay
 */

// SuperClass has:  string ItemName
// SuperClass has:  DroppedPickupMesh
// SuperClass has:  PickupFactoryMesh
 

 /** This creats a new M5Inventory object in the inventory of
  * the specified Pawn. You arent expected to do anything with the
  * return value. Its just there to check for null if you are paranoid.
  */
 static function M5Inventory NewM5Item(Pawn P, StaticMesh mesh)
 {
	local M5Inventory newobj;
	local StaticMeshComponent tmpSMC;
	
	newobj=M5Inventory(P.CreateInventory(class'M5Inventory'));
	tmpSMC=new class'StaticMeshComponent';
	tmpSMC.SetStaticMesh(mesh);
	newobj.DroppedPickupMesh=tmpSMC;
	
	return newobj;
 }
 
 defaultproperties {

 }