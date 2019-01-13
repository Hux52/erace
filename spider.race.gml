#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACiSURBVDhPvZIxEkAwEEVzLJ3CFRiF1hE0zqDQuIzGXdzDTIjxM/FtNBvMPJPJ/v8K1lRFbjWY43EvcRiCHOePs1KwLpN1cICZx+aGnyUXDH0ngnl6gRR+A0X/EaXQGw9BW5c2RCqFpBdgsGXmhIUMchClEzAISDPH9wLggxe8eHoBVpOLuH8UGLUAARbgHr8PBSyQXyS1gIsxYqL/BOAuyO0ODw4D6C6rLowAAAAASUVORK5CYII=", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/sprPortraitRat.png",1 , 15, 185); //weird lookin spider

global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m = [
	sndBanditHit,
	sndSniperHit,
	sndRavenHit,
	sndScorpionHit,
	sndRatHit,
	sndGatorHit,
	sndBuffGatorHit,
	sndBigMaggotHit,
	sndSalamanderHurt
]

global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m = [
	sndBanditDie,
	sndRavenDie,
	sndScorpionDie,
	sndRatDie,
	sndGatorDie,
	sndBuffGatorDie,
	sndBigMaggotDie,
	sndSalamanderDead
]

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
spr_idle = sprSpiderIdle;
spr_walk = sprSpiderWalk;
spr_hurt = sprSpiderHurt;
spr_dead = sprSpiderDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndSpiderHurt;
snd_dead = sndSpiderDead;

//for ultra
snd_melee = sndSpiderMelee;

// stats
maxspeed_base = 2.6; //original wandering speed
maxspeed_close = 4.6;
maxspeed = 2.6;
team = 2;
maxhealth = 18;
spr_shadow_y = 0;
mask_index = mskCrownPed;

// vars
melee = 1;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

u1 = ultra_get("spider", 1);
u2 = ultra_get("spider", 2);

