#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprExploFreakSelect.png", 1, 0,0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitExploFreak.png",1 , 5, 197);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_ExploFreak.png", 1, 10, 10);

// character select sounds
// global.sndSelect = sound_add("sounds/sndRatSelect.ogg");
// var _race = [];
// for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
// while(true){
// 	//character selection sound
// 	for(var i = 0; i < maxp; i++){
// 		var r = player_get_race(i);
// 		if(_race[i] != r && r = "rat"){
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
spr_idle = sprExploFreakIdle;
spr_walk = sprExploFreakWalk;
spr_hurt = sprExploFreakHurt;
spr_dead = sprExploFreakDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndExploFreakHurt;
snd_dead = sndExploFreakDead;

// stats
maxspeed = 3.6;
team = 2;
maxhealth = 5;
spr_shadow_y = 0;

// vars
melee = 1;	// can melee or not
exploded = 0;
died = false;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
boilcap = maxhealth;

// no weps
canswap = 0;
canpick = 0;

// sprite faces direction, as you have no weps
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

//TODO: purist
// outgoing contact damage
if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
	if(exploded <= 0){
		sound_play_pitchvol(sndExploFreakKillself, random_range(0.9,1.1), 0.45);
		instance_create(x,y,Explosion);
		exploded = 15;
	}
	with(instance_nearest(x,y,enemy)){
		if(sprite_index != spr_hurt){
			projectile_hit_push(self, 2, 4);
		}
	}
}

//TODO: purist
//big sploge at the cost of health on click
if(button_pressed(index, "spec")){
	if(my_health > 1){
		my_health -= 1;
		sound_play_pitchvol(sndExploFreakDead, random_range(0.5,0.7), 0.65);
		sound_play_pitchvol(sndExploFreakHurt, random_range(0.5,0.7), 0.45);
		sound_play_pitchvol(sndExplosionS, random_range(1.1,1.3), 0.65);
		instance_create(x,y,Explosion);
		
		for(i = 0; i < 16; i++){
			ang = 360/16;
			instance_create(x + lengthdir_x(65, ang*i), y + lengthdir_y(65, ang*i), SmallExplosion);
		}
	}
}

//speed
//TODO: purist
// en = instance_nearest(x,y,enemy);
// if(instance_exists(en)){
// 	x += lengthdir_x(1*current_time_scale, point_direction(x,y,en.x,en.y));
// 	y += lengthdir_y(1*current_time_scale, point_direction(x,y,en.x,en.y));
// }

if(my_health <= 0 and died = false){
	instance_create(x,y,Explosion);
	sound_play_pitchvol(sndExplosion, random_range(0.9,1.1), 0.65);
	died = true;
} else {
	died = false;
}

//explosion cooldown
exploded -= current_time_scale;

#define race_name
// return race name for character select and various menus
return "EXPLO FREAK";


#define race_text
// return passive and active for character selection screen
return "@yQUESTIONABLE @wSTRATEGY#@yEXPLOSION @wIMMUNITY#@yEXPLODE @wAT WILL";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


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
return choose("AAAAAHHHHH", "BOOM", "DRIPPING");