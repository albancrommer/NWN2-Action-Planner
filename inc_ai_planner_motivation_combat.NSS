// inc_ai_planner_motivation_combat
/*
	Description:
	
*/
// Name_Date


#include "inc_ai_planner_const"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_worldstate"
#include "inc_ai_planner_motivations_limit"




// **************************************************************
// Utilities
// **************************************************************

// Helps avoiding divide by Zero errors
float _safeDivide( float fDivident, float fDivisor ){

	if( fDivisor == 0.0 ) {
		fDivisor = 0.01;
	}
	PrettyDebug( "_safeDivide : " + FloatToString( fDivident ) +":"+FloatToString( fDivisor) );
	return fDivident / fDivisor;
	
}

// Throttles the result of f1:f2 to make it under fLimit	
float CapDivide( float f1, float f2, float fLimit ){
	float fRes 					= _safeDivide( f1, f2 );
	if( fRes > fLimit )
		return fLimit;
	return fRes;
}

// **************************************************************
// Controller basics : instancing, deleting, adding, removing
// **************************************************************



// Adds PC to controller
int TargetAddToCombatController( object oCombatController, object oNPC ){


	return TRUE;

}


// Removes PC from controller
int TargetRemoveFromCombatController( object oCombatController, object oNPC ){

	return TRUE;

}


// Adds NPC to controller
int AddToCombatController( object oCombatController, object oNPC ){

	string sId 			= GetCreatureUniqueId( oNPC );
	// Quit if already added
	if( oNPC 		== GetStorageObject( oCombatController, STORAGE_TEAM_MEMBERS, sId )  ) 
		return FALSE;
	AddToStorageObject( oCombatController, STORAGE_TEAM_MEMBERS, sId, oNPC );
	return TRUE;

}


// Removes NPC from controller
int RemoveFromCombatController( object oCombatController, object oNPC ){

	return TRUE;

}

// Creates a combat controller at NPC location
object CreateCombatController( object oNPC ){
	
	// New object
	object oCombatController	= CreateObject( OBJECT_TYPE_PLACEABLE, TAG_COMBAT_CONTROLLER, GetLocation( oNPC ) );

	// Instanciate storage(s) on Controller
	GetStorage( oCombatController, STORAGE_COMBAT_STRATEGIES );
	GetStorage( oCombatController, STORAGE_TEAM_MEMBERS );
	GetStorage( oCombatController, STORAGE_ENEMY_MEMBERS );
	
	return oCombatController;
}


// returns or create the combat controller
object GetCombatControllerProxy( object oNPC ){

	// Use existing controller
	object oCombatController	= GetNearestObjectByTag( TAG_COMBAT_CONTROLLER, oNPC );
DebugObjectLocation( oCombatController );	
	if( GetIsObjectValid( oCombatController ) ) return oCombatController;
	// Create new controller
	oCombatController 		= CreateCombatController( oNPC );
DebugObjectLocation( oCombatController );		
	AddToCombatController( oCombatController, oNPC ); 
	
	return oCombatController;

}


// **************************************************************
// Controller Data : variables
// **************************************************************

// Simple accessor to int variable stored on controller
int GetTeamCount( object oCombatController ){

	return 1;
	return GetLocalInt( oCombatController, VAR_TEAM_COUNT );
}

int GetEnemiesCount( object oCombatController){
	
	return 0;
	return GetLocalInt( oCombatController, VAR_ENEMY_COUNT );
	
}


// **************************************************************
// Controller WorldState
// **************************************************************

// Immediate Danger depends on the presence of actual enemies
float SetImmediateDanger( object oCombatController){

	float fImmediateDanger;
	if( GetEnemiesCount( oCombatController ) ){ 
		fImmediateDanger		= 1.0 ;
	}
	else fImmediateDanger		=0.0 ;
	SetLocalFloat( oCombatController, VAR_CDATA_DANGER, fImmediateDanger );
	return fImmediateDanger;

}

