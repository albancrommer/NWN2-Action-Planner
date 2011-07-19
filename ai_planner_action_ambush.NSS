// ai_planner_action_explore
/*
	Description: Takes care of the NPC as a team exploration of the area
	
*/
// Name_Date

#include "ginc_debug"
#include "inc_vectors"
#include "X0_I0_POSITION"
#include "inc_ai_planner_const"
#include "inc_ai_planner_motivation_combat"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_locomotion"
#include "nw_i0_generic"


const int SWITCH_PATROL_NORESTRAINT 			= 1;
const int SWITCH_PATROL_AMBUSH_SUPPORT 			= 2;

// Provides destination for patrol supporting ambushes
int GetNewDestinationPatrolAmbushSupport( object oNPC ){

	location lDestination;
	object oCombatController 	= GetCombatControllerProxy( oNPC );
	if( !GetIsObjectValid( oCombatController) ){
		return FALSE;
	}
	
	// We want a Waypoint that is surrounding the Ambush point
	object oWP 					= GetLocalObject( oCombatController, VAR_QUALIFY_AMBUSH_WP );
	int nSurroundWPCount		= GetLocalInt( oWP, VAR_COUNT_SURROUND_WP );
	int nRand 					= Random( nSurroundWPCount ) +1;
	object oWanderWP			= GetNearestObjectByTag( TAG_EXPLORE_WAYPOINT, oWP, nRand );
	lDestination				= GetLocation( oWanderWP );
	if( GetIsLocationValid( lDestination ) ){
		SetLocalLocation( oNPC, VAR_MOVEMENT_DESTINATION, lDestination );
		return TRUE;
	}	
	return FALSE;

}



// Provides a destination for patrols with no special objectives
int GetNewDestinationPatrolNoRestraint( object oNPC ){

	location lDestination;
	object oCombatController 	= GetCombatControllerProxy( oNPC );
	if( !GetIsObjectValid( oCombatController) ){
		return FALSE;
	}
	// To emulate collaborative patrol, first check for nearby team member
	object oTeamMember				= GetNearestCreature( CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, oNPC );
	object oTeamStorage				= GetStorage( oCombatController, STORAGE_TEAM_MEMBERS );
	string sGUID					= GetObjectUniqueId( oTeamMember );
	// Does creature belong to team ?
	if( GetIsObjectValid( GetStorageObject( oCombatController, STORAGE_TEAM_MEMBERS, sGUID ) ) ){
		// Is creature close enough?
		if( GetIsObjectNearEnough( oTeamMember, oNPC, PARAM_COMBAT_ZONE_CHUNK ) ) {
			lDestination			= GetLocalLocation( oTeamMember, VAR_MOVEMENT_DESTINATION );
			// Is Location not reached ?
			if( !GetIsLocationNearEnough( GetLocation( oNPC ), lDestination ) ){
				SetLocalLocation( oNPC, VAR_MOVEMENT_DESTINATION, lDestination );
				return TRUE;
			}
		}
	}
	
	// Otherwise pick a random Waypoint
	object oWPStorage				= GetStorage( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
	int nCurrentStoredWPCount		= GetStorageCount( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
	int nRand 						= Random( nCurrentStoredWPCount );
	object oWP						= GetVariableValueObject( oWPStorage, nRand );
	lDestination					= GetLocation( oWP );
	if( GetIsLocationValid( lDestination ) ){
		SetLocalLocation( oNPC, VAR_MOVEMENT_DESTINATION, lDestination );
		return TRUE;
	}	
	return FALSE;

}

// Gets oNPC to move to the ambush wp and hide
int PositionAtAmbushPoint( object oNPC ){

	object oCombatController 	= GetCombatControllerProxy( oNPC );
	object oWP 					= GetLocalObject( oCombatController, VAR_QUALIFY_AMBUSH_WP );
	// Move to the WP
	if( GetDistanceBetween(  oNPC, oWP ) > 1.0 ){
		AssignCommand( oNPC, ActionForceMoveToObject( oWP, FALSE ) );
		return TRUE;
	}
	// Get stealthy
	if( !GetActionMode( oNPC, ACTION_MODE_STEALTH ) ){
		SetActionMode( oNPC, ACTION_MODE_STEALTH, TRUE );
	}
	return FALSE;
}

// Returns FALSE if oNPC is not heading to a destination
int RunLocomotionLoop( object oNPC, int bRun = FALSE ){

	if( GetIsHeadingToDestination( oNPC ) ){
		// If location reached, delete it and start qualifying
		if( GetIsDestinationReached( oNPC ) ){
			DeleteDestination( oNPC);
			return FALSE;
		}
		// Check if the location in front of me is valid
		if( GetIsWalklineValid( oNPC ) ){
			// Keep on walking : return
			MoveToDestination( oNPC, bRun );
			return TRUE;
		}
	}
	// Invalid location, cancel walk and get new location
	DeleteDestination( oNPC);
	return FALSE;

}

// Gets oNPC to patrol around near the ambush point
int PositionPatrol( object oNPC, int nAmbushType ){

	// Is on patrol
	if( RunLocomotionLoop( oNPC, FALSE ) ){
		PrettyDebug( "PositionPatrol::RunLocomotionLoop");
		return TRUE;
	}
	int nHasNewDestination;
	switch( nAmbushType ){
	
		case SWITCH_PATROL_NORESTRAINT:
			nHasNewDestination		= GetNewDestinationPatrolNoRestraint( oNPC );
		break;
		case SWITCH_PATROL_AMBUSH_SUPPORT:
			nHasNewDestination		= GetNewDestinationPatrolAmbushSupport( oNPC );
		break;

	}
	// Look for the next location and get there if valid
	if( nHasNewDestination ){
		MoveToDestination( oNPC );
		return TRUE;
	}
	//PrettyDebug( "PositionPatrol::FALSE");
	
	return FALSE;
	
}

// Gets oNPC to get ready for ambush
int AssignBehaviourAmbushCreate( object oNPC ){

	PositionAtAmbushPoint( oNPC );
	return FALSE;
	
}

int AssignBehaviourAmbushSupport( object oNPC ){

	if( GetHasRoleCaster( oNPC ) ){
	
	}
	if( GetHasRoleBuffer( oNPC ) ){
	
	}
	if( GetHasRoleRanged( oNPC ) ){
	
	}
	
	PositionPatrol( oNPC, SWITCH_PATROL_AMBUSH_SUPPORT );

	return FALSE;

}

int AssignBehaviourAmbushNone( object oNPC ){

	if( GetHasRoleCaster( oNPC ) ){
	
	}
	if( GetHasRoleBuffer( oNPC ) ){
	
	}
	if( GetHasRoleRanged( oNPC ) ){
	
	}
	
	PositionPatrol( oNPC, SWITCH_PATROL_NORESTRAINT );
	
	return FALSE;
	
}



// Main Loop
void main(){

	object oNPC 			= OBJECT_SELF;
	
	
	// Am I an ambusher? 
	if( GetHasRoleAmbush( oNPC ) ){
		AssignBehaviourAmbushCreate( oNPC );
		return;
	}

	// Is there any ambusher in team?
	if( GetCombatControllerHasRoleAmbush( oNPC ) ){
		AssignBehaviourAmbushSupport( oNPC );
		return;
	}
	
	// There is no ambush to set per se, let's just position ourself
	AssignBehaviourAmbushNone( oNPC );

//	ActionSpeakString("It's me, the Ambusher");

}