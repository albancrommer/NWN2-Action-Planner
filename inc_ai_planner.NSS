// inc_ai_planner
/*

	TODO : Write functions doc + "How to use and mod" ? 
	
	Stopped at: 110627 inject combat layer
	
*/
// Alban

/* #include "inc_ai_planner_data_ar_wp" */
#include "inc_ai_planner_actions"
#include "inc_ai_planner_conditions"
#include "inc_ai_planner_constraints"
#include "inc_ai_planner_const"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_motivations"
#include "inc_ai_planner_goals"
#include "inc_ai_planner_tasks"
#include "inc_ai_planner_utilities"
#include "inc_ai_planner_motivations"

// **************************************************************************
// Prototypes
// **************************************************************************

// GetWorldState performs both environment and creature self check to update a Local World State Memory (LWSM)
int UpdateWorldState( object oNPC );

// GetMotivation affects goals values using the LWSM to determine the values of motivations 
int GetMotivation( object oNPC );

// GetPlan performs the actual search for valid tasks to execute
int GetPlan( object oNPC );



// **************************************************************************
// Implementations
//
// This is where you might want to branch new functions
//
// **************************************************************************

void UpdateWorldState( object oNPC ){
	
//	UpdateWorldState_Performances( oNPC );
	//
  	UpdateWorldState_Combat( oNPC );
	//
	UpdateWorldState_Social( oNPC );
	//
	UpdateWorldState_Self( oNPC );
	
}

int GetMotivation( object oNPC ){


	ResetMotivationsLimit( oNPC );
/*
	GetMotivation_Performances( oNPC );
*/	
	if( MotivationsLimitValid( oNPC ) ) 
		
		GetMotivation_Momentum( oNPC );
	
	if( MotivationsLimitValid( oNPC ) ) 
	
		GetMotivation_Combat( oNPC );
		
	if( MotivationsLimitValid( oNPC ) ) 
	
		GetMotivation_Social( oNPC );

	if( MotivationsLimitValid( oNPC ) ) 
	
		GetMotivation_Self( oNPC );

	return TRUE;
	
}
	 


// **************************************************************************
// This is the planner itself, no need to modify it
// **************************************************************************


// GetPlan recursively searches for an adequate set of tasks
int GetPlan( object oNPC ){


	int bValid, bSolved, bConditions = FALSE;
	//
	string sConditions, sEffects, sTask;
	//
	SortStorageFloat( oNPC, GOALS_ARRAY );

	//
	float fGoalValue 		= GetHighestGoalValue( oNPC );
	//
	string sGoal 			= GetHighestGoal( oNPC );
	//
	while( FALSE == bSolved ){
		//
 PrettyDebug( "?? "+ObjectToString( oNPC )+ " Searching with Goal : "+sGoal );
		if( INVALID 		== sGoal ) { // No more reachable goal
			//
			bSolved 		= TRUE; 
			//
			bValid			= FALSE;
			//
			break; 
		
		}
		//
		sConditions 		= GetGoalConditions( sGoal );
PrettyDebug( "?? "+ObjectToString( oNPC )+ " Goal conditions : "+sConditions );
		//
		if( ! GetConditionsValid( oNPC, sConditions ) ){ // Not a valid goal
			//
			sGoal 			= GetHighestGoal( oNPC );
			//
			continue;
			
		}
		//
		sEffects	 		= GetGoalEffects( sGoal );
		//
		bValid 				= getPlanTasks( oNPC, sEffects );
		
	
//PrettyDump( GetObjectByTag( TASKS_ARRAY ) );		
		if( TRUE == bValid ){
			//
			bSolved = TRUE;  // End Search
		//
		} else { 
			//
PrettyDebug( "?? "+ObjectToString( oNPC )+ " Goal failed for effects : "+sEffects );
			sGoal = GetHighestGoal( oNPC );// Look for another goal
		// 
		}
	//
	}
	
	if( FALSE == bValid ) return FALSE;
	
	SetLastGoal( oNPC, sGoal );
	//
	SetLastGoalValue( oNPC, fGoalValue );
	//
 PrettyDebug( "?? "+ObjectToString( oNPC )+ " Plan Solved !  " + sGoal );
	return TRUE;
}