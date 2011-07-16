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

// returns FALSE if the combat controller has no ambush role member
int GetCombatControllerHasRoleAmbush( object oNPC ){

	object oCombatController 	= GetCombatControllerProxy( oNPC );
	return GetLocalInt( oCombatController, VAR_HAS_ROLE_AMBUSH );

}


// 
// returns FALSE if oNPC has no ambushing skills
// Cached data : -1 => No ability / >1 => Has Ability
int GetHasRoleAmbush( object oNPC ){

	// Check cached value first
	int nHasRole 		= GetLocalInt( oNPC, VAR_HAS_ROLE_AMBUSH );
	if( -1 == nHasRole ){return FALSE;}
	if( 0 < nHasRole ) {return TRUE;}
	
	
	// Perform checks and cache the result
	nHasRole 			+= GetHasFeat( FEAT_SNEAK_ATTACK, oNPC, TRUE );
	nHasRole 			+= GetSkillRank( SKILL_HIDE, oNPC ) > 10 ;
	
	// Has Role
	if( 0 < nHasRole ){
	PrettyDebug( "GetHasRoleAmbush::Is ambusher "+GetName( oNPC ) );
		object oCombatController 	= GetCombatControllerProxy( oNPC );
		SetLocalInt( oCombatController, VAR_HAS_ROLE_AMBUSH, TRUE );
		SetLocalInt( oNPC, VAR_HAS_ROLE_AMBUSH, TRUE );
	 	return TRUE;
	}
	
	// Has not
	SetLocalInt( oNPC, VAR_HAS_ROLE_AMBUSH, -1 );
	return FALSE;

}



// returns FALSE if oNPC has no casting skills
// Cached data : -1 => No ability / >1 => Has Ability
int GetHasRoleCaster( object oNPC ){

	// Check cached value first
	int nHasRole 		= GetLocalInt( oNPC, VAR_HAS_ROLE_CASTER );
	if( -1 == nHasRole ){return FALSE;}
	if( 0 < nHasRole ) {return TRUE;}
	
	// Perform checks and cache the result
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_WIZARD, oNPC );
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_SORCERER, oNPC );
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_ARCANE_SCHOLAR, oNPC );
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_ELDRITCH_KNIGHT, oNPC );
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_HELLFIRE_WARLOCK, oNPC );
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_PALEMASTER, oNPC );
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_RED_WIZARD, oNPC );
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_WARLOCK, oNPC );
	
	// Has Role
	if( 0 < nHasRole ){
	PrettyDebug( "GetHasRoleCaster::Is caster "+GetName( oNPC ) );
		object oCombatController 	= GetCombatControllerProxy( oNPC );
		SetLocalInt( oCombatController, VAR_HAS_ROLE_CASTER, TRUE );
		SetLocalInt( oNPC, VAR_HAS_ROLE_CASTER, TRUE );
	 	return TRUE;
	}
	
	// Has not
	SetLocalInt( oNPC, VAR_HAS_ROLE_CASTER, -1 );
	return FALSE;
}
// returns FALSE if oNPC has no buffing skills
// Cached data : -1 => No ability / >1 => Has Ability
int GetHasRoleBuffer( object oNPC ){
	
	// Check cached value first
	int nHasRole 		= GetLocalInt( oNPC, VAR_HAS_ROLE_BUFFER );
	if( -1 == nHasRole ){return FALSE;}
	if( 0 < nHasRole ) {return TRUE;}
	
	// Perform checks and cache the result
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_BARD, oNPC );
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_CLERIC, oNPC );
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_DRUID, oNPC );
	nHasRole 			+= GetLevelByClass( CLASS_TYPE_ELEMENTAL, oNPC );

	
	// Has Role
	if( 0 < nHasRole ){
	PrettyDebug( "GetHasRoleBuffer::Is buffer "+GetName( oNPC ) );
		object oCombatController 	= GetCombatControllerProxy( oNPC );
		SetLocalInt( oCombatController, VAR_HAS_ROLE_BUFFER, TRUE );
		SetLocalInt( oNPC, VAR_HAS_ROLE_BUFFER, TRUE );
	 	return TRUE;
	}
	
	// Has not
	SetLocalInt( oNPC, VAR_HAS_ROLE_BUFFER, -1 );
	return FALSE;

}


// returns FALSE if oNPC has no ranged skills
// Cached data : -1 => No ability / >1 => Has Ability
int GetHasRoleRanged( object oNPC ){

	// Check cached value first
	int nHasRole 		= GetLocalInt( oNPC, VAR_HAS_ROLE_RANGED );
	if( -1 == nHasRole ){return FALSE;}
	if( 0 < nHasRole ) {return TRUE;}
	
	// Perform checks and cache the result
		nHasRole 			+= GetHasFeat( FEAT_WEAPON_FOCUS_DART, oNPC );
		nHasRole 			+= GetHasFeat( FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, oNPC );
		nHasRole 			+= GetHasFeat( FEAT_WEAPON_FOCUS_LONGBOW, oNPC );
		nHasRole 			+= GetHasFeat( FEAT_WEAPON_FOCUS_SHORTBOW, oNPC );
		nHasRole 			+= GetHasFeat( FEAT_WEAPON_FOCUS_SHURIKEN, oNPC );
		nHasRole 			+= GetHasFeat( FEAT_WEAPON_FOCUS_SLING, oNPC );
		nHasRole 			+= GetHasFeat( FEAT_WEAPON_FOCUS_THROWING_AXE, oNPC );
		nHasRole 			+= GetHasFeat( CLASS_TYPE_WARLOCK, oNPC );
	// Has Role
	if( 0 < nHasRole ){
	PrettyDebug( "GetHasRoleRanged::Is ranged "+GetName( oNPC ) );
		object oCombatController 	= GetCombatControllerProxy( oNPC );
		SetLocalInt( oCombatController, VAR_HAS_ROLE_RANGED, TRUE );
		SetLocalInt( oNPC, VAR_HAS_ROLE_RANGED, TRUE );
	 	return TRUE;
	}
	
	// Has not
	SetLocalInt( oNPC, VAR_HAS_ROLE_RANGED, -1 );
	return FALSE;
}

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