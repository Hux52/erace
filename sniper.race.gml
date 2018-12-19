#define init
// character select button
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACOSURBVDhPYwCC/9jw231BRGGgWgoNmNua9B8bJtYgyg24cHTLf3yYkEGUG4DN+dgwLoMoNwCbs5Ex7Q2ASaDjPxaoGCZOPwNIwFgFice2GvL/QTjfw5IkTD0DsEkSgzFcgAtj0wzC1DMAmyQ+DDOYegbA0jxMApsmEEbXCE+JFBsAy23oGKYBl0YIDvoPABoXHHo1+L+9AAAAAElFTkSuQmCCAAAAAAAAAA==", 1, 0, 0);
global.sprPortrait = sprBigPortraitRebelBHooded; //temp

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprSniperIdle;
spr_walk = sprSniperWalk;
spr_hurt = sprSniperHurt;
spr_dead = sprSniperDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndSniperHit;
//snd_dead = doesn't have one

// stats
maxspeed = 1.1;
team = 2;
maxhealth = 6;
hasDied = false;


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;

if (my_health == 0 && hasDied == false){
	sound_play(sndExplosion);
	instance_create(x,y,Explosion);
	hasDied = true;
}

if (ultra_get("sniper", 1) == 1){
	wep = "sniper_ultra";
}

#define race_name
// return race name for character select and various menus
return "Sniper";


#define race_text
// return passive and active for character selection screen
return "LONG RANGED#EXPLODES ON DEATH";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return "sniper";


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
	case 1: return "CAN'T THINK OF A NAME";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "TIME TO CELEBRATE";
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
return choose("Warm Barrels", "Dust Proof", "Plunder", "Fire First, Aim Later");