// The inner mechanic could be changed to a precalculated list
// Area Knowledge is determined by nActualRecoWP / nMaxRecoWP
float SetAreaKnowledge( object oCombatController){

	int nTeamCount			= GetTeamCount( oCombatController );
	float nBigDistance 		= ( log( IntToFloat(nTeamCount) ) + 1 ) * COMBAT_ZONE_CHUNK ;
	int nMaxPoints 			= FloatToInt( 3.14*pow( nBigDistance, 2.0) / pow( COMBAT_ZONE_CHUNK, 2.2 ) );
	int nCurrentPoint 		= GetLocalInt( oCombatController, VAR_COUNT_RECO_POINTS );
	float fAreaKnowledge    = _safeDivide( IntToFloat( nCurrentPoint ), IntToFloat( nMaxPoints ) );
	SetLocalFloat( oCombatController, VAR_CDATA_AREA_KNOW, fAreaKnowledge);
	return fAreaKnowledge;
	
}


// Team Morale is determined by nDead / nMax team members
float SetTeamMorale( object oCombatController){

	int nDead 			= GetLocalInt( oCombatController, VAR_COUNT_DEAD );
	int nAll 			= GetLocalInt( oCombatController, VAR_COUNT_ALL );
	float fTeamMorale 	= _safeDivide( IntToFloat( nDead ), IntToFloat( nAll ) );
	SetLocalFloat( oCombatController, VAR_CDATA_MORALE, fTeamMorale);
	return fTeamMorale;
	 
}

// Checks each member of the team for its neighborhood to other team members.
// Returns the math product of each fraction of team as a fraction is nSubTeam:nTotalTeam
float GetSubteamsFractions( object oCombatController ){

	return 1.0;

}

// Position Quality is determined by multiplying the fractions of subteams nCurrent/nTotal
// ie. S = (4:7)*(2:7)*(1:7) = 14:343 and then sqrt the result ie. sqrt(S) = 0.202030509
// NOTE : eventually, this could be a static table for better perfs
float SetPositionQuality( object oCombatController){
	float fSubteamsFractions	= GetSubteamsFractions( oCombatController );
	float fPositionQuality = sqrt( fSubteamsFractions );
	SetLocalFloat( oCombatController, VAR_CDATA_POSITION, fPositionQuality);
	return fPositionQuality;
}

// Enemy Threat is determined by divising teams "Round To Live" by enemy team RTL
// my Rounds To Life is equal to my Hit Points divided by my enemies Damages per round
float SetEnemyThreat( object oCombatController){

	return 0.01;
	
}

// Performs calculations regarding the NPC team :
// . Team count
int GetTeamData( object oCombatController ){

	return FALSE;

}


// Performs calculations regarding the enemy team 
int GetEnemyData( object oCombatController ){

	return FALSE;

}

// **************************************************************
// Controller strategies
// **************************************************************

float GetStrategyAmbush( object oCombatController, float f1, float f2 ){

	return CapDivide( f1, f2, 3.0 );

}
float GetStrategyExplore( object oCombatController, float f1, float f2 ){

	return CapDivide( f1, f2, 3.0 );
	
}
float GetStrategyTaunt( object oCombatController, float f1, float f2 ){

	if( !GetEnemiesCount(oCombatController) ){
		return 0.0;}
	return CapDivide( f1, f2, 6.0 );
	
}
float GetStrategyFlee( object oCombatController, float f1, float f2 ){

	if( !GetEnemiesCount(oCombatController) ){
		return 0.0;}
	return CapDivide( f1, f2, 6.0 );
	
}
float GetStrategyReposition( object oCombatController, float f1, float f2 ){

	if( !GetEnemiesCount(oCombatController) ){
		return 0.0;}
	return CapDivide( f1, f2, 9.0 );
	
}
float GetStrategyAttack( object oCombatController, float f1, float f2 ){

	if( !GetEnemiesCount(oCombatController) ){
		return 0.0;}
	return CapDivide( f1, f2, 9.0 );
	
}

// **************************************************************
// Controller tactics
// **************************************************************

// **************************************************************
// Controller Goals assignments
// **************************************************************

