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
	object oC			= GetLastAttacker();

		if( ! GetNotifyPCInterractionRequestValid( oNPC, oC ) ) return;
	
	object oWP 			= GetInteractionWaypointNearest( oNPC );
	//
	object oController	= GetController( oNPC, oC );
	
	NotifyPCInterractionController( oController, oNPC, oC, E_PC_ATTACK );
		
// dump( ( oNPC ) );
// dump( GetInteractionReferer( oNPC ) );

}