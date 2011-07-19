#include "inc_ai_planner_motivation_combat"

void main(){

	object oNPC = OBJECT_SELF;

	if( GetIsObjectValid( GetCombatControllerProxyCache( oNPC ) ) ){
	
		RemoveFromCombatController( oNPC ); 
	
	}

}