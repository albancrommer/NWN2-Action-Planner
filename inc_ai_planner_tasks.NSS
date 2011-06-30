// script_name
/*
	Description:
	
*/
// Alban 1008

const string 	TASKS_EAT 				= "TASK_EAT";
const string 	TASKS_MOVETO 			= "TASK_MOVETO";
const string 	TASKS_SLEEP 			= "TASK_SLEEP";

#include "inc_ai_planner_actions"
#include "inc_ai_planner_conditions"
#include "inc_ai_planner_const"
#include "inc_ai_planner_constraints"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_motivations"
#include "ginc_debug"




string GetTaskEffects( string sTask )
{ 
	
	return GetStorageString(  GetCacheObject(), TASKS_STORAGE, sTask + TASKS_2DA_EFFECTS );
	
}



string GetTaskConditions( string sTask )
{

	return GetStorageString(  GetCacheObject(), TASKS_STORAGE, sTask + TASKS_2DA_CONDITIONS );
	
}




string GetTaskActions( string sTask )
{

	return GetStorageString(  GetCacheObject(), TASKS_STORAGE, sTask + TASKS_2DA_ACTION );
	
}


// TODO : REPLACE THE 2DA LOOP WITH DATAOBJECT CACHE
// Returns TRUE if a task was found and added to oTaskArray
int SetTask( object oNPC, object oTaskArray, string sCondition ){

	sCondition			= GetEffectFromTuple( sCondition) ;
//PrettyDebug( "() SetTask  : Retrieved sCondition from eventual tuple " + sCondition);
	//
	object oA			= GetObjectByTag( TASKS_STORAGE );
	//
	int i, nRet 		= FALSE;
	//	
	int nTasks 			= GetNum2DARows( TASKS_2DA );
//PrettyDebug( "() SetTask  : start for "+sCondition+" with "+IntToString(nTasks)+" tasks"  );
	//
	string sId, sEff;
	//
	// READING FROM THE 2DA IS AN UGLY SOLUTION
	//
	for( i = 0; i < nTasks; i++ ){ 
		//
		sId 			= Get2DAString( TASKS_2DA, TASKS_2DA_ID, i );
		//
		sEff 			= Get2DAString( TASKS_2DA, TASKS_2DA_EFFECTS, i );
		//
//PrettyDebug( "() SetTask  : "+sId+" with effect :"+sEff  );
		//
		// MULTIPLE TASKS TOKENIZATION MIGHT BE IN ORDER 
		//
		// Task Level Iteration, ie: NearObject:Food
		
		sEff 			= GetEffectFromTuple( sEff) ;
//PrettyDebug( "() SetTask  : Retrieved sEff from eventual tuple " + sEff);

		if( sEff == sCondition ){
//PrettyDebug( "() SetTask  : Found required task : " + sId);
			//
			AddToStorageString( oNPC, TASKS_ARRAY, IntToString( GetStorageCount( oNPC, TASKS_ARRAY ) + 1 ), sId );
			//
			return TRUE;
			
		
		}

	//
	}
	//
//PrettyDebug( "()	SetTask  finished"  );
	return nRet;	

	

// return TRUE;
}




 // returns bValid TRUE if valid plan 
int getPlanTasks( object oNPC, string sEffects ){

	int bConditions, bValid = FALSE;
	//
	string sConditions;
	//
	object oTasks = CreateStorage( oNPC, TASKS_ARRAY );
	//
	while( FALSE == bConditions ){
//PrettyDebug( "?? Searching with sEffects : "+sEffects );

		bConditions 	= SetTask( oNPC, oTasks, sEffects );
		//
		if( FALSE == bConditions) { // If the task can't be achieved
//PrettyDebug( " : bConditions : FALSE" );
			//
			bValid 		= FALSE;
			//
			break;
			
		}
		string sTask 	= GetStorageLastValueString( oNPC, TASKS_ARRAY );
		//
		sConditions		= GetTaskConditions( sTask );
		//
//PrettyDebug( "?? New conditions : "+sConditions );
		if( GetConditionsValid( oNPC, sConditions ) ){
//PrettyDebug( " : bConditions : TRUE" );
			//
			bValid 		= TRUE;
			//
			bConditions = TRUE;
		
		}
		 else {
//PrettyDebug( " : bConditions : TRUE" );
			//
			bConditions = FALSE;
			//
			sEffects	= sConditions;
//PrettyDebug( "?? New sEffects : "+sEffects );
			
		}
		
	} 
	//
	return bValid;
}
	
//
int ExecutePlan( object oNPC ){
	
//PrettyDump( GetStorage( oNPC, TASKS_ARRAY ) );
	string sAction;
	//
	int i;
	//
	AssignCommand( oNPC, ClearAllActions( TRUE ) );
	// 
	for( i = GetStorageCount( oNPC, TASKS_ARRAY ) - 1; i >=0 ; i-- ){ // Retrieving last first

		sAction 		= GetTaskActions( GetStorageStringAtIndex( oNPC, TASKS_ARRAY, i ) );
//PrettyDebug( "()	ExecutePlan  action : " + sAction );
		//
		if( ! ExecuteTaskAction( oNPC, sAction ) ) 
			//
			return FALSE;
		
	}
	// 
	return TRUE;

}