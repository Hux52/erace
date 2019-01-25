#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACvSURBVDhPtZNBCoNADEVzhuLGS7gpFLEnsGtv0qMUuu2xBNceQ5iSwchPGEc0ungLJ/8/MuDQ5/sL/TAq+AwpiyrSPNoIEYXb/RkhW0Ze3VvBRSxfJ5CCPZcrbV7hsEAC9tuenytYC+RQGbdASqniVGtwtnTcAl49F0yhsm6BHe7G2BQ4Q3DmF2DhIMnDPej15rWycAb+HadA3j6D72KLRegW8BooYWQ9C2ZOElD4A9SnH6pljqYYAAAAAElFTkSuQmCC", 1, 0, 0);


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprNecromancerIdle;
spr_walk = sprNecromancerWalk;
spr_hurt = sprNecromancerHurt;
spr_dead = sprNecromancerDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

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
return "REVIVES @rCORPSES";


#define race_portrait
// return portrait for character selection screen and pause menu
return sprBigPortraitChickenHeadless;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


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
return sprMapIconChickenHeadless;


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
	case 1: return "NOTHING";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "DOES NOTHING";
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
return choose("NECROMANCY", "FORBIDDEN MAGIC", "HEROES NEVER DIE", "ZOMBIES");