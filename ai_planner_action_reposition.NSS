// ai_planner_action_explore
/*
	Description: Takes care of the NPC as a team exploration of the area
	
*/
// Name_Date

#include "ginc_debug"
#include "inc_vectors"
#include "X0_I0_POSITION"
#include "inc_ai_planner_motivation_combat"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_locomotion"



// Returns a team 
object GetPositionForReposition( object oNPC ){

	object oCombatController 	= GetCombatControllerProxy( oNPC );
	object oS					= GetStorage( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
	// Easy cut : return to first position
	return GetVariableValueObject( oS, 0 );

}

// Main Loop
void main(){

	object oNPC 		= OBJECT_SELF;
	
	object oWP			= GetPositionForReposition( oNPC );
	
	AssignCommand( oNPC, ActionForceMoveToObject( oWP, TRUE ) );


}