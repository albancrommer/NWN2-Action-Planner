// script_name"
/*
	Description:
	
*/
// Name_Date

#include "inc_ai_planner"
#include "ginc_debug"

int DestroyInteractionController( object oController ){

	int nNth 			= 1 ;
	//
	object oWP			= GetNearestObjectByTag( PC_CONTROLLER_WAYPOINT_TAG, oController, nNth) ;
	// OPTIMIZATION : check Controller WP # for performance
	while( GetIsObjectValid( oWP ) ){
	
		if( GetInteractionReferer( oWP ) == oController )
// DebugObjectLocation( oWP );
			DestroyObject( oWP, 0.1 );
		
		oWP			= GetNearestObjectByTag( PC_CONTROLLER_WAYPOINT_TAG, oController, ++nNth) ;
	}
	
	DestroyObject( oController, 0.1 );
	//
	return TRUE;
}

void main()
{


	object oController		= OBJECT_SELF;
	//
	float fState 		= GetInteractionControllerState( oController );
	//
	fState				*= S_STATE_DECAY;
// PrettyDebug("::	Controller HB : State = " + FloatToString( fState ) );
	//
	object oStorage	= GetStorage( oController, PC_CONTROLLER_STORAGE_ACTIVE_NEGATIVE );
// 	dump(oStorage);
	oStorage	= GetStorage( oController, PC_CONTROLLER_STORAGE_ACTIVE_POSITIVE );
// 	dump(oStorage);
	oStorage	= GetStorage( oController, PC_CONTROLLER_STORAGE_PASSIVE );
// 	dump(oStorage);
	
	if( fState > -0.1 && fState < 0.1 )
	
		DestroyInteractionController( oController );
	
	SetInteractionControllerState( oController, fState );

}