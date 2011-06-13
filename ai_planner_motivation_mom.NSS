// ai_planner_motivation_mom
/*
	
	
*/
// Alban 1008

#include "inc_ai_planner_const"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_goals"
#include "inc_ai_planner_worldstate"
#include "ginc_debug"

int GetMotivation_Momentum( object oNPC ) {
	
	string sGoal 			= GetLastGoal( oNPC );
	
	if( "" == sGoal ) 		return FALSE; 
	
	float fValue			= GetLastGoalValue( oNPC );
	
	fValue 					*= 0.5;
		
	int i;
	
	// Resets Creatures goals
	for( i = 0; i < GetStorageCount( oNPC, GOALS_ARRAY ); i++ )
	
		SetLocalFloat( GetStorage( oNPC, GOALS_ARRAY ), GetStorageVarNameAtIndex( oNPC, GOALS_ARRAY, i ), 0.0f );
	
	
// PrettyDebug( "()	GetMotivation_Momentum for Goal : " + sGoal + " sets value : " + FloatToString( fValue ) );		 
	UpdateStorageFloat( oNPC, GOALS_ARRAY, sGoal, fValue );
	
	//
	return TRUE;

}