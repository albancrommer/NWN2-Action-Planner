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



// Removes the destination from oNPC
int DeleteDestination( object oNPC){
	DeleteLocalLocation(oNPC, VAR_EXPLORE_DESTINATION );
	return FALSE;
	
}


// Writes the default Location if none set yet 
location GetCombatControllerDefaultLocation( object oCombatController ){
	
	location lLoc 		= GetLocalLocation( oCombatController, VAR_COMB_CONT_DFLT_LOC );
	return lLoc;
	
}

// Checks if oNPC is close enough from Destination
int GetIsDestinationReached( object oNPC ){

	location lDestination 		= GetLocalLocation( oNPC, VAR_EXPLORE_DESTINATION );
	PrettyDebugLocation( lDestination, "orange");
	if( GetDistanceBetweenLocations( lDestination, GetLocation( oNPC ) ) < 1.0 ){
		//PrettyDebug( "GetIsDestinationReached::TRUE " );
		return TRUE;
	}
	//PrettyDebug( "GetIsDestinationReached::FALSE " );
	return FALSE;
	
}


// Checks if oNPC is being assigned to qualification
int GetIsQualifyingLocation( object oNPC ){

	int nQualifyRounds = GetLocalInt( oNPC, VAR_EXPLORE_QUAL_ROUNDS );
	if( nQualifyRounds > 0 ){
		nQualifyRounds--;
		//PrettyDebug( "GetIsQualifyingLocation::TRUE rounds left: "+IntToString( nQualifyRounds ) );
		SetLocalInt( oNPC, VAR_EXPLORE_QUAL_ROUNDS, nQualifyRounds );
		return TRUE;
	}
	//PrettyDebug( "GetIsQualifyingLocation::FALSE " );
	return FALSE;
	
}


// Checks if oNPC is currently moving to Destination
int GetIsHeadingToDestination( object oNPC ){

	location lDestination 		= GetLocalLocation( oNPC, VAR_EXPLORE_DESTINATION );
	if( !GetIsLocationValid( lDestination ) ){
		//PrettyDebug( "GetIsHeadingToDestination::INVALID LOCATION " );
		return FALSE;
	}
	//PrettyDebug( "GetIsHeadingToDestination::VALID LOCATION " );
	return TRUE;
	
}


// Checks in front of NPC to see if he can walk straight
// Also performs a check to see if oNPC is static for too long
int GetIsWalklineValid( object oNPC ){
	
	// Check positions in front of me
	int nI;
	location lLoc;
	float fDist;
	float fChunk 		= PARAM_WALKLINE_DIST;
	for( nI = 1; nI < PARAM_WALKLINE_DEPTH; nI++){
		fDist			+= fChunk;
		lLoc 			= GetAheadLocation( oNPC,fDist );
		if( !GetIsLocationValid( lLoc) ){
			return FALSE;
		}
	}
	
	// Check my own location
	location lSelf 		= GetLocation( oNPC );
	location lPrevious	= GetLocalLocation( oNPC, VAR_PREVIOUS_LOCATION );
	SetLocalLocation( oNPC, VAR_PREVIOUS_LOCATION, lSelf );
	if( lSelf != lPrevious ){
		SetLocalInt( oNPC, VAR_ROUNDS_BLOCKED, 0);
		return FALSE;
	}
	int nRoundsBlocked	= GetLocalInt( oNPC, VAR_ROUNDS_BLOCKED ) + 1;
	SetLocalInt( oNPC, VAR_ROUNDS_BLOCKED, nRoundsBlocked );
	if( nRoundsBlocked >= PARAM_MAX_ROUNDS_BLOCKED ){
		//PrettyDebug("GetIsWalklineValid::BLOCKED FOR TOO LONG");
		return FALSE;
	}
	
	return TRUE;
	
}


