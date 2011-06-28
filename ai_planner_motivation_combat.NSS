// script_name
/*

	
	 
	
*/
// Alban 1106


#include "inc_ai_planner_const"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_worldstate"
#include "inc_ai_planner_motivations_limit"
#include "inc_ai_planner_motivation_combat"



int UpdateWorldState_Combat( object oNPC ) {

	// Being in combat can be caused by 
	// 1. Social interactions gone bad :: TODO
	// 2. Creatures designed to be grinded

	if( GetLocalInt( oNPC, VAR_FORCED_COMBAT ) ) {
		SetWorldState( oNPC , COMBAT, TRUE );
		PrettyDebug( "Forced Combat") ;
	}
	
	return TRUE;


}


int GetMotivation_Combat( object oNPC ) {

	//
	// mechanics of combat is done at controller level, so it looks easy here
	// but controller on each round will reshape the team's strategy and tactics
	//  
	if( GetWorldState( oNPC, COMBAT ) ) {
	
		// returns or create the combat controller
		object oCombatController = GetCombatControllerProxy( oNPC );
		
		// Assigns one or many goals through controller
		if( AssignCombatGoals( oNPC, oCombatController ) ){
			return TRUE;
		}
		
	}

	return FALSE;
}