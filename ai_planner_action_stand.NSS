// script_name
/*
	Description:
	
*/
// Name_Date

// TODO : Inject decent coding for the referent controller


#include "ai_planner_motivation_social"
#include "ginc_debug"
#include "inc_vectors"
#include "X0_I0_POSITION"
#include "inc_ai_planner_motivation_social"



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
	
// ActionSpeakString( "Standing" );
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
	int nNegativeInteration	= GetNegativeStanding( oNPC );
	// 
	string sPCList			= nNegativeInteration ? PC_CONTROLLER_STORAGE_ACTIVE_NEGATIVE : PC_CONTROLLER_STORAGE_ACTIVE_POSITIVE ;
	
	int nCount				= GetStorageCount( oController, sPCList );
	//
	
	for( i = 0; i < nCount; i++ ) {
	
		oCreature 			= GetStorageObjectAtIndex( oController, sPCList, i );
	
		if( GetIsInteractionCreatureValid( oCreature ) ) {
		
			fDist			= GetDistanceBetween( oNPC, oCreature );
			
			if( fDist < fMin ) {
			
				fMin		= fDist;
				//
				oTarget		= oCreature;
				
			}
			
		}
	
	}
	
	if( !GetIsObjectValid( oTarget ) ) { return;  }

	string sStance 			= GetCreatureStance( oNPC );
	//
	TurnToFaceObject( oTarget, oNPC );
	//
	if( ! nNegativeInteration )
	
		AssignCommand( oNPC, ActionForceMoveToObject( oTarget, FALSE, 5.0 ) );
	
	PlayCustomAnimation( oNPC, sStance, TRUE );

}