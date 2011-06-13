// script_name
/*
	Description:
	
*/
// Name_Date



#include "ai_planner_motivation_self"
#include "X0_I0_POSITION"
#include "ginc_debug"


void main() {

	object oNPC				= OBJECT_SELF;
	//
	object oC				= GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oNPC );
	//
	if( GetIsObjectValid( oC ) && GetDistanceBetween( oC, oNPC ) < 10.0 && GetObjectSeen( oC, oNPC ) ) {
		
//		AssignCommand( oNPC, ActionSpeakString( "You're looking good" ) );
		//
//		AssignCommand( oNPC, ActionForceMoveToObject( oC, FALSE, 3.0f ) );
		//
		TurnToFaceObject( oC, oNPC );
		
	}
	else if( 	GetIsObjectValid( oC = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oNPC ) ) 
				&& GetDistanceBetween( oC, oNPC ) < 10.0 
			)  {
		
//		AssignCommand( oNPC, ActionSpeakString( "<i>Blah blah</i>" ) );
		//
//		AssignCommand( oNPC, ActionForceMoveToObject( oC, FALSE, 3.0f ) );
		//
		TurnToFaceObject( oC, oNPC );
		
	}

}