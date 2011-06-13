// script_name
/*
	Description:
	
*/
// Name_Date



#include "ai_planner_motivation_self"
#include "X0_I0_POSITION"
#include "ginc_debug"


void main() {
	
	object oNPC			= OBJECT_SELF;
	//
	object oTarget		= GetLocalObject( oNPC, TARGET );
	//
	AssignCommand( oNPC, ActionForceMoveToObject( oTarget, FALSE, 1.0 ) );

}