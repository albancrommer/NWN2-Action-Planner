// script_name
/*
	Description:
	
*/
// Name_Date


void main() {
	
	object oNPC				= OBJECT_SELF;
	AssignCommand( oNPC, ActionSpeakString( "I'm attacking" ) );
	object oAttackee		= GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oNPC );
	AssignCommand( oNPC, ActionAttack( oAttackee ) );

}