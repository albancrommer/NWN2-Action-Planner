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
	//PrettyDebug( "Combat Controller HB" );
	
	// This takes care of all computation regarding the team
	// strategies. 
	// @see: inc_ai_planner_motivation_combat
	RunControllerLoop( oCombatController );
	object oRangedWP			= GetLocalObject( oCombatController, VAR_QUALIFY_RANGED_WP );
	object oAmbushWP			= GetLocalObject( oCombatController, VAR_QUALIFY_AMBUSH_WP );
	PrettyDebugObjectLocation( oRangedWP, "blue");
	PrettyDebugObjectLocation( oAmbushWP, "orange");
	
}