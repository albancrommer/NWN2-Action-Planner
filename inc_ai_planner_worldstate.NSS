// script_name
/*

	
*/
// Alban 1008



int GetWorldState( object oNPC , string sVar ){
	
	return GetLocalInt( oNPC, WORLDSTATE + "_" + sVar );
	
	 
}

void SetWorldState( object oNPC , string sVar, int bValue ){
	// 
	SetLocalInt( oNPC, WORLDSTATE + "_" + sVar, bValue );
}