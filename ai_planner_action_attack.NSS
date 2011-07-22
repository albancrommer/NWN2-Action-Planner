// script_name
/*
	Description:
	
*/
// Name_Date

#include "inc_ai_planner_motivation_combat"
#include "ginc_debug"
#include "x0_i0_talent"
void main() {
	
	object oNPC				= OBJECT_SELF;
	object oAttackee		= GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oNPC );
	talent tTalent;
	AssignCommand( oNPC, ActionSpeakString( "I'm attacking" ) );
	AssignCommand( oNPC, ActionEquipMostEffectiveArmor() );
	if( GetHasRoleBuffer( oNPC ) ){
		if( TalentEnhanceOthers() ) { PrettyDebug(" TalentEnhanceOthers "); return; }
		if( TalentBardSong() ) { PrettyDebug(" TalentBardSong "); return; }
		if( TalentCureCondition() ) { PrettyDebug(" TalentCureCondition "); return; }
		if( TalentHeal() ) { PrettyDebug(" TalentHeal "); return; }
		if( TalentUseProtectionOthers() ) { PrettyDebug(" TalentUseProtectionOthers 1"); return; }
		if( TalentEnhanceOthers() ) { PrettyDebug(" TalentEnhanceOthers "); return; }
		if( TalentDebuff( oAttackee ) ) { PrettyDebug(" TalentDebuff "); return; }
		if( TalentSeeInvisible() ) { PrettyDebug(" TalentSeeInvisible "); return; }
		if( TalentBuffSelf( ) ) { PrettyDebug(" TalentDebuff "); return; }
	}
//	else
	if( GetHasRoleCaster( oNPC ) ){
		if( TalentHealingSelf() ) { PrettyDebug(" TalentHealingSelf "); return; }
		if( TalentSummonAllies() ) { PrettyDebug(" TalentSummonAllies "); return; }
		if( TalentSpellAttack( oAttackee ) ) { PrettyDebug(" TalentSpellAttack 1"); return; }
		if( TalentSeeInvisible() ) { PrettyDebug(" TalentSeeInvisible "); return; }
		if( TalentOthers(100, oAttackee) ) { PrettyDebug(" TalentOthers "); return; }
		if( TalentUseProtectionOthers() ) { PrettyDebug(" TalentUseProtectionOthers "); return; }
		if( TalentEnhanceOthers() ) { PrettyDebug(" TalentEnhanceOthers "); return; }

	}
//	else
	if( GetHasRoleRanged( oNPC ) ){
		AssignCommand( oNPC, ActionEquipMostDamagingRanged() );
	} else
	{
		AssignCommand( oNPC, ActionEquipMostDamagingMelee() );
	}
	AssignCommand( oNPC, ActionForceMoveToObject( oAttackee, TRUE ) );
	AssignCommand( oNPC, ActionAttack( oAttackee ) );

}

/*

TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_AREAEFFECT
TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION
TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_SINGLE
TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT
TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION
TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF
TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE
TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT
TALENT_CATEGORY_BENEFICIAL_HEALING_POTION
TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH
TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES
TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT
TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION
TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF
TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE
TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT
TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT
TALENT_CATEGORY_HARMFUL_MELEE
TALENT_CATEGORY_HARMFUL_RANGED
TALENT_CATEGORY_HARMFUL_TOUCH

*/