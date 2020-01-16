#define init
// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

global.sprMenuButton = sprite_add("sprites/selectIcon/sprNecromancerSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitNecromancer.png",1 , 25, 205);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Necromancer.png", 1, 10, 10);

// character select sounds
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
 	//character selection sound
 	for(var i = 0; i < maxp; i++){
 		var r = player_get_race(i);
 		if(_race[i] != r && r = "necromancer"){
			sound_play_pitchvol(sndFreakPopoRevive, 1.5, 0.5);
 			sound_play_pitchvol(sndNecromancerRevive, 1.2 ,1);
 		}
 		_race[i] = r;
 	}
	 // first chunk here happens at the start of the level, second happens in portal
	if(instance_exists(GenCont)) global.newLevel = 1;
	else if(global.newLevel){
		global.newLevel = 0;
		level_start();
	}
	var hadGenCont = global.hasGenCont;
	global.hasGenCont = instance_exists(GenCont);
	if (!hadGenCont && global.hasGenCont) {
		// nothing yet
	}

	wait 1;
}


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprNecromancerIdle;
spr_walk = sprNecromancerWalk;
spr_hurt = sprNecromancerHurt;
spr_dead = sprNecromancerDead;
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndNecromancerHurt;
snd_dead = sndNecromancerDead;

// stats
maxspeed = 3.6;
team = 2;
maxhealth = 6;
spr_shadow = shd24;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
melee = 0;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init

#define level_start
with(instances_matching(Player, "race", "necromancer")){
	if("ultra_timer" in self){
		if(ultra_timer < 60){ultra_timer = 60;}
	}
}

#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;
if(wep != "necromancer"){
	wep = "necromancer";
}

#define race_name
// return race name for character select and various menus
return "NECROMANCER";


#define race_text
// return passive and active for character selection screen
return "@sSPRAY @pNOXIOUS FUMES#@sREVIVE @rCORPSES";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return "necromancer";


#define race_avail
// return if race is unlocked
return 1;


#define race_menu_button
// return race menu button icon
sprite_index = global.sprMenuButton;

#define race_skins
// return number of skins the race has
return 1;


#define race_skin_avail
// return if skin is unlocked
return 1;

#define race_skin_button
// return skin switch button sprite
return global.sprIcon;


#define race_soundbank
// return build in race id for default sounds
return 0;


#define race_tb_text
// return description for Throne Butt
return "DOES NOTHING";


#define race_tb_take
// run when Throne Butt is taken
// player of race may not be alive at the time

#define race_ultra_name
// return a name for each ultra
// determines how many ultras are shown
switch(argument0){
	case 1: return "POISONOUS PACK";
	case 2: return "AUTO-REVIVE";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "@gFREAKS @sALSO APPLY @pPOISON";
	case 2: return "@sLET THEM @wDO THE WORK#@yFOR YOU";
	default: return "";
}


#define race_ultra_button
// called by ultra mutation button on creation
// recieves ultra mutation index
switch(argument0){
	case 1: return mskNone;
}


#define race_ultra_take
// recieves ultra mutation index
// called when ultra for race is picked
// player of race may not be alive at the time


#define race_ttip
// return character-specific tooltips
return choose("NECROMANCY", "FORBIDDEN MAGIC", "MUTANTS NEVER DIE", "ZOMBIES", "...THEY JUST RESPAWN");