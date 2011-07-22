// script_name
/*
Description:

*/
// Name_Date

// TODO : Move to library some of the functions

// TODO : update controller state if PC around


#include "ai_planner_motivation_social"
#include "ginc_debug"
#include "inc_vectors"
#include "X0_I0_POSITION"
#include "inc_ai_planner_motivation_social"
#include "inc_ai_planner_locomotion"



const float DISTANCE_SAFE = 35.0;
const float DISTANCE_FLEE = 35.0;
const string CREATURE_LAST_LOCATION = "CREATURE_LAST_LOCATION";





float GetFleeDistance( object oCreature ) {

	return DISTANCE_FLEE;
	
	// object oArea = GetArea( oCreature );
	// if( ! GetIsAreaInterior( oArea ) ) return DISTANCE_FLEE;
	// float fDist = 6.0 * sqrt( IntToFloat( GetAreaSize( AREA_HEIGHT, oArea ) * GetAreaSize( AREA_WIDTH, oArea ) ) ) ;
	//
	// PrettyDebug("() GetFleeDistance : " + FloatToString( fDist ) );
	// return fDist;


}


/**
 * USed by GetValidFleeLocation
 **/
location GetFleeLocation( object oCreature, object oTarget, float fDist, float fOptionalAngle = 0.0 ) {
	
	float fAngle = GetAngleBetweenObjects( oTarget , oCreature ) + Random( 45 ) + fOptionalAngle;
	vector vRef = GetPosition( oCreature );
	vector vPosition = VAtAngleToV( vRef, fDist, fAngle);
	location lFlee = Location( GetArea( oCreature ), vPosition, fAngle );
	//PrettyDebugLocation( lFlee, "blue" );
	return lFlee;

}



location GetValidFleeLocation( object oCreature, object oTarget ) {

	int nSearchDepth;
	float fDepthParam;
	float fDist = GetFleeDistance( oCreature );
	float fOptAngle = -30.0;
	location lFlee ;
	while( ! GetIsLocationValid( lFlee ) && nSearchDepth < S_MAX_LOC_SEARCH_DEPTH ) {
	
		nSearchDepth++;
		fDepthParam -= 3.0;
		fOptAngle += 60.0;
		lFlee = GetFleeLocation( oCreature, oTarget, fDist + fDepthParam, fOptAngle + fDepthParam );
	}
	
	return lFlee;
}

// TODO : ADD PERCEPTION CHECKS

int GetIsTargetValid( object oTarget ) {
	
	int nHP = GetCurrentHitPoints( oTarget );
	if( !GetObjectSeen( oTarget ) && !GetObjectHeard ( oTarget ) )
	return FALSE;
	if( !GetIsObjectValid( oTarget ) || GetIsDead( oTarget )){
	//PrettyDebug("() GetIsTargetValid : Invalid Target " );
	return FALSE;
	}
	if ( nHP < 1 ) {
	//PrettyDebug("() GetIsTargetValid : Target HP ( " + IntToString( nHP ) + " ) < 1 " );
	return FALSE;
	}
	else if( GetObjectSeen( oTarget ) || GetObjectHeard( oTarget ) ){
	//PrettyDebug("() GetIsTargetValid : Valid Target = " + GetResRef( oTarget ) );
	return TRUE; }
	
	return FALSE;

}

// TODO : EVENTUAL FLEE WAYPOINTS OPTIONS
int ActionFlee( object oCreature, object oTarget = OBJECT_INVALID ) {


	
	location lFlee = GetValidFleeLocation( oCreature, oTarget );
	
	if( GetDistanceBetweenLocations( GetLocation( oTarget ), lFlee )
	< GetDistanceBetweenLocations( GetLocation( oTarget ), GetLocation( oCreature ) ) )
	
	return FALSE;
	
	object oWaypoint = CreateObject( OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lFlee, FALSE );
	AssignCommand( oCreature, ActionForceMoveToObject( oWaypoint, TRUE ) );
	DestroyObject( oWaypoint, 6.5);
	// PrettyDebug("() ActionFlee : " + GetName( oCreature ) +" looked for a way out " );
	return TRUE;

}

void DelayActionFlee( object oCreature, object oTarget = OBJECT_INVALID ) {

	ActionFlee( oCreature, oTarget );

}


int GetIsInteractionCreatureValid( object oObject ) {

	int nHP = GetCurrentHitPoints( oObject );
	
	if( !GetObjectSeen( oObject ) && !GetObjectHeard ( oObject ) )
	return FALSE;
	
	if( !GetIsObjectValid( oObject ) || GetIsDead( oObject )){
	return FALSE;
	}
	if ( nHP < 1 ) {
	return FALSE;
	}
	return TRUE;

}

void main() {
	
	object oNPC = OBJECT_SELF;
	//
	// AssignCommand( oNPC, ActionSpeakString( "I'm Fleeing" ) );
	//

	object oFled		= GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oNPC );

	if( !GetIsObjectValid( oFled ) ) return; // There might be no PC to flee from. Causes DIVIDE BY ZERO if removed
	PrettyDebug("I'm Fleeing from " + GetName( oFled ) );
	CheckNearbyDoors( oNPC );
	ActionFlee( oNPC, oFled );
	
	DelayCommand(3.0f, AssignCommand( oNPC, DelayActionFlee( oNPC, oFled ) ) );


}