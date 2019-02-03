#define init
// character select button
global.sprMenuButton = sprite_add("sprites/sprBanditSelect.png", 1, 0, 0);
// character select portrait
global.sprPortrait = sprite_add("/sprites/sprPortraitBandit.png", 1, 22, 210);

// character select sounds
// global.sndSelect = sound_add("sounds/sndBanditSelect.ogg");
// var _race = [];
// for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
// while(true){
// 	//character selection sound
// 	for(var i = 0; i < maxp; i++){
// 		var r = player_get_race(i);
// 		if(_race[i] != r && r = "bandit"){
// 			sound_play(global.sndSelect);
// 		}
// 		_race[i] = r;
// 	}
// 	wait 1;
// }


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprJockIdle;
spr_walk = sprJockWalk;
spr_hurt = sprJockHurt;
spr_dead = sprJockDead;
spr_fire = sprJockFire;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndJockHurt;
snd_dead = sndJockDead;
snd_fire = sndJockFire;

// stats
maxspeed = 2.6;
team = 2;
maxhealth = 25;
melee = 0;	// can melee or not

rocket_cooldown = 0;
hasFired = false;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;

u1 = ultra_get(player_get_race(index),1);

if(button_check(index,"fire")){
	if(rocket_cooldown <= 0){
		rocket_cooldown = 8 + u1*8;
		//fire rocket
		hasFired = true;
		image_index = 0;
		sound_play(snd_fire);
		d = point_direction(x,y,mouse_x[index],mouse_y[index]);
		a = lengthdir_x(5,d);
		b = lengthdir_y(5,d);
		for (i = 0; i < 1 + (u1 * 4); i++){
			with(instance_create(x+a,y+b,JockRocket)){
				creator = other;
				team = creator.team;

				direction = other.d + (other.u1 *(-20)) + (10*other.i*other.u1);

				image_angle = direction;
			}
		}
	}
}

if(hasFired = true){
	sprite_index = spr_fire;
	if(sprite_index = spr_fire and image_index > 2.5){
		hasFired = false;
	}
}

rocket_cooldown -= 1 * current_time_scale;

// outgoing contact damage
if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= 2;
			sound_play(snd_hurt);
			//has no melee sound
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
}

#define race_name
// return race name for character select and various menus
return "JOCK";


#define race_text
// return passive and active for character selection screen
return "FIRES MISSILES";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return false;


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
	case 1: return "lol";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "lol";
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
return choose("BUFF AS HELL", "FLEX FLEX", "LOOK AT MY MUSCLES");