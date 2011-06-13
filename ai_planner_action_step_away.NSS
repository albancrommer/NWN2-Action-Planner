// script_name
/*
	Description:
	
*/
// Name_Date

// TODO : Make it original, not a copy of action_flee


#include "ai_planner_motivation_social"
#include "ginc_debug"
#include "inc_vectors"
#include "X0_I0_POSITION"
#include "inc_ai_planner_motivation_social"



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




int GetIsInteractionCreatureValid( object oObject ) {

	int nHP = GetCurrentHitPoints( oObject );
	
	if( !GetObjectSeen( oObject ) && !GetObjectHeard ( oObject ) )
		return FALSE;

	if( !GetIsObjectValid( oObject ) || GetIsDead( oObject )){
// PrettyDebug("() GetIsTargetValid : Invalid Target " );
		return FALSE;
	}
	if ( nHP < 1 ) {
// PrettyDebug("() GetIsTargetValid : Target HP ( " + IntToString( nHP ) + " ) < 1 " );
		return FALSE;
	}
	 else { 
// PrettyDebug("() GetIsTargetValid : Valid Target = " + GetName( oObject ) );
	 return TRUE; }
}
void main() {
	
ActionSpeakString( "Moving Away" );

	object oNPC				= OBJECT_SELF;
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
	
	CheckNearbyDoors( oNPC );
	
	AssignCommand( oNPC, ActionMoveAwayFromObject( oNPC ) );

}