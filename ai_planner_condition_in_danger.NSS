// ai_planner_condition_
/*
	Condition for AI Planner system
	
*/
// Alban 1008

#include "inc_ai_planner_datacontroller"
#include "ginc_debug"

// TODO : implement in_danger
void main()
{

	object oNPC					= OBJECT_SELF;
	//
	int bResult;
	
	bResult 					=  TRUE;
	
	SetLocalInt( oNPC, CONDITION_RESULT, bResult );

}