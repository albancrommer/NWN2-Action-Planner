// inc_ai_planner_motivation_combat
/*
	Description:
	
*/
// Name_Date


#include "inc_ai_planner_const"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_worldstate"
#include "inc_ai_planner_motivations_limit"
#include "km_get_faction"




// **************************************************************
// Utilities
// **************************************************************

// Helps avoiding divide by Zero errors
float _safeDivide( float fDivident, float fDivisor ){

	if( fDivisor == 0.0 ) {
		fDivisor = 0.01;
	}
	//PrettyDebug( "_safeDivide : " + FloatToString( fDivident ) +":"+FloatToString( fDivisor) );
	return fDivident / fDivisor;
	
}


// Throttles the result of f1:f2 to make it under fLimit	
float CapDivide( float f1, float f2, float fLimit ){
	float fRes 					= _safeDivide( f1, f2 );
	if( fRes > fLimit )
		return fLimit;
	return fRes;
}


// Retrieves the faction of an npc
// You might want to adapt that
int GetFaction( object oNPC ){

	// Uses Knightmare's function, kudos to him
	return KnightmareGetFaction( oNPC );
	
}


int PrettyDebugWPStorage( object oCombatController, string sArrayName ){

	object oStorage	= GetStorage( oCombatController, sArrayName );
	int nCount 		= GetStorageCount( oCombatController, sArrayName );
	int nI;
	object oWP;
	for( nI = 0; nI < nCount; nI++){
	
		oWP = GetVariableValueObject( oStorage, nI );
		PrettyDebugObjectLocation( oWP );
		
	}

	return FALSE;

}
// **************************************************************
// Controller Data : variables
// **************************************************************


// Reads the storage to retrieve the quantity of team members
int SetTeamCount( object oCombatController ){

	int nTeamCount 		= GetStorageCount( oCombatController, STORAGE_TEAM_MEMBERS );
	SetLocalInt( oCombatController, VAR_TEAM_COUNT, nTeamCount );
	//PrettyDebug("GetTeamData:: TeamCount : "+IntToString( nTeamCount ) );
	return nTeamCount;
}


// Reads team count stored on controller
int GetTeamCount( object oCombatController ){

	int nTeamCount 	= GetStorageCount( oCombatController, STORAGE_TEAM_MEMBERS );
	//PrettyDebug("GetTeamCount::nTeamCount="+IntToString(nTeamCount));
	return nTeamCount;
}


// Reads the storage to retrieve the quantity of enemy members
int SetEnemyCount( object oCombatController){
	
	int nEnemyCount 		= GetStorageCount( oCombatController, STORAGE_ENEMY_MEMBERS );
	SetLocalInt( oCombatController, VAR_ENEMY_COUNT, nEnemyCount );
	return nEnemyCount;
	
}

// Reads enemy count stored on controller
int GetEnemyCount( object oCombatController){

	return GetLocalInt( oCombatController, VAR_ENEMY_COUNT );
	
}


// Assigns faction to controller
int SetCombatControllerFaction( object oCombatController, int nFaction ){

	SetLocalInt( oCombatController, VAR_CONTROLLER_FACTION, nFaction );
	return FALSE;

}

// Retrieves faction for controller
int GetCombatControllerFaction( object oController ){

	return GetLocalInt( oController, VAR_CONTROLLER_FACTION );

}

// Performs calculations regarding the NPC team :
// . Team count
int GetTeamData( object oCombatController ){

	SetTeamCount( oCombatController );
	return FALSE;

}

// Performs a high level search and sort of enemies data
// Updates the enemy storage
int UpdateEnemyScope( object oCombatController ){

	return FALSE;
	
}

// Performs calculations regarding the enemy team 
// . Enemy Count
int GetEnemyData( object oCombatController ){
	
	UpdateEnemyScope( oCombatController );
	SetEnemyCount( oCombatController );
	return FALSE;

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
	if( oNPC 		== GetStorageObject( oCombatController, STORAGE_TEAM_MEMBERS, sId )  ){
	 	//PrettyDebug("AddToCombatController::EXIT WITH EXISTING NPC");
	 	return FALSE;
	}
			
	// Adds oNPC to Controller's Team Storage 
	AddToStorageObject( oCombatController, STORAGE_TEAM_MEMBERS, sId, oNPC );
	
	// Binds controller to NPC
	SetLocalObject( oNPC, VAR_OBJ_COMB_CONT, oCombatController );
	
	//PrettyDump( GetStorage( oCombatController, STORAGE_TEAM_MEMBERS ) );
	//PrettyDebug("AddToCombatController::ADDED NPC WITH UID="+sId);
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
//PrettyDebug( "CreateCombatController::"+GetObjectUniqueId( oCombatController )+" with tag "+ GetTag(oCombatController));
	
	int nFaction 				= GetFaction( oNPC );
	SetCombatControllerFaction( oCombatController, nFaction );
	
	// Instanciate storage(s) on Controller
	GetStorage( oCombatController, STORAGE_COMBAT_STRATEGIES );
	GetStorage( oCombatController, STORAGE_TEAM_MEMBERS );
	GetStorage( oCombatController, STORAGE_ENEMY_MEMBERS );
	
	return oCombatController;
}

