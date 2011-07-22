// ai_planner_action_reposition
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
location GetPositionForReposition( object oNPC ){

	object oCombatController 	= GetCombatControllerProxy( oNPC );
	location lLoc 				= GetLocalLocation( oCombatController, VAR_MAIN_GROUP_LOCATION );
	if( GetIsLocationValid( lLoc ) ){
		//PrettyDebug( "(ai_planner_action_reposition)Returning Main Team Location");
		return lLoc;
	}
		
	// Easy cut : return to first position
	//PrettyDebug( "(ai_planner_action_reposition)Returning Default position");
	object oS					= GetStorage( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
	return GetLocation( GetVariableValueObject( oS, 0 ) );

}

// Main Loop
void main(){

	object oNPC 		= OBJECT_SELF;
	
	location lLoc		= GetPositionForReposition( oNPC );
	
	AssignCommand( oNPC, ActionMoveToLocationEnhanced( oNPC, lLoc, TRUE ) );


}