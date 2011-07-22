// ai_planner_action_taunt
/*
	Description: Takes care of the NPC taunting behaviour
	
*/
// Name_Date

#include "ginc_debug"
#include "inc_vectors"
#include "X0_I0_POSITION"
#include "inc_ai_planner_motivation_combat"
#include "inc_ai_planner_datacontroller"
#include "inc_ai_planner_locomotion"


// Main Loop
void main(){

	object oNPC 				= OBJECT_SELF;
	int nSubrace				= GetSubRace( oNPC );
	// Some creatures won't be taunting anyone : animals, living dead and the like
	if( 
		nSubrace == RACIAL_SUBTYPE_ANIMAL ||
		nSubrace == RACIAL_SUBTYPE_BEAST ||
		nSubrace == RACIAL_SUBTYPE_ABERRATION ||
		nSubrace == RACIAL_SUBTYPE_BEAST ||
		nSubrace == RACIAL_SUBTYPE_GHOSTWISE_HALF ||
		nSubrace == RACIAL_SUBTYPE_GIANT ||
		nSubrace == RACIAL_SUBTYPE_INCORPOREAL ||
		nSubrace == RACIAL_SUBTYPE_MAGICAL_BEAST ||
		nSubrace == RACIAL_SUBTYPE_OOZE ||
		nSubrace == RACIAL_SUBTYPE_OUTSIDER ||
		nSubrace == RACIAL_SUBTYPE_PLANT ||
		nSubrace == RACIAL_SUBTYPE_UNDEAD ||
		nSubrace == RACIAL_SUBTYPE_VERMIN 
	){
		ExecuteScript( SCRIPT_ATTACK, oNPC );
	
	}
	object oTarget				= GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oNPC );


}