// script_name
/*

	
	 
	
*/
// Alban 1008

const string 	GOAL_EAT 				= "GOAL_EAT";
const string 	GOAL_IDLE				= "GOAL_IDLE";
const string 	GOAL_SLEEP 				= "GOAL_SLEEP";


#include "inc_ai_planner_const"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_worldstate"


float GetFatigue( object oNPC ){

	return GetLocalFloat( oNPC, FATIGUE );
}


void SetFatigue( object oNPC, float fFatigue ){
	
	SetLocalFloat( oNPC, FATIGUE, fFatigue );
}


float GetHunger( object oNPC ){
	
	return GetLocalFloat( oNPC, HUNGER );
}


void SetHunger( object oNPC, float fHunger ){
	
	SetLocalFloat( oNPC, HUNGER, fHunger );
}



int GetMotivation_Self( object oNPC ) {

	if( GetWorldState( oNPC, FATIGUE ) ) UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_SLEEP, 1.0 );  
		else UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_SLEEP, 0.0 );
	//
	if( GetWorldState( oNPC, HUNGER ) )  UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_EAT, 1.0 ); 
		else UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_EAT, 0.0 );
	//
	UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_IDLE, 0.1 ); 
	//
	return TRUE;
}


int UpdateWorldState_Self( object oNPC ) {

	
	if( GetFatigue( oNPC ) > 0.8 ) SetWorldState( oNPC , FATIGUE, TRUE );
		//
		else  SetWorldState( oNPC , FATIGUE, FALSE );
	//
	if( GetHunger( oNPC ) > 0.8 ) SetWorldState( oNPC , HUNGER, TRUE );
		//
		else  SetWorldState( oNPC , HUNGER, FALSE );

	return TRUE;
	

}