// Returns size of WP storage
int GetExploreWPCount( object oCombatController ){

	int nExploreWPCount 			= GetStorageCount( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
	//PrettyDebug( "GetExploreWPCount::nExploreWPCount "+IntToString( nExploreWPCount ) );
	return nExploreWPCount;
	
}

// Returns the max amount of wp stored on the controller
int GetMaxExploreWP( object oCombatController ){

	int nMaxExploreWP = GetLocalInt( oCombatController, VAR_EXPLORE_MAX_WP );
	//PrettyDebug("GetMaxExploreWP::nMaxExploreWP="+IntToString(nMaxExploreWP)); 
	return nMaxExploreWP;
}

// Writes the default Location if none set yet 
int SetCombatControllerDefaultLocation( object oCombatController, object oWP ){
	
	// Try to retrieve location
	location lLoc 		= GetLocalLocation( oCombatController, VAR_COMB_CONT_DFLT_LOC );
	if( GetIsObjectValid(GetAreaFromLocation(lLoc)) ){
		return FALSE;
	}
	// Set Default Location to the one of the WP provided
	lLoc			 	= GetLocation( oWP );
	SetLocalLocation( oCombatController, VAR_COMB_CONT_DFLT_LOC, lLoc );
	return TRUE;
	
}


// Compares Current size of exploration waypoint storage with max amount
int GetIsMaxExplorationWPLimitReached( object oCombatController ){

	int nCurrentStoredWPCount		= GetStorageCount( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
	int nMaxExploreWPCount			= GetMaxExploreWP( oCombatController );
	if( nCurrentStoredWPCount < nMaxExploreWPCount  ){
		return FALSE;
	}
	return TRUE;
}


// Retrieves a new Destination from the controller
int GetNewDestination( object oNPC ){

	location lDestination;
	object oCombatController 	= GetCombatControllerProxy( oNPC );
	if( !GetIsObjectValid( oCombatController) ){
		//PrettyDebug( "QualifyLocation::ERROR Invalid controller ");
		return FALSE;
	}
	// Checks if search area is expanding by comparing current / max wp for controller
	int nCurrentStoredWPCount		= GetStorageCount( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
	int nMaxExploreWPCount			= GetMaxExploreWP( oCombatController );
	int nSearchIndex			= GetLocalInt( oCombatController, VAR_EXPLORE_CONT_INDEX );
	//PrettyDebug( "GetNewDestination::nCurrentStoredWPCount #"+IntToString(nCurrentStoredWPCount)+" nMaxExploreWPCount:"+IntToString(nMaxExploreWPCount));
	if( !GetIsMaxExplorationWPLimitReached(oCombatController) && nSearchIndex < PARAM_EXPLORE_MAX_DEPTH ){
	
		// If so provides a new valid location to visit 
		int bSolved					= FALSE;
		location lDefaultLocation	= GetCombatControllerDefaultLocation( oCombatController );
		// Run a problem solution loop : has to be a valid location inside search depth limit to be solved
		while( !bSolved && nSearchIndex < PARAM_EXPLORE_MAX_DEPTH ){
		
			string sAngle				= Get2DAString( _2DA_EXPLORE, "angle", nSearchIndex );
			float fAngle				= StringToFloat( sAngle ) + GetFacingFromLocation(lDefaultLocation) ;
			string sDist				= Get2DAString( _2DA_EXPLORE, "distance", nSearchIndex );
			float fDist					= StringToFloat( sDist ) * COMBAT_ZONE_CHUNK;
			//PrettyDebug( "GetNewDestination::nSearchIndex #"+IntToString(nSearchIndex)+" sAngle:"+FloatToString(fAngle)+" sDist:"+FloatToString(fDist));
			lDestination 				= GenerateNewLocation( oCombatController, fDist, fAngle, fAngle );
			if( GetIsLocationValid( lDestination ) ){
				//PrettyDebug( "GetNewDestination::VALID "+LocationToString(lDestination) );
				bSolved 				= TRUE;
			}
			nSearchIndex++;
			SetLocalInt( oCombatController, VAR_EXPLORE_CONT_INDEX, nSearchIndex );
			
		}

	}	
	
	// Else provides Stored waypoint by getting a random WP in the list
	else{	
		//PrettyDebug( "GetNewDestination::USE STORED " );
		object oWPStorage				= GetStorage( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
		int nRand 						= Random( nCurrentStoredWPCount );
		object oWP						= GetVariableValueObject( oWPStorage, nRand );
		lDestination					= GetLocation( oWP );

	}
	
	if( GetIsLocationValid( lDestination ) ){
		//PrettyDebug( "GetNewDestination::new Location "+LocationToString(lDestination));
		SetLocalLocation( oNPC, VAR_EXPLORE_DESTINATION, lDestination );
		//PrettyDebugLocation( lDestination, "blue");
		return TRUE;
	}	
	//PrettyDebug( "GetNewDestination::NO LOCATION FOUND ");
	return FALSE;
	
}


// Attemps to create a new exploration Waypoing for oCombatController
// at oNPC location if the nearest waypoint  is invalid
int CreateNewExploreWaypoint( object oCombatController, object oNPC ){
	
	
	// Checks if creation is allowed
	if( GetIsMaxExplorationWPLimitReached( oCombatController ) ){
		return FALSE;}
	
	object oWP =  GetNearestObjectByTag( TAG_EXPLORE_WAYPOINT );
	if( GetIsObjectValid(oWP) && GetDistanceBetween(oNPC,oWP)<( COMBAT_ZONE_CHUNK - 1.0 ) ){
		return FALSE;}
	
	// Creates exploration waypoint
	int nFace				= Random( 180 );
	AssignCommand( oNPC, SetFacing( IntToFloat( nFace ) ) ); // Avoids all to similar explorations
	oWP						= CreateObject(OBJECT_TYPE_WAYPOINT, TAG_EXPLORE_WAYPOINT, GetLocation( oNPC), FALSE, TAG_EXPLORE_WAYPOINT);
	string sWPUID			= GetObjectUniqueId( oWP );
	//PrettyDebug( "######QualifyLocation::new WP "+sWPUID+"#######");
	PrettyDebugObjectLocation( oWP, "blue" );
	AddToStorageObject( oCombatController, STORAGE_EXPLORE_WAYPOINTS, sWPUID, oWP );	
	SetCombatControllerDefaultLocation( oCombatController, oWP );
	return TRUE;
}


// Performs the actual locomotion
int MoveToDestination( object oNPC ){
	
	location lDestination 		= GetLocalLocation( oNPC, VAR_EXPLORE_DESTINATION ); 
	//PrettyDebugLocation( lDestination, "orange");
	AssignCommand( oNPC, ClearAllActions( ) );
	AssignCommand( oNPC, ActionForceMoveToLocation( lDestination, PARAM_EXPLORE_RUN, 60.0 ) );
	
	// Attempt to create Waypoint at current location
	CreateNewExploreWaypoint( GetCombatControllerProxy( oNPC ), oNPC );
	
	// Attemps to open surrounding doors
	CheckNearbyDoors( oNPC );
	
	return FALSE;
	
}

// Returns the nearest exploration waypoint from oNPC
object GetNearestExplorationWaypoint( object oNPC){

	return GetNearestObjectByTag( TAG_EXPLORE_WAYPOINT );

}

// Performs the qualification 
int QualifyLocation( object oNPC, int bInitQualify = FALSE ){

	object oCombatController 		= GetCombatControllerProxy( oNPC );
	if( !GetIsObjectValid( oCombatController) ){
		//PrettyDebug( "QualifyLocation::ERROR Invalid controller ");
		return FALSE;
	}
	
	// Create waypoint if not around
	if( bInitQualify){
		//PrettyDebug( "QualifyLocation::bInitQualify TRUE ");
		SetLocalInt( oNPC, VAR_EXPLORE_QUAL_ROUNDS, PARAM_EXPLORE_QUAL_ROUNDS );
		CreateNewExploreWaypoint( oCombatController, oNPC );
	}
	
	// If no Waypoint around, nothing to qualify
	object oWP 						= GetNearestExplorationWaypoint( oNPC );
	if( !GetIsObjectValid( oWP ) ){
		//PrettyDebug( "QualifyLocation::ERROR Invalid WP ");
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