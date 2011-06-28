// script_name
/*
	
*/
// Alban 1008

#include "ginc_debug" 

int MotivationsLimitValid( object oNPC ){

	if( MOTIVATIONS_LIMIT_VAL > GetLocalFloat( oNPC, MOTIVATIONS_LIMIT_VAR ) ){
// PrettyDebug( "()	MotivationsLimitValid returns TRUE with Value " + FloatToString( GetLocalFloat( oNPC, MOTIVATIONS_LIMIT_VAR ) ) );
	
		return TRUE;
	}
// PrettyDebug( "()	MotivationsLimitValid returns FALSE with Value " + FloatToString( GetLocalFloat( oNPC, MOTIVATIONS_LIMIT_VAR ) ) );

	return FALSE;

} 

int UpdateMotivationsLimit( object oNPC, float fValue ){

	fValue			 += GetLocalFloat( oNPC, MOTIVATIONS_LIMIT_VAR );
	//
	SetLocalFloat( oNPC, MOTIVATIONS_LIMIT_VAR, fValue );
	//
	return TRUE;

} 

int ResetMotivationsLimit( object oNPC ){

	SetLocalFloat( oNPC, MOTIVATIONS_LIMIT_VAR, 0.0f );
	
	return TRUE;
	
} 