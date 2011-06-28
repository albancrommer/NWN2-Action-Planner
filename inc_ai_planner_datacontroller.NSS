// script_name
/*
	
	This file contains dataobject manipulations libraries reference
	
	You have to pick one library for each type of data manipulation or storage
	
	Some options might require your system to integrate other scripts :
	
	CSP : {Details}
	xp_utilities : {Details}
	
	However, the system is provided with libraries working out of the box.
	
	This controller contains no functions itself : it acts as a central reference 
	which all scripts can handy include without caring about the data object methods
	
	
*/
// Alban 1008


// == Arrays == 

// 	If you want to use CSP ListArrays
//  #include "inc_ai_planner_data_array_csp" 

// 	If you want to use the 1.23 functions on waypoints
	#include "inc_ai_planner_data_ar_wp" 

// 	If you want to use the nwnx plugin xp_utilities
//	#include "inc_ai_planner_data_array_xp" 

// == Tokenizer == 

// 	If you want to use the CSP string tokenizer
	#include "inc_ai_planner_data_tok_csp" 

// 	If you want to use the nwnx plugin xp_utilities
//	#include "inc_ai_planner_data_tok_xp" 