//ultra A: Cursed Carapace
if (u1 == 1){
	// sprites
	spr_idle = sprInvSpiderIdle;
	spr_walk = sprInvSpiderWalk;
	spr_hurt = sprInvSpiderHurt;
	spr_dead = sprInvSpiderDead;

	//melee sound
	snd_melee = sndMaggotBite;
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
with(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	if(sprite_index != spr_hurt){
		sprite_index = spr_hurt;
		my_health -= 3;
		sound_play(snd_hurt);
		sound_play_pitchvol(other.snd_melee, random_range(0.9, 1.1), 0.6);
		direction = other.direction;
	}
}

//speed changes
e = instance_nearest(x,y,enemy);
if(instance_exists(e)){
	if (point_distance(x,y,e.x,e.y) < 100){
		maxspeed = lerp(maxspeed, maxspeed_close, 0.25);
	} else {
		maxspeed = lerp(maxspeed, maxspeed_base, 0.05);
		}
} else {
	maxspeed = lerp(maxspeed, maxspeed_base, 0.05);
}

//ultra A:
if(u1 == 1){
	if(my_health < 1){
		if(random(100) < 25){
			//hydra-like splitting event; split into two spiders with 17 health
			my_health = 17;
			with(instance_create(x, y, CustomHitme)){
					name = "CursedSpiderFriendly";
					creator = other;
					team = creator.team;
					//sprites
					spr_idle = sprInvSpiderIdle;
					spr_walk = sprInvSpiderWalk;
					spr_hurt = sprInvSpiderHurt;
					spr_dead = sprInvSpiderDead;

					sprite_index = spr_idle;
					
					//sounds
					

					my_health = 17;
					maxspeed = 2.6;
					mask_index = mskSpider;
					size = 1;
					image_speed = 0.3;
					spr_shadow = shd24;
					direction = random(360);
					move_bounce_solid(true);
					my_damage = 3;
					right = choose(-1, 1);
					alarm = [0];	// movement/targeting alarm
					on_step = script_ref_create(spood_step);
					on_hurt = script_ref_create(spood_hurt);
					on_destroy = script_ref_create(spood_destroy);
					// friendly outline
					playerColor = player_get_color(creator.index);
					toDraw = self;
					script_bind_draw(draw_outline, depth, playerColor, toDraw);
				}
		}
	}
}

#define race_name
// return race name for character select and various menus
return "Crystal Spider";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE";


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
	case 1: return "Cursed Carapace";
	case 2: return "Lightning Style";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "Become @pCursed";
	case 2: return "Radiate @bLightning";
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
switch(argument0){
	case 1: 
	// sounds
		snd_hurt = global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m[irandom_range(0,array_length_1d(global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m)-1)];
		snd_dead = global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m[irandom_range(0,array_length_1d(global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m)-1)];
		
	break;
}


#define race_ttip
// return character-specific tooltips
return choose("So smooth", "Shot web", "So shiny", "Many legs", "Many eyes");


#define spood_step
if(my_health > 0){
	// speed management
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	// collision
	move_bounce_solid(true);
	
	// sprite facing based on direction
	if(speed > 0 and sprite_index != spr_hurt){
		sprite_index = spr_walk;
	}
	else if(sprite_index != spr_hurt){
		sprite_index = spr_idle;
	}
	
	if(direction > 90 and direction <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
	// face right or left
	if(right = 1){
		image_xscale = 1;
	}
	else{
		image_xscale = -1;
	}

	// targeting
	if(instance_exists(enemy)){
		var _e = instance_nearest(x, y, enemy);
		if(distance_to_object(_e) < 200 and !collision_line(x, y, _e.x, _e.y, Wall, true, true)){
			target = _e;
		}
		else{
			target = noone;
		}
	}
	else{
		target = noone;
	}

	// movement
	if(target = noone){	// no target, random movement
		if(alarm[0] = 0){
			direction = random(360);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			alarm[0] = irandom_range(10, 30);
		}
	}
	else{
		if(alarm[0] = 0){	// target, persue
			direction = point_direction(x, y, target.x, target.y) + random_range(-50, 50);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			alarm[0] = irandom_range(30, 40);
		}
	}


	var _w = instance_nearest(x, y, Wall);
	// OLD WALL DEBUG
	/*if(collision_rectangle(_w.x, _w.y + 15, _w.x + 15, _w.y, self, false, false)){
		//trace("hit wall");		// debug
		var _f = instance_nearest(x, y, Floor);
		x = _f.x + 8;
		y = _f.y + 8;
	}*/

	// stop hit sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	// alarm management
	for(i = 0; i < array_length_1d(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]--;
		}
	}
	
	// incoming/outgoing contact damage
	with(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
		if(sprite_index != spr_hurt){
			my_health -= other.my_damage;
			sound_play(snd_hurt);
			sound_play(sndMaggotBite);
			sprite_index = spr_hurt;
			if(meleedamage > 0){
				other.my_health -= meleedamage;
			}
		}
	}
}
else{
	instance_destroy();
}

#define spood_destroy
// make corpse
with(instance_create(x, y, Corpse)){
	sprite_index = sprFreak1Dead;
	size = 1;
}

#define spood_hurt(damage, kb_vel, kb_dir)
// incoming damage
if(sprite_index != spr_hurt){
	my_health -= argument0;
	motion_add(argument2, argument1);
	nexthurt = 3;
	sprite_index = spr_hurt;
}

#define draw_outline(playerColor, toDraw)
d3d_set_fog(1,playerColor,0,0);
if(instance_exists(toDraw)){
    with(toDraw){
        draw_sprite_ext(sprite_index, -1, x - 1, y, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x + 1, y, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y - 1, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y + 1, 1 * right, 1, 0, playerColor, 1);
    }
}
d3d_set_fog(0,c_lime,0,0);