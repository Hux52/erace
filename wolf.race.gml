#define init
global.sprMenuButton = sprite_add("sprites/sprWolfSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/sprPortraitWolf.png",1 , 5, 190);

// character select sounds
global.sndSelect = sndHalloweenWolf;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "wolf"){
			sound_play_pitchvol(global.sndSelect,0.8,0.65);
		}
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprWolfIdle;
spr_walk = sprWolfWalk;
spr_hurt = sprWolfHurt;
spr_dead = sprWolfDead;
spr_fire = sprWolfFire; //rolling animation
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndWolfHurt;
snd_dead = sndWolfDead;

snd_roll = sndWolfRoll; //also for rolling

// stats
maxspeed_base = 3.1;
team = 2;
maxhealth = 12;
spr_shadow_y = 0;
friction_base = 0.45;
meleedamage = 2;
meleedamage_base = 2;

boost_time = 5;
fireDelay = 15;
is_rolling = false;
has_rolled = false;

// vars
melee = 1;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
if(button_pressed(index,"fire")){
	if(speed <= 0){
		d = point_direction(x,y,mouse_x[index],mouse_y[index]);
	} else {
		d = direction;
	}
	if(is_rolling = false){
		has_rolled = false;
		is_rolling = true;
		sprite_index = spr_fire;
		sound_play_pitchvol(snd_roll,random_range(0.9,1.1), 0.6);
	}
}

if(is_rolling){
	move_bounce_solid(true);

	meleedamage = meleedamage_base * 2;
	fireDelay -= 1 * current_time_scale;
	
	maxspeed = maxspeed_base * 1.5;
	friction = 0.15;
	canwalk = false;
	sprite_index = spr_fire;

	if(image_index >= 5 and image_index <= 6){
		image_index = 2;
	}

	if(has_rolled = false){
		motion_add(d,maxspeed/3);
	}

	if(speed > maxspeed*0.8){
		has_rolled = true;
	}

	if(fireDelay == 0) {
		for(i = 0; i < 3; i++){
			with(instance_create(x,y,AllyBullet)){
				creator = other;
				team = creator.team;
				direction = creator.direction - 10 + (other.i*10);
				image_angle = direction;
				speed = 5;
				damage = 3;
			}
		}
	}

	if(has_rolled){
		friction = 0.2;
		if(speed <= 1){
			is_rolling = false;
		}
	}

} else {
	canwalk = true;
	meleedamage = meleedamage_base;
	friction = friction_base;
	maxspeed = maxspeed_base;
	has_rolled = false;
	fireDelay = 15;
}
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

// outgoing contact damage
if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= other.meleedamage;
			sound_play(snd_hurt);
			//has no melee sound
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
}

#define race_name
// return race name for character select and various menus
return "ROBOT WOLF";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#@sCAN @wROLL";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


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
return choose("WOOF", "BARK", "STRAY MODE ENGAGED", "AWOO.WAV");