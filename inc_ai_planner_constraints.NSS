// script_name
/*
	This file relates to constraints : tasks and goals used by the system
	
*/
// Alban 1008

// Reads from 2DA and stores in an array

#include "inc_ai_planner_datacontroller"
#include "ginc_debug"


const string GOALS_2DA					= "ai_planner_goals";
const string GOALS_2DA_ID				= "Id";
const string GOALS_2DA_COND				= "Preconditions";
const string GOALS_2DA_EFFECT			= "Effects";
const string TASKS_2DA					= "ai_planner_tasks";
const string TASKS_2DA_ID				= "Id";
const string TASKS_2DA_CONDITIONS		= "Preconditions";
const string TASKS_2DA_EFFECTS			= "Effects";
const string TASKS_2DA_ACTION			= "Actions";

object GetCacheObject(){

	return GetObjectByTag("2DA_CACHE");

}

// TODO : ADD 2ND CACHE STORAGE FOR TASKS

int InitTasks(){
	
	object oCache		= GetCacheObject();
	//
	object oA 			= CreateStorage( oCache, TASKS_STORAGE ); // cache all data from 2DA
	//
	object oAId 		= CreateStorage( oCache, TASKS_STORAGE_ID ); // cache only tasks Ids
	//
	int i;
	//
	int nTasks 			= GetNum2DARows( TASKS_2DA );
	//
	string sId, sCond, sEff, sAct;
	//
// PrettyDebug( "() InitTasks Count : " + IntToString( nTasks ) );
	for( i = 0; i < nTasks; i++ ){
		
		sId = Get2DAString( TASKS_2DA, TASKS_2DA_ID, i );
		//
		sCond = Get2DAString( TASKS_2DA, TASKS_2DA_CONDITIONS, i );
		//
		sEff = Get2DAString( TASKS_2DA, TASKS_2DA_EFFECTS, i );
		//
		sAct = Get2DAString( TASKS_2DA, TASKS_2DA_ACTION, i );
		//
		AddToStorageString( oCache, TASKS_STORAGE_ID, sId, sId  );
		//
		AddToStorageString( oCache, TASKS_STORAGE, sId + TASKS_2DA_CONDITIONS, sCond  );
		//
		AddToStorageString( oCache, TASKS_STORAGE, sId + TASKS_2DA_EFFECTS, sEff  );
		//
		AddToStorageString( oCache, TASKS_STORAGE, sId + TASKS_2DA_ACTION, sAct  );

		// PrettyDebug( "() InitTasks Task : " + sId + " : " + sCond + " / " + sEff + " / " + sAct );
	}
	//
// PrettyDump( oA);
// PrettyDump( oAId );
	return TRUE;
}


// Reads from 2DA and stores in an array
int InitGoals(){

	object oCache		= GetCacheObject();
	//
	object oA 			= CreateStorage( oCache, GOALS_STORAGE );
	//
	int i;
	//
	string sId, sCond, sEff;
	//
	int sCount 			= GetNum2DARows( GOALS_2DA );
// PrettyDebug( "() InitGoals Count : " + IntToString( sCount ) );
	//
	for( i = 0; i < sCount; i++ ){
		//
		sId 			= Get2DAString( GOALS_2DA, GOALS_2DA_ID, i );
		//
		sCond 			= Get2DAString( GOALS_2DA, GOALS_2DA_COND, i );
		//
		sEff 			= Get2DAString( GOALS_2DA, GOALS_2DA_EFFECT, i );
		//
		AddToStorageString( oCache, GOALS_STORAGE, sId + GOALS_2DA_COND, sCond  );
		//
		AddToStorageString( oCache, GOALS_STORAGE, sId + GOALS_2DA_EFFECT, sEff  );

		
// PrettyDebug( "() InitGoals Goal : " + sId + " : " + sCond + " / " + sEff  );
	}
// PrettyDump( oA);
	//
	return TRUE;
}