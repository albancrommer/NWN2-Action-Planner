// ai_planner_condition_
/*
	Condition for AI Planner system
	
*/
// Alban 1008

#include "inc_ai_planner_datacontroller"
#include "ginc_debug"


void main()
{

	object oNPC					= OBJECT_SELF;
	//
	int bResult;
	//
	if( GetIsObjectValid( GetNearestObjectByTag( "food", oNPC ) ) ) {
	
		bResult = TRUE;
		//
		SetLocalObject( oNPC, TARGET, GetNearestObjectByTag( "food", oNPC ) );
	
	}
	else bResult 		= FALSE;
	SetLocalInt( oNPC, CONDITION_RESULT, bResult );

}