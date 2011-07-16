#include "inc_ai_planner_const"



int ActionMoveToLocationEnhanced( object oNPC, object oTarget = OBJECT_INVALID, int bRun = FALSE ) {

	location lDest 		= GetLocation( oTarget );
	object oWP 			= CreateObject( OBJECT_TYPE_WAYPOINT, TAG_DEFAULT_WP, lDest, FALSE );
	AssignCommand( oNPC, ActionForceMoveToObject( oWP, TRUE ) );
	DestroyObject( oWP, 6.5);
	// PrettyDebug("() ActionMoveToLocationEnhanced : " + GetName( oNPC ) );
	return TRUE;

}


// Performs the actual door opening
int SetDoorOpen( object oDoor )
{
	if( GetIsOpen( oDoor ) ) return FALSE;
	AssignCommand( oDoor, ClearAllActions() );
	AssignCommand( oDoor, ActionOpenDoor( oDoor ) );
	return FALSE;
}

// Opens or try to destroy any door that would block path
int CheckNearbyDoors( object oNPC ) 
{

	int nNth = 1;
	object oDoor = GetNearestObject( OBJECT_TYPE_DOOR, oNPC, nNth );
	while( GetIsObjectValid( oDoor ) &&  GetDistanceBetween( oDoor, oNPC ) < PARAM_DOORS_DISTANCE )
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
			//
			SetDoorOpen( oDoor );
			//
			AssignCommand( oDoor, DelayCommand( PARAM_DOORS_DELAY, ActionCloseDoor( oDoor ) ) );
		
		}
		oDoor = GetNearestObject( OBJECT_TYPE_DOOR, oNPC, ++nNth );
	}
	return FALSE;
}


// Moves NPC to its locally stored Destination
int MoveToDestination( object oNPC, int bRun = FALSE ){

	location lDest 		= GetLocalLocation( oNPC, VAR_MOVEMENT_DESTINATION ); 
	object oWP 			= CreateObject( OBJECT_TYPE_WAYPOINT, TAG_DEFAULT_WP, lDest, FALSE );
	AssignCommand( oNPC, ActionForceMoveToObject( oWP, bRun ) );
	DestroyObject( oWP, 6.5);
	
	// Attemps to open surrounding doors
	CheckNearbyDoors( oNPC );
	
	return FALSE;
	
}

//void main(){}
