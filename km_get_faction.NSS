// Get the faction of oTarget, return as an Integer
// 0 - Player
// 1 - Hostile
// 2 - Commoner
// 3 - Merchant
// 4 - Defender
// Returns -1 on Invalid Faction
// By Knightmare, Feb. 06, 2010
int KnightmareGetFaction(object oTarget)
	{
	// The following group are game default factions
	object oPlayer = GetFirstPC(TRUE);
	object oHostile = GetObjectByTag("faction_hostile");
	object oCommoner = GetObjectByTag("faction_commoner");
	object oMerchant = GetObjectByTag("faction_merchant");
	object oDefender = GetObjectByTag("faction_defender");
	
	// The following are for custom created factions
	// Replace faction_tag_custom# with the TAG of the custom faction NPC
	/* Uncomment if you need custom factions
	object oCustom1 = GetObjectByTag("faction_tag_custom1");
	object oCustom2 = GetObjectByTag("faction_tag_custom2");
	object oCustom3 = GetObjectByTag("faction_tag_custom3");
	object oCustom4 = GetObjectByTag("faction_tag_custom4");
	object oCustom5 = GetObjectByTag("faction_tag_custom5");
	object oCustom6 = GetObjectByTag("faction_tag_custom6");
	object oCustom7 = GetObjectByTag("faction_tag_custom7");
	object oCustom8 = GetObjectByTag("faction_tag_custom8");
	object oCustom9 = GetObjectByTag("faction_tag_custom9");
	object oCustom10 = GetObjectByTag("faction_tag_custom10");
	*/
	
	if(GetFactionEqual(oTarget, oPlayer))
		{
		return 0;
		}
	else if(GetFactionEqual(oTarget, oHostile))
		{
		return 1;
		}
	else if(GetFactionEqual(oTarget, oCommoner))
		{
		return 2;
		}
	else if(GetFactionEqual(oTarget, oMerchant))
		{
		return 3;
		}
	else if(GetFactionEqual(oTarget, oDefender))
		{
		return 4;
		}
		/* 
	else if(GetFactionEqual(oTarget, oCustom1))
		{
		return 5;
		}
	else if(GetFactionEqual(oTarget, oCustom2))
		{
		return 6;
		}
	else if(GetFactionEqual(oTarget, oCustom3))
		{
		return 7;
		}
	else if(GetFactionEqual(oTarget, oCustom4))
		{
		return 8;
		}
	else if(GetFactionEqual(oTarget, oCustom5))
		{
		return 9;
		}
	else if(GetFactionEqual(oTarget, oCustom6))
		{
		return 10;
		}
	else if(GetFactionEqual(oTarget, oCustom7))
		{
		return 11;
		}
	else if(GetFactionEqual(oTarget, oCustom8))
		{
		return 12;
		}
	else if(GetFactionEqual(oTarget, oCustom9))
		{
		return 13;
		}
	else if(GetFactionEqual(oTarget, oCustom10))
		{
		return 14;
		}
*/
	return -1;
	}
	
	
// Uncomment void main line below for syntax testing	
//void main() { }	
	