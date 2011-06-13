#include "inc_ai_planner"
int TrueRandom (int nMax) {

	int iTrueRandom;
	int iSeed = d100() + GetTimeMillisecond();
	
	iTrueRandom = iSeed % nMax;	

	return iTrueRandom;

}
void main() {

/*
	object oNPC = GetObjectByTag( "al_testingpc" );
	dump( GetControllerProxy( oNPC ) );
	DebugObjectLocation( oNPC );
*/

}