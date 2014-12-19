class DELSeqAct_SwitchSword extends DELSequenceAction
native(Sequence);

cpptext
{
	virtual void PostLoad();
	virtual void Activated();
};


DefaultProperties
{
	ObjName="Toggle Sword"
	
	InputLinks(0)=(LinkDesc="Enable")
	InputLinks(1)=(LinkDesc="Disable")
	InputLinks(2)=(LinkDesc="Toggle")
	
	VariableLinks(0)=(bModifiesLinkedObject=true)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Bool",MinVars=0)
}
