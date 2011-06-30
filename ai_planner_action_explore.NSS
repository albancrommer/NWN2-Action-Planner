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



// record on NPC : last location target VAR_EXPLORE_DESTINATION
// record on NPC : qualifying round time VAR_EXPLORE_QUAL_ROUNDS
// record on controller : last location # VAR_EXPLORE_CONT_INDEX
// storage on controller : waypoints STORAGE_EXPLORE_WAYPOINTS

// Removes the destination from oNPC
int DeleteDestination( object oNPC){

	DeleteLocalLocation(oNPC, VAR_EXPLORE_DESTINATION );
	return FALSE;
	
}


// Checks if oNPC is close enough from Destination
int GetIsDestinationReached( object oNPC ){

	location lDestination 		= GetLocalLocation( oNPC, VAR_EXPLORE_DESTINATION );
	if( GetDistanceBetweenLocations( lDestination, GetLocation( oNPC ) ) < 2.0 ){
		PrettyDebug( "GetIsDestinationReached::TRUE " );
		return TRUE;
	}
	PrettyDebug( "GetIsDestinationReached::FALSE " );
	return FALSE;
	
}


// Checks if oNPC is being assigned to qualification
int GetIsQualifyingLocation( object oNPC ){

	int nQualifyRounds = GetLocalInt( oNPC, VAR_EXPLORE_QUAL_ROUNDS );
	if( nQualifyRounds > 0 ){
		nQualifyRounds--;
		PrettyDebug( "GetIsQualifyingLocation::TRUE rounds left: "+IntToString( nQualifyRounds ) );
		SetLocalInt( oNPC, VAR_EXPLORE_QUAL_ROUNDS, nQualifyRounds );
		return TRUE;
	}
	PrettyDebug( "GetIsQualifyingLocation::FALSE " );
	return FALSE;
	
}


// Checks if oNPC is currently moving to Destination
int GetIsHeadingToDestination( object oNPC ){

	location lDestination 		= GetLocalLocation( oNPC, VAR_EXPLORE_DESTINATION );
	if( !GetIsLocationValid( lDestination ) ){
		PrettyDebug( "GetIsHeadingToDestination::INVALID LOCATION " );
		return FALSE;
	}
	PrettyDebug( "GetIsHeadingToDestination::VALID LOCATION " );
	return TRUE;
	
}


// Checks in front of NPC to see if he can walk straight
int GetIsWalklineValid( object oNPC ){

	int nI;
	location lLoc;
	float fDist;
	float fChunk 	= PARAM_WALKLINE_DIST;
	for( nI = 1; nI < PARAM_WALKLINE_DEPTH; nI++){
		fDist		+= fChunk;
		lLoc = GetAheadLocation( oNPC,fDist );
		if( !GetIsLocationValid( lLoc) ){
			return FALSE;
		}
	}
	return TRUE;
	
}

// Returns size of WP storage
int GetExploreWPCount( object oCombatController ){

	int nExploreWPCount 			= GetStorageCount( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
	PrettyDebug( "GetExploreWPCount::nExploreWPCount "+IntToString( nExploreWPCount ) );
	return nExploreWPCount;
	
}


// Retrieves a new Destination from the controller
int GetNewDestination( object oNPC ){
	location lDestination;
	object oCombatController 	= GetCombatControllerProxy( oNPC );
	if( !GetIsObjectValid( oCombatController) ){
		PrettyDebug( "QualifyLocation::ERROR Invalid controller ");
		return FALSE;
	}
	
	// Modify : 
	// Checks if search area is expanding
	// Else provides Stored waypoint 
	
	int nSearchIndex			= GetLocalInt( oCombatController, VAR_EXPLORE_CONT_INDEX );
	SetLocalInt( oCombatController, VAR_EXPLORE_CONT_INDEX, ++nSearchIndex );
	string sAngle				= Get2DAString( _2DA_EXPLORE, "angle", nSearchIndex );
	float fAngle				= StringToFloat( sAngle );
	string sDist				= Get2DAString( _2DA_EXPLORE, "distance", nSearchIndex );
	float fDist					= StringToFloat( sDist ) * COMBAT_ZONE_CHUNK;
	PrettyDebug( "GetNewDestination::nSearchIndex #"+IntToString(nSearchIndex)+" sAngle:"+sAngle+" sDist:"+FloatToString(fDist));
	
	location lController		= GetLocation( oCombatController );
	lDestination 		= LocAtAngleToLocFacing( lController, fDist, fAngle, fAngle );
	SetLocalLocation( oNPC, VAR_EXPLORE_DESTINATION, lDestination );
	PrettyDebug( "GetNewDestination::new Location "+LocationToString(lDestination));
	PrettyDebugLocation( lDestination, "blue");
	return FALSE;
	
}

// Performs the actual locomotion
int MoveToDestination( object oNPC ){
	
	location lDestination 		= GetLocalLocation( oNPC, VAR_EXPLORE_DESTINATION ); 
	AssignCommand( oNPC, ClearAllActions( ) );
	AssignCommand( oNPC, ActionForceMoveToLocation( lDestination, FALSE, 60.0 ) );

	return FALSE;
	
}


// Performs the qualification 
int QualifyLocation( object oNPC, int bInitQualify = FALSE ){

	object oCombatController 		= GetCombatControllerProxy( oNPC );
	if( !GetIsObjectValid( oCombatController) ){
		PrettyDebug( "QualifyLocation::ERROR Invalid controller ");
		return FALSE;
	}
	object oWP 						= GetNearestObjectByTag( TAG_EXPLORE_WAYPOINT );
	
	// Create waypoint if not around
	if( bInitQualify){
		PrettyDebug( "QualifyLocation::bInitQualify TRUE ");
		SetLocalInt( oNPC, VAR_EXPLORE_QUAL_ROUNDS, PARAM_EXPLORE_QUAL_ROUNDS );
	 	if( !GetIsObjectValid(oWP) || GetDistanceBetween(oNPC,oWP)>( COMBAT_ZONE_CHUNK - 3.0 ) ){
			oWP						= CreateObject(OBJECT_TYPE_WAYPOINT, TAG_EXPLORE_WAYPOINT, GetLocation( oNPC), FALSE, TAG_EXPLORE_WAYPOINT);
			string sWPUID			= GetObjectUniqueId( oWP );
			PrettyDebug( "QualifyLocation::new WP "+sWPUID);
			AddToStorageObject( oCombatController, STORAGE_EXPLORE_WAYPOINTS, sWPUID, oWP );			
		}
	}
	if( !GetIsObjectValid( oWP) ){
		PrettyDebug( "QualifyLocation::ERROR Invalid WP ");
		return FALSE;
	}
	
	// Dig more
	
	return FALSE;
	
}


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
			MoveToDestination( oNPC );
			return;
		}
		// Invalid location, cancel walk and get new location
		DeleteDestination( oNPC);
	}
	// Look for the next location
	GetNewDestination( oNPC );
	// If a location was found, go to the location
	MoveToDestination( oNPC );

}