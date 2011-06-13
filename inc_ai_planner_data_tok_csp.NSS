
// script_name
/*
	
	
*/
// Alban 1008

#include "inc_csp_tokenizer"

string GetEffectFromTuple( string sString ){

//	if( ! TestStringAgainstPattern( ":" , sString ) ) // Erraticaly returns FALSE
		//
//		return sString;

	return CSLGetTokenByPosition( sString,  ":", 0);
	
}


string GetParamFromTuple( string sString ){

	return CSLGetTokenByPosition( sString,  ":", 1);
	
}