// Checks for oNPC compatibility with oCombatController as a team controller
// we don't want anyone to team up with anyone in most cases
// Controllers at initiation could receive a set of constraints : subraces, faction etc. 
int GetIsCombatControllerValid( object oCombatController, object oNPC ){

	
	return GetCombatControllerFaction( oCombatController ) == GetFaction( oNPC ) ;
	
}

// returns or create the combat controller
object GetCombatControllerProxy( object oNPC ){

	object oCombatController;

	// Check if bind exists on NPC for a combat controller
	// AND if they're (still) in the same area
	oCombatController = GetLocalObject( oNPC, VAR_OBJ_COMB_CONT );
	if( GetIsObjectValid( oCombatController ) && GetArea( oNPC ) == GetArea( oCombatController ) ){
		//PrettyDebug( ObjectToString(oNPC)+"::GetCombatControllerProxy::Returned binded controller");
		AddToCombatController( oCombatController, oNPC ); 
		return oCombatController;
	}


	// Use existing controller if 1. one is near 2. this one is valid
	int nNth 			= 1;
	int bSolved			= FALSE;
	oCombatController	= GetNearestObjectByTag( TAG_COMBAT_CONTROLLER, oNPC, nNth );
	while( GetIsObjectValid( oCombatController ) && !bSolved ){
		if( GetIsCombatControllerValid( oCombatController, oNPC ) ){
			bSolved		= TRUE;
		}
	}
	
	
	//PrettyDebugObjectLocation( oCombatController, "blue" );	
	if( GetIsObjectValid( oCombatController ) ){
		//PrettyDebug( "GetCombatControllerProxy:: found valid controller");
		AddToCombatController( oCombatController, oNPC ); 
	 	return oCombatController;
	}
	 
	// Create new controller
	oCombatController 		= CreateCombatController( oNPC );
	AddToCombatController( oCombatController, oNPC ); 
	//PrettyDebugObjectLocation( oCombatController, "green" );		
	
	return oCombatController;

}


// **************************************************************
// Controller WorldState
// **************************************************************

// Immediate Danger depends on the presence of actual enemies
float SetImmediateDanger( object oCombatController){

	float fImmediateDanger;
	if( GetEnemyCount( oCombatController ) ){ 
		fImmediateDanger		= 1.0 ;
	}
	else fImmediateDanger		=0.5	 ;
	SetLocalFloat( oCombatController, VAR_CDATA_DANGER, fImmediateDanger );
	//PrettyDebug( "func::SetImmediateDanger:"+FloatToString(fImmediateDanger) );
	return fImmediateDanger;

}

int GetTeamMaxExploreWPCount( object oCombatController ){

	// Calculates the max WP depending on team count and store it for caching purpose
	int nTeamCount			= GetTeamCount( oCombatController );
	//PrettyDebug("SetAreaKnowledge nTeamCount:"+IntToString( nTeamCount ) );
	float nBigDistance 		= ( log( IntToFloat(nTeamCount) ) + 1 ) * COMBAT_ZONE_CHUNK ;
	int nMaxPoints 			= FloatToInt( 3.14*pow( nBigDistance, 2.0) / pow( COMBAT_ZONE_CHUNK, 2.2 ) );
	if( nMaxPoints < 2 ) {
		nMaxPoints = 2;
	}
	//PrettyDebug("GetTeamMaxExploreWPCount nMaxPoints:"+IntToString( nMaxPoints ) );
	return nMaxPoints;
}

// The inner mechanic could be changed to a precalculated list
// Area Knowledge is determined by nActualRecoWP / nMaxRecoWP
float SetAreaKnowledge( object oCombatController){

	int nMaxPoints			= GetTeamMaxExploreWPCount( oCombatController );

	SetLocalInt( oCombatController, VAR_EXPLORE_MAX_WP, nMaxPoints ); 
	// Gets the current amount of WP layed by team on map
	int nCurrentPoint 		= GetLocalInt( oCombatController, VAR_COUNT_RECO_POINTS );
	
	// Calculates the indice and stores it
	float fAreaKnowledge    = _safeDivide( IntToFloat( nCurrentPoint ), IntToFloat( nMaxPoints ) );
	SetLocalFloat( oCombatController, VAR_CDATA_AREA_KNOW, fAreaKnowledge);
	//PrettyDebug( "func::SetAreaKnowledge:"+FloatToString(fAreaKnowledge) );
	return fAreaKnowledge;
	
}