int RunControllerLoop( object oCombatController ){

	GetTeamData(oCombatController );
	
	// Destroy self if team is empty
	if( GetLocalInt( oCombatController, VAR_TEAM_COUNT ) < 1 ){
		DestroyObject(oCombatController);
	}
	
	// Enemy info. Even with no enemy, the Controller stays up.
	GetEnemyData(oCombatController );
	
	// These methods are used to compute the team strategy
	float fImmediateDanger 		= SetImmediateDanger(oCombatController); 
	float fEnemyThreat 			= SetEnemyThreat(oCombatController);
	float fPositionQuality 		= SetPositionQuality(oCombatController);
	float fTeamMorale			= SetTeamMorale(oCombatController);
	float fAreaKnowledge 		= SetAreaKnowledge(oCombatController);


	// The highest of these indices determines the Strategy
	float fIsStrategyAmbush		= GetStrategyAmbush( oCombatController, fAreaKnowledge, fImmediateDanger);
	float fIsStrategyExplore	= GetStrategyExplore( oCombatController, fImmediateDanger, fAreaKnowledge );
	float fIsStrategyTaunt		= GetStrategyTaunt( oCombatController, fTeamMorale, fEnemyThreat);
	float fIsStrategyFlee		= GetStrategyFlee( oCombatController, fEnemyThreat, fTeamMorale);
	float fIsStrategyReposition	= GetStrategyReposition( oCombatController, fEnemyThreat, fPositionQuality);
	float fIsStrategyAttack		= GetStrategyAttack( oCombatController, fPositionQuality, fEnemyThreat);
PrettyDebug( "RunControllerLoop : "+FloatToString( fIsStrategyAmbush )+"/"+FloatToString( fIsStrategyExplore )+"/"+FloatToString( fIsStrategyTaunt )+"/"+FloatToString( fIsStrategyFlee )+"/"+FloatToString( fIsStrategyReposition )+"/"+FloatToString( fIsStrategyAttack )+"/");
	
	// Update and sort array to get the strategy
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_AMBUSH, fIsStrategyAmbush );	
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_EXPLORE, fIsStrategyExplore );	
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_TAUNT, fIsStrategyTaunt );	
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_FLEE, fIsStrategyFlee );	
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_REPOSITION, fIsStrategyReposition );	
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_ATTACK, fIsStrategyAttack );	
	SortStorageFloat(oCombatController, STORAGE_COMBAT_STRATEGIES);
	string sStrategy 			= GetStorageLastValueString( oCombatController, STORAGE_COMBAT_STRATEGIES );
PrettyDebug( "Current Strategy is : "+sStrategy );

	
	return FALSE;
}

// Defines the best tactical goal option for the NPC
int AssignTacticalGoal( string sStrategy, object oNPC ){

	PrettyDebug("AssignTacticalGoal::sStrategy = "+sStrategy );
	if( VAR_STRATEGY_EXPLORE == sStrategy ){
	
	}else if( VAR_STRATEGY_AMBUSH == sStrategy ){
	
	}else if( VAR_STRATEGY_TAUNT == sStrategy ){
	
	}else if( VAR_STRATEGY_FLEE == sStrategy ){
	
	}else if( VAR_STRATEGY_REPOSITION == sStrategy ){
	
	}else if( VAR_STRATEGY_ATTACK == sStrategy ){
	
	}else if( INVALID == sStrategy ){
	
	}
	
	return FALSE;
		 
}

// Defines a low but easy goal for the NPC
int AssingDefaultGoal( string sStrategy, object oNPC ){

	UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_COMBAT, 20.0 );
	UpdateMotivationsLimit( oNPC, 20.0 );

	return FALSE;
}


// Assigns one or many goals to NPC through controller
int AssignCombatGoals( object oNPC, object oCombatController ){

	// Retrieve the team's strategy
	string sStrategy 			= GetStorageLastValueString( oCombatController, STORAGE_COMBAT_STRATEGIES );
dump( GetStorage( oCombatController, STORAGE_COMBAT_STRATEGIES ) ) ;
	// "Buy" a goal according to strategy and capacities
	AssignTacticalGoal( sStrategy, oNPC ); 
	
	// A downgrading goal is provided to avoid null behaviours
	AssingDefaultGoal( sStrategy, oNPC ); 
	
	return FALSE;
	
}