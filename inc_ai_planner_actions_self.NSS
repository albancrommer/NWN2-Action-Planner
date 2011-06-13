// script_name
/*
	Description:
	
*/
// Name_Date


#include "ai_planner_motivation_self"
#include "X0_I0_POSITION"

// TODO : DELETE THIS SCRIPT
/*
int Action_Eat( object oNPC ) {

	AssignCommand( oNPC, ActionSpeakString( "I'm hungry" ) );
	//
	if( GetDistanceBetween( oNPC, GetNearestObjectByTag( "food" ) ) < 4.0 ) {
		
		SetHunger( oNPC, GetHunger( oNPC ) - 1.0f );
		//
		AssignCommand( oNPC, PlayAnimation( ANIMATION_LOOPING_COOK02 ) );
		
	}
	
	return TRUE;

}


int Action_Sleep( object oNPC ) {
		
	AssignCommand( oNPC, ActionSpeakString( "I'm sleepy" ) );
	//
	if( GetDistanceBetween( oNPC, GetNearestObjectByTag( "bed" ) ) < 4.0 ) {
		//
		SetFatigue( oNPC, GetFatigue( oNPC ) - 1.0f );
		//
		AssignCommand( oNPC, PlayAnimation( ANIMATION_LOOPING_DEAD_BACK ) );
	}

	return TRUE;

}


// TODO : Waypoint and variable for NPC chat + hook function for chat
int Action_Idle( object oNPC ) {

	object oC				= GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oNPC );
	//
	if( GetIsObjectValid( oC ) && GetDistanceBetween( oC, oNPC ) < 10.0 ) {
		
		AssignCommand( oNPC, ActionSpeakString( "You're looking good" ) );
		//
		AssignCommand( oNPC, ActionForceMoveToObject( oC, FALSE, 3.0f ) );
		//
		TurnToFaceObject( oC, oNPC );
		
	}
	else if( 	GetIsObjectValid( oC = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oNPC ) ) 
				&& GetDistanceBetween( oC, oNPC ) < 10.0 
			)  {
		
		AssignCommand( oNPC, ActionSpeakString( "<i>Blah blah</i>" ) );
		//
		AssignCommand( oNPC, ActionForceMoveToObject( oC, FALSE, 3.0f ) );
		//
		TurnToFaceObject( oC, oNPC );
		
	}
	//
	return TRUE;
		
}


int Action_NearObject( object oNPC ){
		
	object oTarget		= GetLocalObject( oNPC, TARGET );
	//
	AssignCommand( oNPC, ActionForceMoveToObject( oTarget, FALSE, 1.0 ) );
	//
	return TRUE;
	
}
*/