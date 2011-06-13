// script_name
/*
	Description:
	
*/
// Alban 1008

#include "ginc_debug"
#include "inc_ai_planner"

void main()
{
	//
	object oNPC = OBJECT_SELF;
	//
//dump( oNPC ) ;
// PrettyDebug( "FATIGUE : " + FloatToString( GetFatigue( oNPC ) ) + " HUNGER : " + FloatToString( GetHunger( oNPC ) ) );

	UpdateNPC( oNPC );
	//
	UpdateWorldState( oNPC );
	//
	GetMotivation( oNPC );
	// 
	if( GetPlan( oNPC ) ){ 
		// 
		if( ! ExecutePlan( oNPC ) ){
			//
			PrettyDebug( GetTag(oNPC) + " couldn't execute plan actions" );
			
		}
	//
	} else PrettyDebug( GetTag(oNPC) + " has no valid plan" );
}