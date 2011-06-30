// script_name
/*
	Description:
	
*/
// Name_Date



#include "inc_ai_planner"
#include "X0_I0_POSITION"
#include "ginc_debug"

int CrowdAttractor( object oPC, object oObject, float fAttract, float fDist ){
	
	int nNth 			= 1;
	//
	object oController;
	//
	float fState;
	//
	object oNPC 		= GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oObject, nNth, CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE );
	//
	while( GetIsObjectValid( oNPC ) && GetDistanceBetween( oObject, oNPC ) < fDist ) {
	
//		PrettyDebugObjectLocation( oNPC, "blue" );
		
		oController = GetController( oNPC, oPC );
		
		if( GetIsObjectValid( oController ) ) {
		
			fState = GetInteractionControllerState( oController );
// PrettyDebug( "fAttract : " + FloatToString( fAttract ) );		
			if( fState < 0.2 && fState > -fAttract ) 
		
				SetInteractionControllerState( oController, -fAttract );
				
				AddToControllerList( oController, PC_CONTROLLER_STORAGE_ACTIVE_POSITIVE, oPC );
				
		}
		
//PrettyDebugObjectLocation ( oNPC);
		oNPC 		= GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oObject, ++nNth, CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE );
	
	}

	return TRUE;

}


void main()
{
	
	object oPC 			= GetLastSpellCaster();
	
	if( !GetIsPC( oPC ) ) return;
	
	object oObj			= OBJECT_SELF;
	//
	int nSpell 			= GetLastSpell();
	//
	int nLevel 			= GetSpellLevel( nSpell );
	
	// TODO : ADD CACHING / TIMESTAMP TO AVOID ATTRACTION SPAMMING
	
	float fAttract		= 1.0 * ( nLevel + 1 );
	
	float fDist			= 5.0 * ( nLevel + 1 );
	
	CrowdAttractor( oPC, oObj, fAttract, fDist );
	
	effect eEffect = EffectNWN2SpecialEffectFile( "fx_akachi_eater_hit");
	//
	ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eEffect, GetLocation( oObj ), IntToFloat( nLevel ) );

//ActionSpeakString( "Spell cast level " + IntToString( nLevel ) );

}