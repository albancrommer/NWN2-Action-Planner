
#include "ginc_debug"
#include "inc_ai_planner"
#include "ftpath_library"


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


	// This is the standard NWN2 Module on load script
	ExecuteScript("x2_mod_def_load", GetModule() );

	// Build our Areas ID cache for Fast Transarea Pathfinding. YAY!
	ftp_BuildCache();
	
	
}