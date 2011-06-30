// ai_planner_condition_
/*
	Condition for AI Planner system
	
*/
// Alban 1008

#include "inc_ai_planner_datacontroller"
#include "ginc_debug"


int GetIsNear( object oNPC, string sTag, int nType = OBJECT_TYPE_PLACEABLE, float fDist = 0.1 ){
	//
	int nNth 		= 1;
	//
	object oObj 	= GetNearestObject( nType, oNPC, nNth );
	//
	while( GetDistanceBetween( oNPC, oObj ) <= fDist ){
// PrettyDebug( "() GetIsNear : " +sTag+" looks for " + GetTag( oObj) );
// PrettyDebugObjectLocation( oObj);
		//
		if( sTag == GetTag( oObj ) ){
// PrettyDebug( "() GetIsNear : I found it ");
// PrettyDebugObjectLocation( oObj, "blue");
			//
			return TRUE;
			
		}
		oObj 		= GetNearestObject( nType, oNPC, nNth++ );
		//
		
	}
	//
	return FALSE;

}

void main()
{

	object oNPC					= OBJECT_SELF;
	//
	int bResult;
	//
	string sParam				= GetLocalString( oNPC, CONDITION_PARAM );
	//
	bResult 					= GetIsNear( oNPC, sParam );
	//
	SetLocalInt( oNPC, CONDITION_RESULT, bResult );

}