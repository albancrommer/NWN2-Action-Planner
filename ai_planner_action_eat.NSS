// script_name
/*
	Description:
	
*/
// Name_Date



#include "ai_planner_motivation_self"
#include "X0_I0_POSITION"


void main() {
	
	object oNPC		= OBJECT_SELF;
	//
	AssignCommand( oNPC, ActionSpeakString( "I'm hungry" ) );
	//
	if( GetDistanceBetween( oNPC, GetNearestObjectByTag( "food" ) ) < 4.0 ) {
		
		SetHunger( oNPC, GetHunger( oNPC ) - 1.0f );
		//
		AssignCommand( oNPC, PlayAnimation( ANIMATION_LOOPING_COOK02 ) );
		
	}

}