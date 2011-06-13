
#include "ginc_debug"
#include "inc_ai_planner"


void main()
{
/*
	object oM = GetModule();
	
	SetLocalInt( oM,"a",1);
	SetLocalInt( oM,"b",2);
	dump( oM );
	SetLocalInt( oM,"a",2);
	dump( oM );
	DeleteLocalInt( oM,"a");
	dump( oM );

*/
// PrettyDebug( " start / ");
InitGoals();
//dump( GetStorage( GetCacheObject(), GOALS_STORAGE ) );
InitTasks();
//dump( GetStorage( GetCacheObject(), TASKS_STORAGE ) );


	
}