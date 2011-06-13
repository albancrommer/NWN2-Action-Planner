// script_name
/*

	
	 
	
*/
// Alban 1008




#include "inc_ai_planner_const"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_worldstate"
#include "inc_ai_planner_motivations_limit"
#include "inc_ai_planner_motivation_social"


int UpdateWorldState_Social( object oNPC ) {

	object oController		= GetControllerProxy( oNPC );

	if( !GetIsObjectValid( oController ) )  {
	
		SetWorldState( oNPC , PC_INTERRACTION, FALSE );
		return TRUE;
	}
	
	if( GetReactionTo( oController, oNPC ) == R_NONE ){ 
	
		SetWorldState( oNPC , PC_INTERRACTION, FALSE );
		return TRUE;
	}
	else SetWorldState( oNPC , PC_INTERRACTION, TRUE );
	


	return FALSE;
	

}



// TODO : Implement the variety of possible reactions
int GetMotivation_Social( object oNPC ) {


	if( TRUE == GetWorldState( oNPC , PC_INTERRACTION ) ) 
	{
	
		object oController		= GetControllerProxy( oNPC );
		//
		int nReaction;
		//
		if( GetIsObjectValid( oController ) )  
	
			nReaction 		= GetReactionTo( oController, oNPC );
// 	PrettyDebug(  "Reaction" + IntToString( nReaction ) );
	
			switch( nReaction ) {
							
				case R_ESCAPE :  

					UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_ESCAPE, 20.0 );
	
					UpdateMotivationsLimit( oNPC, 10.0 );
				
				break;
				case R_FLEE	: 
				
					UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_FLEE, 9.0 );
	
					UpdateMotivationsLimit( oNPC, 10.0 );
				
				break;
				case R_AVOID :
				
					UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_STEP_AWAY, 4.4 );
	
					UpdateMotivationsLimit( oNPC, 2.0 );
				break;
				 
				case R_TALKSTRONG : 
				
					UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_STAND, 2.1 );
					
					SetCreatureStance( oNPC, "talkforce03" );
					
					SetNegativeStanding( oNPC, 1 );
	
					UpdateMotivationsLimit( oNPC, 1.0 );
					
				break;
				case R_NONE	 :  
				
					UpdateMotivationsLimit( oNPC, 1.0 );
					
				break;
				case R_WATCH : 
				
					UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_STAND, 2.2 );
	
					SetCreatureStance( oNPC, "idle" );
					
					SetNegativeStanding( oNPC, 0 );
	
					UpdateMotivationsLimit( oNPC, 1.0 );
					
				 break; 
				case R_CLAP	: 
				
					UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_STAND, 4.4 );
	
					SetCreatureStance( oNPC, "clapping" );
					
					SetNegativeStanding( oNPC, 0 );
	
					UpdateMotivationsLimit( oNPC, 1.0 );
					
				 break;
				case R_ADORE  :
				
					UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_STAND, 8.8 );
	
					SetCreatureStance( oNPC, "worship" );
					
					SetNegativeStanding( oNPC, 0 );
	
					UpdateMotivationsLimit( oNPC, 1.0 );
					
				break;			
				default: break;
			}
			
	} else {
	
		UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_FLEE, 0.0 );
	
	}

	return TRUE;
}