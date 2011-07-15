// script_name
/*
	Description:
	
*/
// Alban 1008

const float 	PARAM_DOORS_DELAY    	= 60.0; // Time under which doors will be auto-closed
const float 	PARAM_DOORS_DISTANCE    = 2.0; // Distance under which doors can be auto-opened
const float 	PARAM_EXPLORE_ITER_ANG	= 57.0; // Iterated angle on exploration space reset 
const float 	PARAM_COMBAT_ZONE_CHUNK	= 17.0; // The base distance used for exploration space measurement
const float 	PARAM_WALKLINE_DIST		= 5.0; // Iterated distance to detect invalid locations 
const int		PARAM_EXPLORE_MAX_DEPTH	= 49; // # of lines in ai_planner_explore.2DA 
const int		PARAM_EXPLORE_MAX_RESET	= 1; // # of times you iterate the search 
const int		PARAM_EXPLORE_QUAL_ROUNDS	= 1; // # of rounds spent qualifying points
const int		PARAM_EXPLORE_RUN		= TRUE; // Has NPC run when exploring if TRUE
const int		PARAM_MAX_ROUNDS_BLOCKED= 2; // # of rounds an NPC is allowed to stay blocked
const int		PARAM_MAX_EXPLORATION	= 100; // # of times a team will try to qualify points on an area
const int		PARAM_WALKLINE_DEPTH	= 3; // # of iterations used to detect invalid locations
const float 	PARAM_CLOSE_ENOUGH		= 1.0; // Iterated distance to detect invalid locations 

