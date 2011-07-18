// NW_C2_DEFAULT9
/*
    This shows how to replace the default onSpawn behaviour.
	Careful with that axe.
*/


void main()
{
	SetCreatureScriptsToSet( OBJECT_SELF, 11 );
	ExecuteScript( "e_npc_script_spawn", OBJECT_SELF );
}