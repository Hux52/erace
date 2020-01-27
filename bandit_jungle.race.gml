#define init
// character select button
global.sprMenuButton = sprite_add("sprites/selectIcon/sprBanditSelect.png", 1, 0, 0);

global.sprPortrait = sprite_add("/sprites/portrait/sprPortraitJungleBandit.png", 1, 22, 210);

global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_JungleBandit.png", 1, 10, 10);

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprJungleBanditIdle;
spr_walk = sprJungleBanditWalk;
spr_hurt = sprJungleBanditHurt;
spr_dead = sprJungleBanditDead;
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndBanditHit;
snd_dead = sndBanditDie;

// stats
maxspeed = 3.6;
team = 2;
maxhealth = 9;
melee = 0;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;
if(wep != "bandit_popgun"){
	wep = "bandit_popgun";
}


#define race_name
// return race name for character select and various menus
return "JUNGLE BANDIT";


#define race_text
// return passive and active for character selection screen
return "HAS BANDIT RIFLE";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return "bandit_popgun";


#define race_avail
// return if race is unlocked
return 1;


#define race_menu_button
// return race menu button icon
sprite_index = global.sprMenuButton;

#define race_skins
// return number of skins the race has
return 0;


#define race_skin_avail
// return if skin is unlocked
return 0;

#define race_skin_button
// return skin switch button sprite
return mskNone;


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
return choose("Been waiting for this", "Squad's dead", "Tactical superiority", "Entering mission area");