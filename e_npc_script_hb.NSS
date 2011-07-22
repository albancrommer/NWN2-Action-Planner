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
//PrettyDebug( "##### NEW NPC HEARTBEAT : " + ObjectToString( oNPC  )  );
//PrettyDump( oNPC ) ;
//PrettyDebug( "FATIGUE : " + FloatToString( GetFatigue( oNPC ) ) + " HUNGER : " + FloatToString( GetHunger( oNPC ) ) );
	AssignCommand(  oNPC, ClearAllActions( TRUE ) );
	UpdateNPC( oNPC );
	UpdateWorldState( oNPC );
	GetMotivation( oNPC );
	if( GetPlan( oNPC ) ){ 
		// 
		if( ! ExecutePlan( oNPC ) ){
			//
			PrettyDebug( GetTag(oNPC) + " couldn't execute plan actions" );
			
		}
	//
	} else{
	
		PrettyDump( GetObjectByTag( TASKS_ARRAY ) );
		PrettyDump( GetStorage( oNPC, GOALS_ARRAY ) );
	 	PrettyDebug( GetTag(oNPC) + " has no valid plan" );
	}
}