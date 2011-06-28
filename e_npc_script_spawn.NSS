// script_name
/*
	Description:
	
*/
// Alban 1008

#include "ginc_debug"
#include "inc_ai_planner"
#include "inc_ai_planner_motivations"

void main()
{

	object oNPC = OBJECT_SELF;
	
	// initializes NPC variables - think fatigue, hunger, etc.
	InitNPC( oNPC );

	
	// if a FORCED COMBAT Waypoint is around, creature is tagged to enter combat planning
	//
	object oWP = GetNearestObjectByTag( WP_FORCED_COMBAT, oNPC );
	if( GetIsObjectValid( oWP ) ){
		float fDist = GetLocalFloat( oWP, VAR_FORCED_COMBAT_DIST );
		float fDistBet = GetDistanceBetween( oWP, oNPC );
		if( fDistBet < fDist ){
			SetLocalInt( oNPC, VAR_FORCED_COMBAT, 1 );
		}
	}
}