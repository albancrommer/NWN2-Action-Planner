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


// Main Loop
void main(){

	object oNPC 				= OBJECT_SELF;
	// Check if I'm qualifying a location
	if( GetIsQualifyingLocation( oNPC ) ){
		// Keep on digging : return 
		QualifyLocation( oNPC );
		return;
	}
	// Check if I'm walking to a new location
	else if( GetIsHeadingToDestination( oNPC ) ){
		// If location reached, delete it and start qualifying
		if( GetIsDestinationReached( oNPC ) ){
			DeleteDestination( oNPC);
			QualifyLocation( oNPC, TRUE );
			return;
		}
		// Check if the location in front of me is valid
		if( GetIsWalklineValid( oNPC ) ){
		
			// Keep on walking : return
			MoveToExplorationDestination( oNPC );
			return;
		}
		// Invalid location, cancel walk and get new location
		DeleteDestination( oNPC);
	}
	// Look for the next location
	GetNewDestinationExploration( oNPC );
	// If a location was found, go to the location
	MoveToExplorationDestination( oNPC );

}