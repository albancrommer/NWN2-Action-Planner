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
	object oC			= GetLastSpellCaster();
	//
	if( ! GetNotifyPCInterractionRequestValid( oNPC, oC ) ) return;
	
	if( !GetLastSpellHarmful( ) ) return; // TODO : Deal with non harmful spells ?
	
	object oWP 			= GetInteractionWaypointNearest( oNPC );
	//
	object oController	= GetController( oNPC, oC );
	
	NotifyPCInterractionController( oController, oNPC, oC, E_PC_ATTACK );
		
// dump( ( oNPC ) );
// dump( GetInteractionReferer( oNPC ) );

}