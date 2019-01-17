#define init
// character select button
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACOSURBVDhPYwCC/9jw231BRGGgWgoNmNua9B8bJtYgyg24cHTLf3yYkEGUG4DN+dgwLoMoNwCbs5Ex7Q2ASaDjPxaoGCZOPwNIwFgFice2GvL/QTjfw5IkTD0DsEkSgzFcgAtj0wzC1DMAmyQ+DDOYegbA0jxMApsmEEbXCE+JFBsAy23oGKYBl0YIDvoPABoXHHo1+L+9AAAAAElFTkSuQmCCAAAAAAAAAA==", 1, 0, 0);

global.sprPortrait = sprite_add("sprites/sprPortraitBuffGator.png", 1, 15, 200);
global.sprBuffGatorSmoke = sprite_add("sprites/sprBuffGatorSmoke.png", 8, 16, 16);

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprBuffGatorIdle;
spr_walk = sprBuffGatorWalk;
spr_hurt = sprBuffGatorHurt;
spr_dead = sprBuffGatorDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndBuffGatorHit;
snd_dead = sndBuffGatorDie;

// stats
maxspeed = 3;
team = 2;
maxhealth = 30;
melee = 0;	// can melee or not
weapon_custom_delay = -1; // delay for shotgun
smoke_buff = 0;
smoke_buff_bullets = 0;
smoke_buff_threshold = 60;

t1 = 0
t2 = 0
t3 = 0
t4 = 0

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;

canspec = true;

if(button_check(index,"nort")){
	t1 += 1
}

if(button_check(index,"sout")){
	t1 -= 1
}

if(button_check(index,"east")){
	t2 += 1
}

if(button_check(index,"west")){
	t2 -= 1
}

if(button_check(index, "spec")){
	canwalk = false;
	spr_idle = global.sprBuffGatorSmoke;
	if(smoke_buff_bullets < 3){
		smoke_buff += smoke_buff_bullets + 1;
		if (smoke_buff >= smoke_buff_threshold){	
			smoke_buff = 0;
			smoke_buff_bullets += 1;
		}
	}
} else {
	canwalk = true;
	spr_idle = sprBuffGatorIdle;
		if(smoke_buff > 0){
		smoke_buff -= 0.5;
		}
	}

if(reload > weapon_get_load(wep)-2){
	if(smoke_buff_bullets > 0){
		reload /= 2;
		smoke_buff_bullets -= 1;
	}
}
	
#define draw
smoke_buff_offsetx = 13;
if(smoke_buff_bullets = 0 && smoke_buff > 0){
	draw_rectangle(x - smoke_buff_offsetx, y - 20, x - smoke_buff_offsetx + 4, y - 20 - ((smoke_buff/smoke_buff_threshold)*8), true);
	}
if(smoke_buff_bullets = 1 && smoke_buff > 0){
	draw_rectangle(x - smoke_buff_offsetx + 10, y - 20, x - smoke_buff_offsetx +  10 + 4, y - 20 - ((smoke_buff/smoke_buff_threshold)*8), true);
	}
	if(smoke_buff_bullets = 2 && smoke_buff > 0){
	draw_rectangle(x - smoke_buff_offsetx + 20, y - 20, x - smoke_buff_offsetx +  20 + 4, y - 20 - ((smoke_buff/smoke_buff_threshold)*8), true);
	}

for (i = 0; i < smoke_buff_bullets; i++){
	draw_set_color(c_red);
	draw_rectangle(x - smoke_buff_offsetx + 10*i, y - 20, x - smoke_buff_offsetx + 10*i + 4, y - 28, false);
	draw_set_color(c_yellow);
	draw_rectangle(x - smoke_buff_offsetx + 10*i, y - 20, x - smoke_buff_offsetx + 10*i + 4, y - 22, false);
}

// draw_rectangle(x-20,y-20,x-20 + 4, y-40,false)
// draw_rectangle(x-20 + 10,y-20,x-20 + 4 + 10, y-40,false)




#define race_name
// return race name for character select and various menus
return "Buff Gator";


#define race_text
// return passive and active for character selection screen
return "GREEN AND MEAN";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return "gator_flakcannon";


#define race_avail
// return if race is unlocked
return false;


#define race_menu_button
// return race menu button icon
return mskNone;

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
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
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
return choose("Rippling pecs", "Absolutely massive", "Make way", "Blast em");