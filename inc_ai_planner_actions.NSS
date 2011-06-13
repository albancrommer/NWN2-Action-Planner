// inc_ai_planner_actions
/*
	Description:
	
*/
// Name_Date

#include "inc_ai_planner_const"
#include "ginc_debug"

int ExecuteTaskAction( object oNPC, string sAction ){
	//
	int bResult 			= TRUE;
	//
	ExecuteScript( ACTION_SCRIPT_PREFIX + sAction, oNPC );
	
	return bResult;
}