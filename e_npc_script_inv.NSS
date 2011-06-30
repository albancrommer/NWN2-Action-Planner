// script_name
/*
	Description:
	
*/
// Name_Date

#include "inc_ai_planner"

void main()
{

	object oNPC			= OBJECT_SELF;
	//
	object oC			= GetLastDisturbed();
	//
	if( ! GetNotifyPCInterractionRequestValid( oNPC, oC ) ) return;
	
	object oWP 			= GetInteractionWaypointNearest( oNPC );
	//
	object oController	= GetController( oNPC, oC );
	
	if( GetDistanceBetween( oNPC, oWP ) > 1.0 ) 
	
		CreateControllerWaypoint( oNPC, oController ); 
	
	NotifyPCInterractionController( oController, oNPC, oC, E_PC_PICKPOCKET );
//PrettyDump( ( oController ) );
		
// PrettyDump( ( oNPC ) );
// PrettyDump( GetInteractionReferer( oNPC ) );

}