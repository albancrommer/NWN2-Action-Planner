// script_name
/*
	Description:
	
*/
// Alban 1008

// TODO : This is wrong : it should be library dependant and modified from inc_ai_planner

#include "inc_ai_planner_const"
#include "inc_ai_planner_goals"
#include "inc_ai_planner_motivations"
#include "ginc_debug"



void InitNPC( object oNPC ) {

	float fFatigue = 0.1 * IntToFloat( Random(5) );
	//
	SetFatigue( oNPC, fFatigue );
	//
	SetHunger( oNPC, 0.1 * Random(5) );
	//
	UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_SLEEP, 0.0 );
	//
	UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_EAT, 0.0 );
	//
	UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_IDLE, 0.1 ); 

}


void UpdateNPC( object oNPC ){

	SetFatigue( oNPC, GetFatigue(oNPC) + 0.02 );
	//
	SetHunger( oNPC, GetHunger(oNPC)+ 0.05 );

}