// script_name
/*
	Description:
	
*/
// Alban 1008


const float 	COMBAT_ZONE_CHUNK  		= 30.0;
const float 	MOTIVATIONS_LIMIT_VAL	= 10.0;
const string 	ACTION_SCRIPT_PREFIX	= "ai_planner_action_";
const string 	COMBAT 					= "COMBAT";
const string 	CONDITION_PARAM	 		= "CONDITION_PARAM";
const string 	CONDITION_RESULT		= "CONDITION_RESULT";
const string 	CONDITION_SCRIPT_PREFIX	= "ai_planner_condition_";
const string 	EFFECT_NOTHUNGRY	 	= "EFFECT_NOTHUNGRY";
const string 	EFFECT_NOTSLEEPY	 	= "EFFECT_NOTSLEEPY";
const string 	FATIGUE 				= "FATIGUE";
const string 	GOAL_COMBAT				= "GOAL_COMBAT";
const string 	GOALS_ARRAY	 			= "GOALS_ARRAY";
const string 	GOALS_LAST	 			= "GOALS_LAST";
const string 	GOALS_LAST_VALUE		= "GOALS_LAST_VALUE";
const string 	GOALS_STORAGE 			= "GOALS_STORAGE";
const string 	HUNGER 					= "HUNGER";
const string 	INVALID					= "INVALID";
const string 	MOTIVATIONS_LIMIT_VAR 	= "MOTIVATIONS_LIMIT_VAR";
const string 	STORAGE_COMBAT_STRATEGIES 	= "STORAGE_COMBAT_STRATEGIES";
const string 	STORAGE_TEAM_MEMBERS 	= "STORAGE_TEAM_MEMBERS";
const string 	STORAGE_ENEMY_MEMBERS 	= "STORAGE_ENEMY_MEMBERS";
const string 	TARGET	 				= "TARGET";
const string 	TASKS_ARRAY	 			= "TASKS_ARRAY";
const string 	TASKS_STORAGE 			= "TASKS_STORAGE";
const string 	TASKS_STORAGE_ID	 	= "TASKS_STORAGE_ID";
const string 	VAR_AREA_KNOWLEDGE		= "VAR_AREA_KNOWLEDGE";
const string 	VAR_CDATA_DANGER		= "VAR_CDATA_DANGER";
const string 	VAR_CDATA_AREA_KNOW	 	= "VAR_CDATA_AREA_KNOW";
const string 	VAR_CDATA_POSITION		= "VAR_CDATA_POSITION";
const string 	VAR_CDATA_MORALE		= "VAR_CDATA_MORALE";
const string 	VAR_CDATA_THREAT		= "VAR_CDATA_THREAT";
const string 	VAR_COUNT_ALL			= "VAR_COUNT_ALL";
const string 	VAR_COUNT_DEAD			= "VAR_COUNT_DEAD";
const string 	VAR_COUNT_RECO_POINTS	= "VAR_COUNT_RECO_POINTS";
const string 	VAR_ENEMY_COUNT			= "VAR_TEAM_COUNT";
const string 	VAR_FORCED_COMBAT	 	= "VAR_FORCED_COMBAT";
const string 	VAR_FORCED_COMBAT_DIST	= "VAR_FORCED_COMBAT_DIST";
const string 	VAR_STRATEGY_AMBUSH		= "VAR_STRATEGY_AMBUSH";
const string 	VAR_STRATEGY_EXPLORE	= "VAR_STRATEGY_EXPLORE";
const string 	VAR_STRATEGY_TAUNT	 	= "VAR_STRATEGY_TAUNT";
const string 	VAR_STRATEGY_FLEE		= "VAR_STRATEGY_FLEE";
const string 	VAR_STRATEGY_REPOSITION	= "VAR_STRATEGY_REPOSITION";
const string 	VAR_STRATEGY_ATTACK		= "VAR_STRATEGY_ATTACK";
const string 	VAR_TEAM_COUNT			= "VAR_TEAM_COUNT";
const string 	TAG_COMBAT_CONTROLLER	= "ai_planner_combat_controller";

	

const string 	WORLDSTATE	 			= "WORLDSTATE";
const string 	WP_AREA_RECO	 		= "ai_planner_area_reco";
const string 	WP_FORCED_COMBAT	 	= "ai_planner_forced_combat";