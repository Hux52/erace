#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACXSURBVDhPzZMxDoAgDEU7s3IOFyc3BwcvoKNHcfXUJpiSlFTzURAGhpcQ+vsoIdA6ja6ERgRElEx9AW8u+3ajm3oP2nvKSAp/8CJUSCUIzoECzxBC58ME+r45lAtkIaLZGHdYm0wQaBEKxqgjkPEFFIzRiECTLZBTtYCfUoMahXKBbkTNX/gJRMKg0BvlAt3M8B9HQYxxF3SMiB75OeSoAAAAAElFTkSuQmCC", 1, 0, 0);


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprExploderIdle;
spr_walk = sprExploderWalk;
spr_hurt = sprExploderHurt;
spr_dead = sprExploderDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_dead = sndFrogExplode;

// stats
maxspeed = 3;
team = 2;
maxhealth = 5;
spr_shadow = shd24;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
close = 0;
exploded = 0;

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

if(canwalk = 1){
	move_bounce_solid(true);
	motion_add(direction, maxspeed / 4);
}

if(collision_rectangle(x + 10, y + 10, x - 10, y - 10, enemy, 0, 1)){
	my_health = 0;
}
else if(collision_rectangle(x + 30, y + 10, x - 30, y - 10, enemy, 0, 1)){
	if(close = 0){
		sound_play(sndFrogClose);
		close = 30;
	}
}

if(close > 0){
	close--;
}

if(my_health = 0){
	for(i = 0; i < 360; i += 120){
		with(instance_create(x, y, AcidStreak)){
			speed = 8;
			direction = other.i + random_range(-30, 30);
		}
	}
	for(i = 0; i < 360; i += 45){
		with(instance_create(x, y, Bullet1)){
			creator = other;
			team = creator.team;
			sprite_index = sprScorpionBullet;
			direction = other.i + random_range(-5, 5);
			image_angle = direction;
			friction = 0;
			speed = 4;
			damage = 2;
		}
	}
	exploded = 1;
}

#define race_name
// return race name for character select and various menus
return "EXPLODER";


#define race_text
// return passive and active for character selection screen
return "CAN'T STAND STILL";


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
return choose("RIBBIT", "CAN'T STOP, PROBABLY WON'T STOP");