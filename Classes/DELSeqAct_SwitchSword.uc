class DELSeqAct_SwitchSword extends SequenceAction;


DefaultProperties
{
	ObjName="Toggle Sword"
	ObjCategory="Delmor"
	
	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")
	InputLinks(2)=(LinkDesc="Toggle")
	
	VariableLinks(0)=(bModifiesLinkedObject=true)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Bool",MinVars=0)
}
