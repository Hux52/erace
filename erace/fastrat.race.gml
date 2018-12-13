#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACiSURBVDhPvZIxDkBAEEX3SEqJXiVRi8oF3EOlcRmNu7iHZFnxN+ub1cwiebLZ+f8VjKma0mowx+Ne4jAEOc4fZ6VgXSbr4AAzj+0NP0su6IdOBPP0Ain8Bor+I0qhNx6Cos5siFQKSS/AYMvNCQsZ5CBKJ2AQkGaO7wXABy948fQCrCYXcf8oMGoBAizAPX4fClggv0hqARdjxET/CcBdUNodXNPrwW8RonsAAAAASUVORK5CYII=", 1, 0, 0);


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprFastRatIdle;
spr_walk = sprFastRatWalk;
spr_hurt = sprFastRatHurt;
spr_dead = sprFastRatDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndFastRatHit;
snd_dead = sndFastRatDie;
snd_wrld = sndFastRatSpawn;

// stats
maxspeed = 4;
team = 2;
maxhealth = 7;
spr_shadow_y = 0;
mask_index = mskPlayer;
canwalk = 1;
age = 900;


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;

if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= 2;
			sound_play(snd_hurt);
			sound_play(sndFastRatMelee);
			sprite_index = spr_hurt;
		}
	}
}

age--;

if(age = 0){
	my_health = 0;
}

if(my_health = 0){
	with(instance_create(x, y, AcidStreak)){
		speed = 8;
		direction = other.direction;
	}
}

#define race_name
// return race name for character select and various menus
return "FAST RAT";


#define race_text
// return passive and active for character selection screen
return "AGING#CONTACT DAMAGE";


#define race_portrait
// return portrait for character selection screen and pause menu
return sprBigPortraitChickenHeadless;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return 0;


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
return choose("WHISKERS", "RABID", "ITCHY", "RODENT");