// Team Morale is determined by nDead / nMax team members
float SetTeamMorale( object oCombatController){

	int nDead 			= GetLocalInt( oCombatController, VAR_COUNT_DEAD );
	int nAll 			= GetLocalInt( oCombatController, VAR_COUNT_ALL );
	float fTeamMorale 	= _safeDivide( IntToFloat( nDead ), IntToFloat( nAll ) );
	SetLocalFloat( oCombatController, VAR_CDATA_MORALE, fTeamMorale);
	//PrettyDebug( "func::SetTeamMorale:"+FloatToString(fTeamMorale) );
	return fTeamMorale;
	 
}

// Checks each member of the team for its neighborhood to other team members.
// Returns the math product of each fraction of team as a fraction is nSubTeam:nTotalTeam
float GetSubteamsFractions( object oCombatController ){

	return 0.0;

}

// Position Quality is determined by multiplying the fractions of subteams nCurrent/nTotal
// ie. S = (4:7)*(2:7)*(1:7) = 14:343 and then sqrt the result ie. sqrt(S) = 0.202030509
// NOTE : eventually, this could be a static table for better perfs
float SetPositionQuality( object oCombatController){
	float fSubteamsFractions	= GetSubteamsFractions( oCombatController );
	float fPositionQuality = sqrt( fSubteamsFractions );
	SetLocalFloat( oCombatController, VAR_CDATA_POSITION, fPositionQuality);
	//PrettyDebug( "func::SetPositionQuality:"+FloatToString(fPositionQuality) );
	return fPositionQuality;
}

// Enemy Threat is determined by divising teams "Round To Live" by enemy team RTL
// my Rounds To Life is equal to my Hit Points divided by my enemies Damages per round
float SetEnemyThreat( object oCombatController){

	//PrettyDebug( "func::SetEnemyThreat:"+FloatToString(0.01) );
	return 0.01;
	
}


// **************************************************************
// Controller strategies
// **************************************************************

// fImmediateDanger : fAreaKnowledge
float GetStrategyExplore( object oCombatController, float f1, float f2 ){

	float fRes = CapDivide( f1, f2, 3.0 );
	//PrettyDebug( "func::GetStrategyExplore:"+FloatToString(f1)+"/"+FloatToString(f2)+"="+FloatToString(fRes) );
	return fRes;
	
}
// fAreaKnowledge, fImmediateDanger
float GetStrategyAmbush( object oCombatController, float f1, float f2 ){

	float fRes = CapDivide( f1, f2, 3.0 );
	//PrettyDebug( "func::GetStrategyAmbush:"+FloatToString(f1)+"/"+FloatToString(f2)+"="+FloatToString(fRes) );
	return fRes;
}

// fTeamMorale, fEnemyThreat 
float GetStrategyTaunt( object oCombatController, float f1, float f2 ){

	if( !GetEnemyCount(oCombatController) ){
		return 0.0;}
	float fRes = CapDivide( f1, f2, 6.0 );
	//PrettyDebug( "func::GetStrategyTaunt:"+FloatToString(f1)+"/"+FloatToString(f2)+"="+FloatToString(fRes) );
	return fRes;
	
}

// fEnemyThreat, fTeamMorale
float GetStrategyFlee( object oCombatController, float f1, float f2 ){

	if( !GetEnemyCount(oCombatController) ){
		return 0.0;}
	float fRes = CapDivide( f1, f2, 6.0 );
	//PrettyDebug( "func::GetStrategyFlee:"+FloatToString(f1)+"/"+FloatToString(f2)+"="+FloatToString(fRes) );
	return fRes;
	
}

// fEnemyThreat, fPositionQuality
float GetStrategyReposition( object oCombatController, float f1, float f2 ){

	if( !GetEnemyCount(oCombatController) ){
		return 0.0;}
	float fRes = CapDivide( f1, f2, 9.0 );
	//PrettyDebug( "func::GetStrategyReposition:"+FloatToString(f1)+"/"+FloatToString(f2)+"="+FloatToString(fRes) );
	return fRes;
	
}

