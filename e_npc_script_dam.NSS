
#include "inc_ai_planner_motivation_combat"


void main(){
	
	object oNPC					= OBJECT_SELF;
	object oDamager 			= GetLastDamager();
	if (!GetIsObjectValid(oDamager)) {
		return;
	}
	
	// If friendly fire, do nothing
	if( !GetIsReactionTypeHostile( oDamager, oNPC ) ){
	
	}
	// If in combat, set flag on controller
	if( GetIsEnteredInCombat( oNPC ) ){
		SetCombatControllerFlagHarmed( oNPC );
	
	}
	

}