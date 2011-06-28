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



const float DISTANCE_SAFE				= 35.0;
const float DISTANCE_FLEE				= 35.0;
const string CREATURE_LAST_LOCATION		= "CREATURE_LAST_LOCATION";





// Open 
void SetDoorOpen( object oDoor )
{
	if( GetIsOpen( oDoor ) ) return;
	
	AssignCommand( oDoor, ClearAllActions() );
	//
	AssignCommand( oDoor, ActionOpenDoor( oDoor ) );
	

}

// Opens or try to destroy any door that would block path
void CheckNearbyDoors( object oNPC ) 
{

	int nNth = 1;

	object oDoor = GetNearestObject( OBJECT_TYPE_DOOR, oNPC, nNth );
	
	while( GetIsObjectValid( oDoor ) &&  GetDistanceBetween( oDoor, oNPC ) < S_DISTANCE_DOORS )
	{
		if( GetLocked( oDoor ) )
		{

			string sKey = GetLockKeyTag( oDoor );
			
	        object oKey = GetItemPossessedBy(oNPC, sKey);
			
			if (sKey != "" && GetIsObjectValid(oKey)) 
			{
				SetLocked(oDoor, FALSE);
				
				DelayCommand( 2.0, SetLocked( oDoor, TRUE ) );
			}
			else if ( !GetPlotFlag( oDoor ) && !GetImmortal( oDoor ) )
			{
			
//				AssignCommand( oNPC, ClearAllActions( ) );
			
//				AssignCommand( oNPC, ActionAttack( oDoor ) );	
			
			}
		
		}			
		
		if(  !GetIsOpen( oDoor ) ){
// PrettyMessage( GetName( oNPC ) + " opens nearby doors ");
			//
			SetDoorOpen( oDoor );
			//
			AssignCommand( oDoor, DelayCommand( S_DELAY_DOORS, ActionCloseDoor( oDoor ) ) );
		
		}
		oDoor = GetNearestObject( OBJECT_TYPE_DOOR, oNPC, ++nNth );
	}

}


float GetFleeDistance( object oCreature ) {

	object oArea 			= GetArea( oCreature );
	//
	if( ! GetIsAreaInterior( oArea ) ) return DISTANCE_FLEE;
	
	return DISTANCE_FLEE;
	
//	float fDist = 6.0 * sqrt( IntToFloat( GetAreaSize( AREA_HEIGHT, oArea ) * GetAreaSize( AREA_WIDTH, oArea ) ) )  ;
	//
// PrettyDebug("()	GetFleeDistance : " + FloatToString( fDist ) );
//	return fDist;
	

}


/**
 * USed by GetValidFleeLocation
 **/ 
location GetFleeLocation( object oCreature, object oTarget, float fDist, float fOptionalAngle = 0.0 ) {

//	float fAngle 			= GetAngleBetweenObjects( oTarget , oCreature ) + fOptionalAngle;
	float fAngle 			= GetAngleBetweenObjects( oTarget , oCreature ) + Random( 45 ) + fOptionalAngle;
	//
	vector vRef 			= GetPosition( oCreature );
	//
	vector vPosition 		=   VAtAngleToV( vRef, fDist, fAngle); 
	//
	location lFlee 			= Location( GetArea( oCreature ), vPosition, fAngle );
	//
DebugLocation( lFlee, "blue" );
	return lFlee;
	
}



location GetValidFleeLocation( object oCreature, object oTarget ) {

	//
	int nSearchDepth;
	//
	float fDepthParam;
	//
	float fDist 		= GetFleeDistance( oCreature );
	//
/*
	location lFlee 		= GetFleeLocation( oCreature, oTarget, fDist );
	
	while( ! GetIsLocationValid( lFlee ) || nSearchDepth < S_MAX_LOC_SEARCH_DEPTH ) {
	
		if( GetIsLocationValid( lFlee ) ) return lFlee;
		
		lFlee = GetFleeLocation( oCreature, oTarget, fDist - fDepthParam / 4, -90.0 + fDepthParam );
		
		if( GetIsLocationValid( lFlee ) ) return lFlee;
		
		lFlee = GetFleeLocation( oCreature, oTarget, fDist - fDepthParam / 4, 90.0 + fDepthParam );
			
		if( GetIsLocationValid( lFlee ) ) return lFlee;
		
		lFlee = GetFleeLocation( oCreature, oTarget, fDist - fDepthParam / 4, 180.0 + fDepthParam ); 
				
		if( GetIsLocationValid( lFlee ) ) return lFlee;
		
		lFlee = GetFleeLocation( oCreature, oTarget, fDist - fDepthParam / 4, fDepthParam);
		
		fDepthParam -= 25.0;
		//
		nSearchDepth++;
		
	}
*/

	float fOptAngle = -30.0;
	//
	location lFlee 	;
	
	while( ! GetIsLocationValid( lFlee ) && nSearchDepth < S_MAX_LOC_SEARCH_DEPTH ) {

		nSearchDepth++;
		//
		fDepthParam 	-= 3.0;
		//
		fOptAngle 		+= 60.0;
		//
		lFlee = GetFleeLocation( oCreature, oTarget, fDist + fDepthParam, fOptAngle + fDepthParam );
// PrettyDebug("() GetValidFleeLocation : SearchDist " + FloatToString( fDist + fDepthParam ) + " fOptAngle " + FloatToString( fOptAngle ) + " fDepthParam " +  FloatToString( fDepthParam ) + " nSearchDepth " + IntToString( nSearchDepth )  );		
	}
	
	return lFlee;
}