// fPositionQuality, fEnemyThreat
float GetStrategyAttack( object oCombatController, float f1, float f2 ){

	if( !GetEnemyCount(oCombatController) ){
		return 0.0;}
	float fRes = CapDivide( f1, f2, 9.0 );
	//PrettyDebug( "func::GetStrategyAttack:"+FloatToString(f1)+"/"+FloatToString(f2)+"="+FloatToString(fRes) );
	return fRes;
	
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
//	if( GetLocalInt( oCombatController, VAR_TEAM_COUNT ) < 1 ){
//		//PrettyDebug( "RunControllerLoop: destroying Controller" );
//		DestroyObject(oCombatController);
//	}
	
	// Enemy info. Even with no enemy, the Controller stays up.
	GetEnemyData(oCombatController );
	
	// These methods are used to compute the team strategy
	float fImmediateDanger 		= SetImmediateDanger(oCombatController); 
	float fEnemyThreat 			= SetEnemyThreat(oCombatController);
	float fPositionQuality 		= SetPositionQuality(oCombatController);
	float fTeamMorale			= SetTeamMorale(oCombatController);
	float fAreaKnowledge 		= SetAreaKnowledge(oCombatController);


	// The highest of these indices determines the Strategy
	float fIsStrategyExplore	= GetStrategyExplore( oCombatController, fImmediateDanger, fAreaKnowledge );
	float fIsStrategyAmbush		= GetStrategyAmbush( oCombatController, fAreaKnowledge, fImmediateDanger);
	float fIsStrategyTaunt		= GetStrategyTaunt( oCombatController, fTeamMorale, fEnemyThreat);
	float fIsStrategyFlee		= GetStrategyFlee( oCombatController, fEnemyThreat, fTeamMorale);
	float fIsStrategyReposition	= GetStrategyReposition( oCombatController, fEnemyThreat, fPositionQuality);
	float fIsStrategyAttack		= GetStrategyAttack( oCombatController, fPositionQuality, fEnemyThreat);
	//PrettyDebug( "RunControllerLoop : "+FloatToString( fIsStrategyAmbush )+"/"+FloatToString( fIsStrategyExplore )+"/"+FloatToString( fIsStrategyTaunt )+"/"+FloatToString( fIsStrategyFlee )+"/"+FloatToString( fIsStrategyReposition )+"/"+FloatToString( fIsStrategyAttack )+"/");
	
	// Update and sort array to get the strategy
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_AMBUSH, fIsStrategyAmbush );	
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_EXPLORE, fIsStrategyExplore );	
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_TAUNT, fIsStrategyTaunt );	
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_FLEE, fIsStrategyFlee );	
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_REPOSITION, fIsStrategyReposition );	
	AddToStorageFloat( oCombatController, STORAGE_COMBAT_STRATEGIES, VAR_STRATEGY_ATTACK, fIsStrategyAttack );	
	SortStorageFloat(oCombatController, STORAGE_COMBAT_STRATEGIES);
	//PrettyDump( GetStorage( oCombatController, STORAGE_COMBAT_STRATEGIES) );
	string sStrategy 			= GetStorageLastVarName( oCombatController, STORAGE_COMBAT_STRATEGIES );
	//PrettyDebug( "Current Strategy is : "+sStrategy );

	PrettyDebugWPStorage( oCombatController, STORAGE_EXPLORE_WAYPOINTS);
	return FALSE;
	
}

// Defines the best tactical goal option for the NPC
int AssignTacticalGoal( string sStrategy, object oNPC ){

	//PrettyDebug("AssignTacticalGoal::sStrategy = "+sStrategy );
	if( VAR_STRATEGY_EXPLORE == sStrategy ){
	
		// Single tactic : look around and try to qualify 
		UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_COMBAT_EXPLORE, 20.0 );
		UpdateMotivationsLimit( oNPC, 20.0 );
	
	}else if( VAR_STRATEGY_AMBUSH == sStrategy ){
	
		// Tactic 1 : become hidden and position at low / hidden point
		
		// Tactic 2 : position at high point 
	
	}else if( VAR_STRATEGY_TAUNT == sStrategy ){

		// Single tactic : Shout at the enemy
		
	}else if( VAR_STRATEGY_FLEE == sStrategy ){
	
	}else if( VAR_STRATEGY_REPOSITION == sStrategy ){
	
	}else if( VAR_STRATEGY_ATTACK == sStrategy ){
	
	}else if( INVALID == sStrategy ){
	
	}
	
	return FALSE;
		 
}

// Defines a low but easy goal for the NPC
int AssignDefaultGoal( string sStrategy, object oNPC ){

	UpdateStorageFloat( oNPC, GOALS_ARRAY, GOAL_COMBAT, 10.0 );

	return FALSE;
}


// Assigns one or many goals to NPC through controller
int AssignCombatGoals( object oNPC, object oCombatController ){

	// Retrieve the team's strategy
	string sStrategy 			= GetStorageLastVarName( oCombatController, STORAGE_COMBAT_STRATEGIES );

	// "Buy" a goal according to strategy and capacities
	AssignTacticalGoal( sStrategy, oNPC ); 
	
	// A downgrading goal is provided to avoid null behaviours
	AssignDefaultGoal( sStrategy, oNPC ); 
	
	return FALSE;
	
}