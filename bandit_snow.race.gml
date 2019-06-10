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

instance_delete(RainDrop);
instance_delete(RainSplash);

// StreetLight Hydrant SodaMachine SnowMan
// sprNewsStand

#define race_name
// return race name for character select and various menus
return "Snow Bandit";


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