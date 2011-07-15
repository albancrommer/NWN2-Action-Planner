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
location GetCombatControllerDefaultLocation( object oCombatController, object oNPC ){

	location lDefaultLoc	= GetLocalLocation( oCombatController, VAR_COMB_CONT_DFLT_LOC );
	if( GetIsLocationValid( lDefaultLoc ) ) {
		return lDefaultLoc;
	}
	float fNewFace			= IntToFloat( Random( 180 ) ) + GetFacing( oNPC );
	lDefaultLoc				= GenerateNewLocation( oNPC, 0.0, fNewFace, fNewFace );
	SetLocalLocation( oCombatController, VAR_COMB_CONT_DFLT_LOC, lDefaultLoc );
	return lDefaultLoc;
	
}


// Instead of calculating a distance without taking the Z axis into account
// I prefer comparing x and y for PARAM_CLOSE_ENOUGH
int GetIsLocationNearEnough( location l1, location l2 ){

	vector v = GetPositionFromLocation(l1) - GetPositionFromLocation(l2);
 	//PrettyDebug( "GetIsLocationNearEnough::"+VectorToString( v ) );
	if( v.x <= PARAM_CLOSE_ENOUGH && v.y <= PARAM_CLOSE_ENOUGH )
 		return TRUE;
		
	return FALSE;
}

// Checks if oNPC is close enough from Destination
int GetIsDestinationReached( object oNPC ){

	location lDestination 		= GetLocalLocation( oNPC, VAR_EXPLORE_DESTINATION );
	//PrettyDebugLocation( lDestination, "orange");
	if( GetIsLocationNearEnough( lDestination, GetLocation( oNPC ) ) ){
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
		return TRUE;
	}
	int nRoundsBlocked	= GetLocalInt( oNPC, VAR_ROUNDS_BLOCKED ) + 1;
	SetLocalInt( oNPC, VAR_ROUNDS_BLOCKED, nRoundsBlocked );
	if( nRoundsBlocked >= PARAM_MAX_ROUNDS_BLOCKED ){
		//PrettyDebug("GetIsWalklineValid::BLOCKED FOR TOO LONG");
		return FALSE;
	}
	
	return TRUE;
	
}


