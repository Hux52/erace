#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprWolfSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitWolf.png",1 , 5, 190);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Robotwolf.png", 1, 10, 10);
global.mskDeflect = sprite_add("sprites/mskDeflect.png", 1, 12, 12);

// character select sounds
global.sndSelect = sndHalloweenWolf;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "wolf"){
			//sound_play_pitchvol(global.sndSelect,0.8,0.65);
			sound_play(sndWolfRoll);
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
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndWolfHurt;
snd_dead = sndWolfDead;

snd_roll = sndWolfRoll; //also for rolling

// stats
team = 2;
maxhealth = 12;
spr_shadow_y = 0;
meleedamage = 2;
meleedamage_base = 2;

melee_damage = 4;

// vars
melee = 1;	// can melee or not
roll_time = 0;
roll_extend = 0;

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
	if(roll_time <= 0 and roll_extend <= 0){
		roll_time = 15;
		roll_extend = 15;
		sprite_index = spr_fire;
		sound_play_pitchvol(snd_roll,random_range(0.9,1.1), 0.6);
		shield = instance_create(x, y, CustomSlash);
		with(CustomSlash){
			creator = other;
			team = creator.team;
			sprite_index = mskNone;
			mask_index = global.mskDeflect;
			index = creator.index;
			can_deflect = 1;
			image_speed = 0;
			walled = false;
			on_step = script_ref_create(shield_step);
			on_wall = script_ref_create(shield_wall);
			on_hit = script_ref_create(shield_hit);
			on_projectile = script_ref_create(shield_projectile);
			on_grenade = script_ref_create(shield_grenade);
			on_end_step = script_ref_create(shield_end_step);
		}
		view_shake[index] = 6;
	}
}

if(button_check(index, "fire")){
	if(roll_time <= 0 and roll_extend > 0){
		move_bounce_solid(true);

		meleedamage = meleedamage_base * 2;
		canwalk = false;
		sprite_index = spr_fire;

		if(image_index >= 5 and image_index <= 6){
			image_index = 2;
		}
		
		motion_add(d, maxspeed / 3);
		roll_extend -= 1 * current_time_scale;
		
		if(roll_extend <= 0){
			for(i = 0; i < 3; i++){
				sound_play_pitchvol(sndEnemyFire, random_range(0.9, 1.1), 1.4);
				with(instance_create(x,y,AllyBullet)){
					creator = other;
					team = creator.team;
					direction = creator.direction - 10 + (other.i*10);
					image_angle = direction;
					speed = 5;
					damage = 3;
				}
				view_shake[index] = 6;
			}
			if(instance_exists(shield)){
				instance_delete(shield);
			}
			canwalk = true;
			meleedamage = meleedamage_base;
			speed = 0;
		}
	}
}

if(roll_time > 0){
	move_bounce_solid(true);

	meleedamage = meleedamage_base * 2;
	canwalk = false;
	sprite_index = spr_fire;

	if(image_index >= 5 and image_index <= 6){
		image_index = 2;
	}

	motion_add(d, maxspeed / 3);
	roll_time -= 1 * current_time_scale;
}

if!(button_check(index, "fire")){
	if(roll_time <= 0 and roll_extend > 0){
		for(i = 0; i < 3; i++){
		sound_play_pitchvol(sndEnemyFire, random_range(0.9, 1.1), 1.4);
			with(instance_create(x,y,AllyBullet)){
				creator = other;
				team = creator.team;
				direction = creator.direction - 10 + (other.i*10);
				image_angle = direction;
				speed = 5;
				damage = 3;
			}
			view_shake[index] = 6;
			}
		if(instance_exists(shield)){
			instance_delete(shield);
		}
		canwalk = true;
		meleedamage = meleedamage_base;
		speed = 0;
		roll_extend = 0;
	}
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
			projectile_hit_push(self, other.melee_damage, 4);
		}
	}
}


#define shield_step
if(instance_exists(creator)){
	x = creator.x + lengthdir_x(creator.speed + 2, creator.direction);
	y = creator.y + lengthdir_y(creator.speed + 2, creator.direction);
	xprevious = x;
	yprevious = y;
}
else{
	instance_delete(self);
}

#define shield_projectile
sound_play_pitchvol(sndCrystalRicochet, random_range(0.9, 1.1), 1);
with(other){
	deflected = true;
	team = other.team;
	if(place_meeting(x + hspeed, y, other)){
		hspeed *= -1;
	}
	if(place_meeting(x, y + vspeed, other)){
		vspeed *= -1;
	}
	image_angle = direction;
	with(instance_create(x, y, Deflect)){
		direction = other.direction + random_range(-40, 40);
		image_angle = direction;
	}
}

#define shield_grenade
sound_play_pitchvol(sndCrystalRicochet, random_range(0.9, 1.1), 1);
with(other){
	deflected = true;
	team = other.team;
	if(place_meeting(x + hspeed, y, other)){
		hspeed *= -1;
	}
	if(place_meeting(x, y + vspeed, other)){
		vspeed *= -1;
	}
	image_angle = direction;
	with(instance_create(x, y, Deflect)){
		direction = other.direction + random_range(-40, 40);
		image_angle = direction;
	}
}




#define shield_wall
if(other.solid){
	walled = true;
}

#define shield_hit

#define shield_end_step
if(walled){
	x += hspeed_raw;
	y += vspeed_raw;
}


/*if(instance_exists(projectile)){
	var _b = instance_nearest(x, y, projectile);
	if(_b.team != team and _b.deflected = 0){
		with(_b){
			//Horizontal bounce
			if(place_meeting(x + hspeed, y, other)){
				direction = -direction + 180;
			}
			
			//Vertical bounce
			if(place_meeting(x, y + vspeed, other)){
				direction = -direction;
			}
			
			sprite_angle = direction;
			sound_play_pitch(sndCrystalRicochet, random_range(0.9, 1.1));
			deflected = true;
			team = other.team;
		}
	}
}*/


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
return global.sprIcon;


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
return choose("WOOF", "BARK", "STRAY MODE ENGAGED", "AWOO.WAV", "ARF!", "POODLE BITES");