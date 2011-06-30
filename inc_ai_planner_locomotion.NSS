#include "inc_ai_planner_const"

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