// Returns the max amount of wp stored on the controller
int GetMaxExploreWP( object oCombatController ){

	int nMaxExploreWP = GetLocalInt( oCombatController, VAR_EXPLORE_MAX_WP );
	//PrettyDebug("GetMaxExploreWP::nMaxExploreWP="+IntToString(nMaxExploreWP)); 
	return nMaxExploreWP;
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

// Compares the current search index to the max value 
int GetIsIndexExplorationWPLimitReached(object oCombatController){

	int nSearchIndex				= GetLocalInt( oCombatController, VAR_EXPLORE_CONT_INDEX );
	if( nSearchIndex < PARAM_EXPLORE_MAX_DEPTH ){
//		//PrettyDebug( "GetIsIndexExplorationWPLimitReached::FALSE");
		return FALSE;
	}
	// resets the index and the default location, so we're searching at a different angle
	int nCurrentResetCount			= GetLocalInt( oCombatController, VAR_EXPLORE_RESET_COUNT );
	if(  nCurrentResetCount < PARAM_EXPLORE_MAX_RESET ){
	
		//PrettyDebug( "GetIsIndexExplorationWPLimitReached::LIMIT REACHED nCurrentResetCount:"+IntToString( nCurrentResetCount )+"/"+IntToString( PARAM_EXPLORE_MAX_RESET ));
		SetLocalInt( oCombatController, VAR_EXPLORE_RESET_COUNT, ++nCurrentResetCount );
		SetLocalInt( oCombatController, VAR_EXPLORE_CONT_INDEX, 1);
		location lOldLoc			= GetLocalLocation( oCombatController, VAR_COMB_CONT_DFLT_LOC );
		float fNewFace				= PARAM_EXPLORE_ITER_ANG + GetFacingFromLocation( lOldLoc );
		object oArea				= GetArea( oCombatController );
	    vector vNewPos 				= GetChangedPosition(GetPositionFromLocation(lOldLoc),
                                    	0.0,
                                    	fNewFace);
     	location lDefaultLoc		= Location(oArea, vNewPos, fNewFace);
		SetLocalLocation( oCombatController, VAR_COMB_CONT_DFLT_LOC, lDefaultLoc );
		return FALSE;
	}
//	//PrettyDebug( "GetIsIndexExplorationWPLimitReached::TRUE");
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
	int nSearchIndex				= GetLocalInt( oCombatController, VAR_EXPLORE_CONT_INDEX );
	//PrettyDebug( "GetNewDestination::nCurrentStoredWPCount #"+IntToString(nCurrentStoredWPCount)+" nMaxExploreWPCount:"+IntToString(nMaxExploreWPCount));
	if( !GetIsMaxExplorationWPLimitReached(oCombatController) && !GetIsIndexExplorationWPLimitReached( oCombatController ) ){
	
		// If so provides a new valid location to visit 
		int bSolved					= FALSE;
		location lDefaultLocation	= GetCombatControllerDefaultLocation( oCombatController, oNPC );
		// Run a problem solution loop : has to be a valid location inside search depth limit to be solved
		while( !bSolved && nSearchIndex < PARAM_EXPLORE_MAX_DEPTH ){
		
			string sAngle				= Get2DAString( _2DA_EXPLORE, "angle", nSearchIndex );
			float fAngle				= StringToFloat( sAngle ) + GetFacingFromLocation(lDefaultLocation) ;
			string sDist				= Get2DAString( _2DA_EXPLORE, "distance", nSearchIndex );
			float fDist					= StringToFloat( sDist ) * PARAM_COMBAT_ZONE_CHUNK;
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
	
	//PrettyDebug( "##()CreateNewExploreWaypoint::CALL");
	
	// Checks if creation is allowed
	if( GetIsMaxExplorationWPLimitReached( oCombatController ) ){
		return FALSE;}
	
	object oWP =  GetNearestObjectByTag( TAG_EXPLORE_WAYPOINT );
	if( GetIsObjectValid(oWP) && GetDistanceBetween(oNPC,oWP)<( PARAM_COMBAT_ZONE_CHUNK - 1.0 ) ){
		return FALSE;}
	
	// Creates exploration waypoint
	location lDefaultLoc	= GetCombatControllerDefaultLocation( oCombatController, oNPC );
	float fNewFace			= IntToFloat( Random( 180 ) ) + GetFacing( oNPC );
	location lNewLoc		= GenerateNewLocation( oNPC, 0.0, fNewFace, fNewFace );
	oWP						= CreateObject(OBJECT_TYPE_WAYPOINT, TAG_EXPLORE_WAYPOINT, lNewLoc, FALSE, TAG_EXPLORE_WAYPOINT);
	string sWPUID			= GetObjectUniqueId( oWP );
	//PrettyDebug( "##CreateNewExploreWaypoint::NewFacing ="+FloatToString(fNewFace) );
	//PrettyDebug( "##CreateNewExploreWaypoint::new WP "+sWPUID+" @"+LocationToString( lNewLoc ) +"#######");
	//PrettyDebugObjectLocation( oWP, "blue" );
	
	// We're setting an arbitrary really low value for the var used in QualifyLocationDig
	SetLocalFloat( oWP, VAR_COMB_WP_HEIGHT_RATIO, -1.0);
	AddToStorageObject( oCombatController, STORAGE_EXPLORE_WAYPOINTS, sWPUID, oWP );	
	return TRUE;
}


// Performs the actual locomotion
int MoveToDestination( object oNPC ){
	
	location lDestination 		= GetLocalLocation( oNPC, VAR_EXPLORE_DESTINATION ); 
	//PrettyDebugLocation( lDestination, "orange");
	AssignCommand( oNPC, ClearAllActions( ) );
	AssignCommand( oNPC, ActionForceMoveToLocation( lDestination, PARAM_EXPLORE_RUN, 60.0 ) );
	
	// Attempt to create Waypoint at current location
	object oCombatController = GetCombatControllerProxy( oNPC );
	if( GetIsIndexExplorationWPLimitReached(oCombatController) && !GetIsMaxExplorationWPLimitReached( oCombatController ) ){
		//PrettyDebug( "MoveToDestination::TRYING TO LAY NEW WAYPOINT"+IntToString(GetStorageCount( oCombatController, STORAGE_EXPLORE_WAYPOINTS ))+"/"+IntToString(GetMaxExploreWP( oCombatController ) ));
		CreateNewExploreWaypoint( GetCombatControllerProxy( oNPC ), oNPC );
	}
	else {
		// //PrettyDebug( "MaxExplorationWPLimitReached::"+IntToString(GetStorageCount( oCombatController, STORAGE_EXPLORE_WAYPOINTS ))+"/"+IntToString(GetMaxExploreWP( oCombatController ) ));
	}
	// Attemps to open surrounding doors
	CheckNearbyDoors( oNPC );
	
	return FALSE;
	
}

// Returns the nearest exploration waypoint from oNPC
object GetNearestExplorationWaypoint( object oNPC){

	return GetNearestObjectByTag( TAG_EXPLORE_WAYPOINT );

}

// VAR_COMB_WP_HEIGHT
// VAR_COMB_WP_HEIGHT_RATIO
// VAR_COMB_CONT_HEIGHT_MIN
// VAR_COMB_CONT_HEIGHT_MAX
// VAR_COMB_CONT_WP_AMBUSH
// VAR_COMB_CONT_WP_RANGED
// VAR_COMB_CONT_WP_TAUNT

// Applies a new quality ratio to the combat controller waypoints
// Ratio = -( (nMin - nCur) / (nMax - nMin ) )
// Ex : nMax:100, nMin:-100, nCur:50 => ratio of -(-150/200) ie. 0.75
// 1.0 is the max
// 0.0 is the min
// -1.0 is default <=> not computed
int QualifyLocationRefactorWP( object oCombatController ){

	//PrettyDebug( "QualifyLocationRefactorWP::Running ");
	object oWP;
	object oStorage	= GetStorage( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
	int nCount 		= GetStorageCount( oCombatController, STORAGE_EXPLORE_WAYPOINTS );
	int nI;
	float fHeightRatio; // Current heigtht ratio 
	int nCur; // Current height 
	int nDiff; // - ( nMin - nCur )
	
	// Retrieve height span at controller level
	int nMax			= GetLocalInt( oCombatController, VAR_COMB_CONT_HEIGHT_MAX );
	int nMin			= GetLocalInt( oCombatController, VAR_COMB_CONT_HEIGHT_MIN );
	int nTotalDiff		= nMax - nMin;
	for( nI = 0; nI < nCount; nI++){
	
		oWP 			= GetVariableValueObject( oStorage, nI );
		nCur 			= GetLocalInt( oWP, VAR_COMB_WP_HEIGHT );
		nDiff			= 0 - ( nMin - nCur );
		fHeightRatio	= _safeDivide( IntToFloat( nDiff ),IntToFloat( nTotalDiff )) ;
		SetLocalFloat( oWP, VAR_COMB_WP_HEIGHT_RATIO, fHeightRatio );
		//PrettyDebug( "QualifyLocationRefactorWP::height="+IntToString(nCur)+">Ratio="+FloatToString(fHeightRatio)+"("+IntToString(nDiff)+"/"+IntToString(nTotalDiff)+")" );
	}

	return FALSE;



}

// Qualifies a waypoint's height and refactors all the waypoints
int QualifyLocationDigHeight( object oWP, object oCombatController ){

	//PrettyDebug( "QualifyLocationDigHeight::Running ");
	// Retrieve and store on WP its height
	vector pWP 			= GetPosition( oWP );
	int nZ				= FloatToInt( pWP.z );
	SetLocalInt( oWP, VAR_COMB_WP_HEIGHT, nZ );
	'
	// Compare and store on controller
	int nMax			= GetLocalInt( oCombatController, VAR_COMB_CONT_HEIGHT_MAX );
	int nMin			= GetLocalInt( oCombatController, VAR_COMB_CONT_HEIGHT_MIN );
	if( nZ >= nMax ) {
		//PrettyDebug( "QualifyLocationDigHeight::SetMax at "+IntToString(nZ) );
		SetLocalInt( oCombatController, VAR_COMB_CONT_HEIGHT_MAX, nZ );
	}
	if( nZ < nMin ) { 
		//PrettyDebug( "QualifyLocationDigHeight::SetMin at "+IntToString(nZ) );
		SetLocalInt( oCombatController, VAR_COMB_CONT_HEIGHT_MIN, nZ );
	}
	
	// Refactor all waypoints
	QualifyLocationRefactorWP( oCombatController );

	return FALSE;
}





// Returns N chunks separating oWP1 from oWP2
int GetStepsBetweenExlorationWaypoints( object oWP1, object oWP2 ){

	if( !GetIsObjectValid( oWP1 )||!GetIsObjectValid( oWP2 )){
		return FALSE;
	}
	float fDist = GetDistanceBetween( oWP1, oWP2 );
	int nChunks	= FloatToInt( fDist / PARAM_COMBAT_ZONE_CHUNK );
	return nChunks;

}

// Qualifies WP for ambush position
// A good ambush position has freedom of movement and is relatively low
// so it is qualified by fSurroundingQuality / fHeightQuality
// Plus, it should be close to the ranged combat position
// So it shall be divided by the amount of "steps" separating both
// Ex: 8 surrounding, and low give ( 8/8 ) / 0.1 => 10 score
// Ex: 2 surrounding and middle high give ( 2/8 ) / 0.5 => 0.5 score 
int QualifyLocationDigPositionAmbush(object oWP, object oCombatController ){

	// Get the quality score for current WP and store it on WP
	float nSurroundingWPQuality	= GetLocalFloat( oWP, VAR_QUALIFY_SURROUND_WP );
	float fHeightQuality		= GetLocalFloat( oWP, VAR_COMB_WP_HEIGHT_RATIO );
	float fQuality 				= _safeDivide( nSurroundingWPQuality, fHeightQuality );
	object oRangedWP			= GetLocalObject( oCombatController, VAR_QUALIFY_RANGED_WP );
	int nChunks					= GetStepsBetweenExlorationWaypoints( oWP, oRangedWP );
	if( nChunks ){
		fQuality				= fQuality / nChunks;						
	}
	SetLocalFloat( oWP, VAR_QUALIFY_AMBUSH, fQuality );
	
	// Compare this score with the one of the object currently stored on controller
	object oAmbushWP			= GetLocalObject( oCombatController, VAR_QUALIFY_AMBUSH_WP );
	if( !GetIsObjectValid( oAmbushWP ) ){
		PrettyDebug( "QualifyLocationDigPositionAmbush::Invalid ref :"+FloatToString( fQuality )); 
		SetLocalObject( oCombatController, VAR_QUALIFY_AMBUSH_WP, oWP  );
	}
	else if( GetLocalFloat( oAmbushWP, VAR_QUALIFY_AMBUSH ) <= fQuality ){
		PrettyDebug( "QualifyLocationDigPositionAmbush::Better Quality :"+FloatToString( fQuality )); 
		SetLocalObject( oCombatController, VAR_QUALIFY_AMBUSH_WP, oWP  );
	}
	else PrettyDebug( "QualifyLocationDigPositionAmbush::Inferior Quality :"+FloatToString( fQuality ));
	return FALSE;
	
}

// Qualifies WP for ranged position
// A good ranged position has low freedom of movement and is relatively high
// so it is qualified by fHeightQuality / fSurroundingQuality 
// Ex: 8 surrounding, and low give   0.1 / ( 8/8 ) => 0.1 score
// Ex: 2 surrounding and middle high give  0.5 / ( 2/8 )=> 2 score 
int QualifyLocationDigPositionRanged(object oWP, object oCombatController ){

	// Get the quality score for current WP and store it on WP
	float nSurroundingWPQuality	= GetLocalFloat( oWP, VAR_QUALIFY_SURROUND_WP );
	float fHeightQuality		= GetLocalFloat( oWP, VAR_COMB_WP_HEIGHT_RATIO );
	float fQuality 				= _safeDivide( fHeightQuality, nSurroundingWPQuality );
	SetLocalFloat( oWP, VAR_QUALIFY_RANGED, fQuality );
	
	// Compare this score with the one of the object currently stored on controller
	object oRangedWP			= GetLocalObject( oCombatController, VAR_QUALIFY_RANGED_WP );
	if( !GetIsObjectValid( oRangedWP ) ){
		PrettyDebug( "QualifyLocationDigPositionRanged::Invalid ref :"+FloatToString( fQuality )); 
		SetLocalObject( oCombatController, VAR_QUALIFY_RANGED_WP, oWP  );
	}
	else if( GetLocalFloat( oRangedWP, VAR_QUALIFY_RANGED ) <= fQuality ){
		PrettyDebug( "QualifyLocationDigPositionRanged::Better Quality :"+FloatToString( fQuality )); 
		SetLocalObject( oCombatController, VAR_QUALIFY_RANGED_WP, oWP  );
	}
	else PrettyDebug( "QualifyLocationDigPositionRanged::Inferior Quality :"+FloatToString( fQuality ));
	return FALSE;
}

// Counts surrounding exploration waypoints
int QualifyLocationDigPositionSurroundWP(object oWP, object oCombatController ){

	float fDist;
	int nNth 			= 1;
	int nCount 			= 0;
	object oSearchWP 	= GetNearestObjectByTag( TAG_EXPLORE_WAYPOINT, oWP, nNth );
	while( GetIsObjectValid( oSearchWP ) ){
		//PrettyDebug( "QualifyLocationDigPositionSurroundWP::nNth = "+IntToString(nNth)); 
		fDist = GetDistanceBetween( oSearchWP, oWP );
		if( fDist <= ( PARAM_COMBAT_ZONE_CHUNK + 1.0 ) ){
		 	nCount++;
			oSearchWP 	= GetNearestObjectByTag( TAG_EXPLORE_WAYPOINT, oWP, ++nNth );
		}else{
			oSearchWP 	= OBJECT_INVALID;
		}
	}
	
	// We want to avoid null divisors
	if( 0 == nCount ) nCount = 1;
	
	float fQuality		= IntToFloat( nCount ) / 8;
	//PrettyDebug( "QualifyLocationDigPositionSurroundWP::WP Quality :"+FloatToString( fQuality )); 
	SetLocalFloat( oWP, VAR_QUALIFY_SURROUND_WP, fQuality );
	return nCount;

}


// Qualifies a waypoint's quality for various positional advantage
int QualifyLocationDigPosition( object oNPC, object oWP, object oCombatController ){
	
	
	// Count immediately surrounding exploration wp, max of 8 as in :
	// . . . 
	// . x .
	// . . .
	QualifyLocationDigPositionSurroundWP( oWP, oCombatController );
	
	// Run utility function for each position type and compare the result with the current
	// controller's WP of preference for the given type
	QualifyLocationDigPositionAmbush( oWP, oCombatController );
	QualifyLocationDigPositionRanged( oWP, oCombatController );
	
	
	return TRUE;
}


// Check around and see what we got
int QualifyLocationDig( object oNPC, object oWP, object oCombatController ){
	

	// Qualify height
	if( -1.0 == GetLocalFloat( oWP, VAR_COMB_WP_HEIGHT_RATIO ) ){
	
		QualifyLocationDigHeight( oWP, oCombatController);
		return TRUE;
	}
	
	// Qualify potential position interest
		QualifyLocationDigPosition( oNPC, oWP, oCombatController);
		return TRUE;
	
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
	
	// Dig it
	QualifyLocationDig( oNPC, oWP, oCombatController );
	
	
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