const float 	MOTIVATIONS_LIMIT_VAL	= 10.0;
const string 	_2DA_EXPLORE			= "ai_planner_explore";
const string 	ACTION_SCRIPT_PREFIX	= "ai_planner_action_";
const string 	COMBAT 					= "COMBAT";
const string 	CONDITION_PARAM	 		= "CONDITION_PARAM";
const string 	CONDITION_RESULT		= "CONDITION_RESULT";
const string 	CONDITION_SCRIPT_PREFIX	= "ai_planner_condition_";
const string 	EFFECT_NOTHUNGRY	 	= "EFFECT_NOTHUNGRY";
const string 	EFFECT_NOTSLEEPY	 	= "EFFECT_NOTSLEEPY";
const string 	FATIGUE 				= "FATIGUE";
const string 	GOAL_COMBAT				= "GOAL_COMBAT";
const string 	GOAL_COMBAT_ATTACK		= "GOAL_COMBAT_ATTACK";
const string 	GOAL_COMBAT_AMBUSH		= "GOAL_COMBAT_AMBUSH";
const string 	GOAL_COMBAT_EXPLORE		= "GOAL_COMBAT_EXPLORE";
const string 	GOAL_COMBAT_FLEE		= "GOAL_COMBAT_FLEE";
const string 	GOAL_COMBAT_TAUNT		= "GOAL_COMBAT_TAUNT";
const string 	GOAL_COMBAT_REPOSITION	= "GOAL_COMBAT_REPOSITION";
const string 	GOALS_ARRAY	 			= "GOALS_ARRAY";
const string 	GOALS_LAST	 			= "GOALS_LAST";
const string 	GOALS_LAST_VALUE		= "GOALS_LAST_VALUE";
const string 	GOALS_STORAGE 			= "GOALS_STORAGE";
const string 	HUNGER 					= "HUNGER";
const string 	INVALID					= "INVALID";
const string 	MOTIVATIONS_LIMIT_VAR 	= "MOTIVATIONS_LIMIT_VAR";
const string 	STORAGE_COMBAT_STRATEGIES 	= "STORAGE_COMBAT_STRATEGIES";
const string 	STORAGE_ENEMY_MEMBERS 	= "STORAGE_ENEMY_MEMBERS";
const string 	STORAGE_EXPLORE_WAYPOINTS = "STORAGE_EXPLORE_WAYPOINTS";
const string 	STORAGE_TEAM_MEMBERS 	= "STORAGE_TEAM_MEMBERS";
const string 	TAG_COMBAT_CONTROLLER	= "ai_planner_combat_controller";
const string 	TAG_EXPLORE_WAYPOINT	= "ai_planner_explore_wp";
const string 	TAG_FORCED_COMBAT_WP	= "ai_planner_forced_combat";
const string 	TARGET	 				= "TARGET";
const string 	TASKS_ARRAY	 			= "TASKS_ARRAY";
const string 	TASKS_STORAGE 			= "TASKS_STORAGE";
const string 	TASKS_STORAGE_ID	 	= "TASKS_STORAGE_ID";
const string 	VAR_AREA_KNOWLEDGE		= "VAR_AREA_KNOWLEDGE";
const string 	VAR_CDATA_AREA_KNOW	 	= "VAR_CDATA_AREA_KNOW";
const string 	VAR_CDATA_DANGER		= "VAR_CDATA_DANGER";
const string 	VAR_CDATA_MORALE		= "VAR_CDATA_MORALE";
const string 	VAR_CDATA_POSITION		= "VAR_CDATA_POSITION";
const string 	VAR_CDATA_THREAT		= "VAR_CDATA_THREAT";
const string 	VAR_COMB_CONT_DFLT_LOC	= "VAR_COMB_CONT_DFLT_LOC"; // The default Location ie. first WP of Combat Controller
const string 	VAR_COMB_WP_HEIGHT		= "VAR_COMB_WP_HEIGHT";
const string 	VAR_COMB_WP_HEIGHT_RATIO = "VAR_COMB_WP_HEIGHT_RATIO";
const string 	VAR_COMB_CONT_HEIGHT_MIN = "VAR_COMB_CONT_HEIGHT_MIN";
const string 	VAR_COMB_CONT_HEIGHT_MAX = "VAR_COMB_CONT_HEIGHT_MAX";
const string 	VAR_COMB_CONT_WP_AMBUSH	= "VAR_COMB_CONT_WP_AMBUSH";
const string 	VAR_COMB_CONT_WP_RANGED	= "VAR_COMB_CONT_WP_RANGED";
const string 	VAR_COMB_CONT_WP_TAUNT	= "VAR_COMB_CONT_WP_TAUNT";
const string 	VAR_CONTROLLER_FACTION	= "VAR_CONTROLLER_FACTION";
const string 	VAR_COUNT_ALL			= "VAR_COUNT_ALL";
const string 	VAR_COUNT_DEAD			= "VAR_COUNT_DEAD";
const string 	VAR_COUNT_RECO_POINTS	= "VAR_COUNT_RECO_POINTS";
const string 	VAR_ENEMY_COUNT			= "VAR_TEAM_COUNT";
const string 	VAR_EXPLORE_CONT_INDEX	= "VAR_EXPLORE_CONT_INDEX";
const string 	VAR_EXPLORE_DESTINATION	= "VAR_EXPLORE_DESTINATION";
const string 	VAR_EXPLORE_MAX_WP		= "VAR_EXPLORE_MAX_WP";
const string 	VAR_EXPLORE_QUAL_ROUNDS	= "VAR_EXPLORE_QUAL_ROUNDS";
const string 	VAR_EXPLORE_RESET_COUNT	= "VAR_EXPLORE_RESET_COUNT";
const string 	VAR_FORCED_COMBAT	 	= "VAR_FORCED_COMBAT";
const string 	VAR_FORCED_COMBAT_DIST	= "VAR_FORCED_COMBAT_DIST";
const string 	VAR_NTH_EXPLORATION		= "VAR_NTH_EXPLORATION"; // The combat controller quantity of exploration attempts
const string 	VAR_OBJ_COMB_CONT		= "VAR_OBJ_COMB_CONT"; // The combat controller var on each NPC
const string 	VAR_PREVIOUS_LOCATION	= "VAR_PREVIOUS_LOCATION"; // Stores its previous location on NPC
const string 	VAR_QUALIFY_AMBUSH		= "VAR_QUALIFY_AMBUSH";
const string 	VAR_QUALIFY_AMBUSH_WP	= "VAR_QUALIFY_AMBUSH_WP";
const string 	VAR_QUALIFY_RANGED	 	= "VAR_QUALIFY_RANGED";
const string 	VAR_QUALIFY_RANGED_WP	= "VAR_QUALIFY_RANGED_WP";
const string 	VAR_QUALIFY_SURROUND_WP	= "VAR_QUALIFY_SURROUND_WP";

const string 	VAR_ROUNDS_BLOCKED		= "VAR_ROUNDS_BLOCKED"; // Stores # of rounds NPC is blocked at one place
const string 	VAR_STRATEGY_AMBUSH		= "VAR_STRATEGY_AMBUSH";
const string 	VAR_STRATEGY_ATTACK		= "VAR_STRATEGY_ATTACK";
const string 	VAR_STRATEGY_EXPLORE	= "VAR_STRATEGY_EXPLORE";
const string 	VAR_STRATEGY_FLEE		= "VAR_STRATEGY_FLEE";
const string 	VAR_STRATEGY_REPOSITION	= "VAR_STRATEGY_REPOSITION";
const string 	VAR_STRATEGY_TAUNT	 	= "VAR_STRATEGY_TAUNT";
const string 	VAR_TEAM_COUNT			= "VAR_TEAM_COUNT";
const string 	WORLDSTATE	 			= "WORLDSTATE";






