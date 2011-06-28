// script_name
/*
	Description:
	
*/
// Name_Date

#include "inc_ai_planner_const"
#include "inc_ai_planner_motivation_combat"
#include "ginc_debug"

void main()
{
	object oCombatController = OBJECT_SELF;
	PrettyDebug( "Combat Controller HB" );
	
	// This takes care of all computation regarding the team
	// strategies. 
	RunControllerLoop( oCombatController );
	
}