// TODO : ADD PERCEPTION CHECKS 

int GetIsTargetValid( object oTarget ) {

	int nHP = GetCurrentHitPoints( oTarget );
	
	if( !GetObjectSeen( oTarget ) && !GetObjectHeard ( oTarget ) )
		return FALSE;
	
	if( !GetIsObjectValid( oTarget ) || GetIsDead( oTarget )){
			PrettyDebug("() GetIsTargetValid : Invalid Target " );
		return FALSE;
	}
	if ( nHP < 1 ) {
			PrettyDebug("() GetIsTargetValid : Target HP ( " + IntToString( nHP ) + " ) < 1 " );
		return FALSE;
	}
	else if( GetObjectSeen( oTarget ) || GetObjectHeard( oTarget ) ){ 
			PrettyDebug("() GetIsTargetValid : Valid Target = " + GetResRef( oTarget ) );
	return TRUE; }
	 
	 return FALSE;

}

// TODO : EVENTUAL FLEE WAYPOINTS OPTIONS

int ActionFlee( object oCreature, object oTarget = OBJECT_INVALID ) {

	

	location lFlee = GetValidFleeLocation( oCreature, oTarget );
		
	if( 	GetDistanceBetweenLocations( GetLocation( oTarget ), lFlee ) 
		< 	GetDistanceBetweenLocations( GetLocation( oTarget ), GetLocation( oCreature ) ) )
		
		return FALSE;
	
	object oWaypoint = CreateObject( OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lFlee, FALSE );
	//
	AssignCommand( oCreature, ActionForceMoveToObject( oWaypoint, TRUE ) );
	//
	DestroyObject( oWaypoint, 6.5);
	//
// PrettyDebug("()	ActionFlee : " + GetName( oCreature ) +" looked for a way out " );
	return TRUE;
	
}

void DelayActionFlee(  object oCreature, object oTarget = OBJECT_INVALID ) {

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
	
	object oNPC				= OBJECT_SELF;
	//
//	AssignCommand( oNPC, ActionSpeakString( "I'm Fleeing" ) );
	//
	object oWP 				= GetControllerWaypointProxy( oNPC );
	// 
	object oController 		= GetControllerProxy( oNPC );

	if( AddToControllerList( oController, PC_CONTROLLER_STORAGE_PASSIVE, oNPC ) )

		SetInteractionReferer( oNPC, oController );
	
	int i;
	//
	float fDist, fMin 		= 9999.9;
	//
	object oTarget, oCreature;
	// 
	int nCount				= GetStorageCount( oController, PC_CONTROLLER_STORAGE_ACTIVE_NEGATIVE );
	
	//
	// TODO : replace by function
	for( i = 0; i < nCount; i++ ) {
	
		oCreature 			= GetStorageObjectAtIndex( oController, PC_CONTROLLER_STORAGE_ACTIVE_NEGATIVE, i );
	
		if( GetIsInteractionCreatureValid( oCreature ) ) {
		
			fDist			= GetDistanceBetween( oNPC, oCreature );
			
			if( fDist < fMin ) {
			
				fMin		= fDist;
				//
				oTarget		= oCreature;
				
			}
			
		}
	
	}
	if( !GetIsObjectValid( oTarget ) ) 	return; // There might be no PC to flee from. Causes DIVIDE BY ZERO if removed
PrettyDebug("I'm Fleeing from " + GetName( oTarget ) );
	CheckNearbyDoors( oNPC );
	ActionFlee( oNPC, oTarget );
	 
	DelayCommand(3.0f, AssignCommand( oNPC, DelayActionFlee( oNPC, oTarget ) ) );
	

}