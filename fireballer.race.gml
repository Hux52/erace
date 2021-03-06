#define init
// character select button
global.sprMenuButton = sprite_add("sprites/selectIcon/sprFireBallerSelect.png", 1, 0, 0);
// character select portrait
global.sprPortrait = sprite_add("/sprites/portrait/sprPortraitFireBaller.png", 1, 10, 210);

global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_FireBaller.png", 1, 10, 10);

// character select sounds
global.sndSelect = sound_add("sounds/sndFireballerSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
 	//character selection sound
 	for(var i = 0; i < maxp; i++){
 		var r = player_get_race(i);
 		if(_race[i] != r && r = "fireballer"){
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
spr_idle = sprFireBallerIdle;
spr_walk = sprFireBallerIdle; //lol
spr_hurt = sprFireBallerHurt;
spr_dead = sprFireBallerDead;
spr_fire = sprFireBallerFire;
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndFireballerHurt;
snd_dead = sndFireballerDead;
snd_fire = sndFireballerFire;

// stats
maxspeed = 2;
team = 2;
maxhealth = 25;
melee = 0;	// can melee or not
spr_shadow = shd16;
spr_shadow_y = 2;


fire_cooldown = 0;
hasFired = false;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;
footstep = 10;
//he f l o a t
if(image_index > 2 and image_index < 4){
	spr_shadow = shd32;
	spr_shadow_y = 1;
} else {
	spr_shadow = shd48;
	spr_shadow_y = -4;
}

//passive: is floaty
friction = 0.2;

u1 = ultra_get(player_get_race(index),1);
u2 = ultra_get(player_get_race(index),2);

if(button_check(index,"fire")){
	if(fire_cooldown <= 0){
		fire_cooldown = 8;
		//fire fire
		hasFired = true;
		image_index = 0;
		sound_play(snd_fire);
		d = point_direction(x,y,mouse_x[index],mouse_y[index]);
		a = lengthdir_x(5,d);
		b = lengthdir_y(5,d);
		for (i = 0; i < 1 + (u1 * 4); i++){
			with(instance_create(x+a,y+b,FireBall)){
				creator = other;
				team = creator.team;
				speed = 3;
				damage = 3;
				direction = other.d + random_range(-4,4);
				image_angle = direction;
			}
		}
		view_shake[index] = 4.5;
	}
}

if(hasFired = true){
	sprite_index = spr_fire;
	if(sprite_index = spr_fire and image_index > 2.5){
		hasFired = false;
	}
}

fire_cooldown -= 1 * current_time_scale;

#define race_name
// return race name for character select and various menus
return "FIREBALLER";


#define race_text
// return passive and active for character selection screen
return "@sSHOOTS @yFIREBALLS#@sCAN @wFLOAT";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


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
return choose("NOM", "SPEW", "BASICALLY A DRAGON");