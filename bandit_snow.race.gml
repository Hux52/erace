#define init
// character select button
global.sprMenuButton = sprite_add("sprites/selectIcon/sprSnowBanditSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("/sprites/portrait/sprPortraitSnowBandit.png", 1, 22, 210);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_snowbandit.png", 1, 10, 10);

// character select sounds
global.sndSelect = sound_add("sounds/sndSnowBanditSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "bandit_snow"){
			sound_play(global.sndSelect);
		}
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprSnowBanditIdle;
spr_walk = sprSnowBanditWalk;
spr_hurt = sprSnowBanditHurt;
spr_dead = sprSnowBanditDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndBanditHit;
snd_dead = sndBanditDie;

// stats
maxspeed = 3;
team = 2;
maxhealth = 8;
mask_index = mskPlayer;
melee = 0;	// can melee or not
spinning = 0;
spun = 0;
spins = 0;


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;
if(wep != "bandit"){
	wep = "bandit";
}

with(Floor){
	if(random(1000) < current_time_scale){
		with(instance_create(x+18,y+16,SnowFlake)){
			addx = -5;
		}
	}
	switch(sprite_index){
		case sprFloor0:
		case sprFloor1:
		case sprFloor1B:
		case sprFloor3:
		case sprFloor3B:
		material = 1;
		sprite_index = sprFloor5;
		break;

		case sprFloor0Explo:
		case sprFloor1Explo:
		case sprFloor3Explo:
		material = 2;
		sprite_index = sprFloor5Explo;
		break;
	}
}

with(prop){
	switch(object_get_name(object_index)){
		case "Cactus":
		case "NightCactus":
		case "BigSkull":
		case "BonePile":
		case "BonePileNight":
		case "Tires":
		toReplace = choose(Hydrant, Hydrant, Hydrant, StreetLight, SodaMachine, SodaMachine, SnowMan);
		with(instance_create(x,y,toReplace)){
			if(object_index = Hydrant){
				if(random(100) < 5){
					spr_idle = sprNewsStand;
					spr_hurt = sprNewsStandHurt;
					spr_dead = sprNewsStandDead;
				}
			}
		}
		instance_delete(self);
		break;
	}
}

with(RainDrop){
	instance_destroy();
}
instance_delete(RainSplash);

if(button_pressed(index, "spec") and spinning = 0 and spins < 3){
	spins += 1;
	sound_play_pitchvol(sndEnemySlash, (spins * 0.2) + random_range(0.7, 0.9), 2);
	spinning = 8;
}

if(spinning > 0){
	spinning -= current_time_scale;
	// wepangle -= 360 - (current_time_scale * 20 / 20) * 13;
	canaim = 0
	reload = 5;
	gunangle = point_direction(x,y,mouse_x[index],mouse_y[index])
	script_bind_end_step(step_end, 0);
}

if(spinning <= 0){
	if(spun > 0){
		canaim = 1;
		reload = 0;
		sound_play_pitchvol(sndFootPlaMetal4, random_range(2.9, 3.1), 1.5);
	}
}

if(spins > 0){
	wkick = random(spins);
	if(random(12) < spins){
		with(instance_create(x, y, Smoke)){
			direction = random_range(75, 115);
			image_angle = random(360);
			image_xscale = 0.5;
			image_yscale = 0.5;
			speed = 3;
		}
	}
}
spun = spinning;

if(gunangle <= 180 and gunangle > 0){
	script_bind_draw(gun_draw, depth);
}
else{
	script_bind_draw(gun_draw, depth - 1);
}
script_bind_draw(gun_outline_draw, depth);



#define step_end
with(Player){
	if("spinning" in self){
		if(spinning > 0){
			gunangle = point_direction(x,y,mouse_x[index],mouse_y[index]) + (360 / (8 / spinning)) * right;
		}
	}
}
instance_destroy();

#define gun_draw
with(Player){
	if("spins" in self){
		// gun
		draw_sprite_ext(sprBanditGun, 0, x - lengthdir_x(wkick, gunangle + wepangle), y - lengthdir_y(wkick, gunangle + wepangle), 1, right, gunangle + wepangle, merge_color(c_white, c_red, spins * 0.3), 1);
	}
}
instance_destroy();

#define gun_outline_draw
with(Player){
	if("spins" in self){
		// gun outline
		d3d_set_fog(1, player_get_color(index), 0, 0);
		draw_sprite_ext(sprBanditGun, -1, x - lengthdir_x(wkick, gunangle + wepangle) - 1, y - lengthdir_y(wkick, gunangle + wepangle), 1, right, gunangle, player_get_color(index), 1);
		draw_sprite_ext(sprBanditGun, -1, x - lengthdir_x(wkick, gunangle + wepangle) + 1, y - lengthdir_y(wkick, gunangle + wepangle), 1, right, gunangle, player_get_color(index), 1);
		draw_sprite_ext(sprBanditGun, -1, x - lengthdir_x(wkick, gunangle + wepangle), y - lengthdir_y(wkick, gunangle + wepangle) - 1, 1, right, gunangle, player_get_color(index), 1);
		draw_sprite_ext(sprBanditGun, -1, x - lengthdir_x(wkick, gunangle + wepangle), y - lengthdir_y(wkick, gunangle + wepangle) + 1, 1, right, gunangle, player_get_color(index), 1);
		d3d_set_fog(0,c_lime,0,0);
	}
}
instance_destroy();

// StreetLight Hydrant SodaMachine SnowMan
// sprNewsStand

#define race_name
// return race name for character select and various menus
return "SNOW BANDIT";


#define race_text
// return passive and active for character selection screen
return "HAS BANDIT RIFLE#@sVERY @wFESTIVE";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return "bandit";


#define race_avail
// return if race is unlocked
return true;

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
return choose("Happy Holidays", "Don't really like snow", "Kinda cold here", "Sound the bells", "Ho ho ho");