<<<<<<< Updated upstream
#define init
global.sprMenuButton = sprite_add("sprites/sprSpiderSelect.png", 1, 0,0);
global.sprPortrait = sprite_add("sprites/sprPortraitRat.png",1 , 15, 185); //weird lookin spider

global.sprLightningSpiderIdle = sprite_add("/sprites/sprLightningSpiderIdle.png", 8, 12, 12);
global.sprLightningSpiderWalk = sprite_add("/sprites/sprLightningSpiderWalk.png", 6, 12, 12);
global.sprLightningSpiderHurt = sprite_add("/sprites/sprLightningSpiderHurt.png", 3, 12, 12);
global.sprLightningSpiderDead = sprite_add("/sprites/sprLightningSpiderDead.png", 6, 12, 12);

global.debug_haHAA = false; //for debugging. duh
if(global.debug_haHAA = true){trace("debug on");}

global.snd_hurt_current = sndSpiderHurt;
global.snd_dead_current = sndSpiderDead;
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

global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

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

// level start init- MUST GO AT END OF INIT
while(true){
	// first chunk here happens at the start of the level, second happens in portal
	if(instance_exists(GenCont)) global.newLevel = 1;
	else if(global.newLevel){
		global.newLevel = 0;
		level_start();
	}
	var hadGenCont = global.hasGenCont;
	global.hasGenCont = instance_exists(GenCont);
	if (!hadGenCont && global.hasGenCont) {
		// nothing yet
	}
	wait 1;
}

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

global.snd_hurt_current = snd_hurt;
global.snd_dead_current = snd_dead;


//for ultra
snd_melee = sndSpiderMelee;

// stats
maxspeed_base = 2.6 + (skill_get(mut_extra_feet) * 0.5); //original wandering speed
maxspeed_close = 4.6 + (skill_get(mut_extra_feet));
maxspeed = 2.6;
team = 2;
maxhealth = 18;
spr_shadow_y = 0;

//ultra a
has_spawned = false;
spooder_health = array_create(0);

//ultra b
lightning_timer = 0;

// vars
melee = 1;	// can melee or not

#define level_start
with(instances_matching(Player, "race", "spider")){
	for(i = 0; i < array_length(spooder_health); i++){
		spawn_spood(1,spooder_health[i]);
	}
	spooder_health = [];
}

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init

#define step
// executed within each player instance of this race after step
// most actives and passives handled here

//update stats for muts
maxspeed_base = 2.6 + (skill_get(mut_extra_feet) * 0.5); //original wandering speed
maxspeed_close = 4.9 + (skill_get(mut_extra_feet));

//passive - normal movement on all terrain
friction = 0.45

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

	//sounds
	snd_hurt = global.snd_hurt_current;
	snd_dead = global.snd_dead_current;
}

if(u2 == 1){
	// sprites
	spr_idle = global.sprLightningSpiderIdle;
	spr_walk = global.sprLightningSpiderWalk;
	spr_hurt = global.sprLightningSpiderHurt;
	spr_dead = global.sprLightningSpiderDead;

	if(lightning_timer > 0){
		lightning_timer -= 1;
	} else {
		lightning_timer = irandom_range(5,25);
		sound_play_pitchvol(sndLightningHit,random_range(0.6,0.8), 0.5);
		with(instance_create(x,y,LaserBrain)){
			image_angle = random(360);
		}
		num_lightning = irandom_range(3,5);
		for (i = 0; i < num_lightning; i++){
			with(instance_create(x + hspeed*2,y + vspeed*2,Lightning)){
				creator = other;
				image_angle = (360/creator.num_lightning)*creator.i;
				team = creator.team;
				ammo = 6;
				alarm_set(0,1);
			}
		}
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
with(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	_p = other;
	if(sprite_index != spr_hurt){
		sprite_index = spr_hurt;
		my_health -= 3;
		sound_play(snd_hurt);
		sound_play_pitchvol(other.snd_melee, random_range(0.9, 1.1), 0.6);
		direction = other.direction;

		//ultra B:
		if(_p.u2 == 1){
			with(instance_create(x, y, Lightning)){
				creator = other._p;
				image_angle = point_direction(other._p.x,other._p.y,other.x,other.y);
				team = other._p.team;
				ammo = 15;
				alarm_set(0, 5);
				sound_play_pitchvol(sndLightningPistol,random_range(0.9,1.1),0.75);
				with(instance_create(x,y,LightningSpawn)){
					image_angle = other.image_angle;
				}
			}
		}
	}
}

with(collision_rectangle(x + 12, y + 10, x - 12, y - 10, prop, 0, 1)){
	if(sprite_index != spr_hurt){
		sprite_index = spr_hurt;
		my_health -= 6;
		sound_play(snd_hurt);
		sound_play_pitchvol(other.snd_melee, random_range(0.9, 1.1), 0.6);
		direction = other.direction;
	}
}

//speed changes
e = instance_nearest(x,y,enemy);
if(instance_exists(e)){
	if (point_distance(x,y,e.x,e.y) < 125){
		//line of sight to enemy
		if(collision_line(x,y,e.x,e.y,Wall,false, true) == noone){
			maxspeed = lerp(maxspeed, maxspeed_close, 0.25);
		}
	} else {
		maxspeed = lerp(maxspeed, maxspeed_base, 0.05);
		}
} else {
	maxspeed = lerp(maxspeed, maxspeed_base, 0.05);
}
maxspeed *= 10;
maxspeed = floor(maxspeed);
maxspeed /= 10;

//ultra A: splitting
if(u1 == 1){
	if(my_health < 1){ //cheat death
		split_chance_death = random(100);
		if(split_chance_death <= 25 + (global.debug_haHAA*75)){
			my_health = maxhealth - 1 - (global.debug_haHAA * 16);
			spawn_spood(1,maxhealth-1);
		}
	}
	if(sprite_index == spr_hurt and image_index == 2){
		hit_split_chance = random(power(my_health/maxhealth, 2) * 100);
		if(hit_split_chance <= 10 + (90*global.debug_haHAA)){
			spawn_spood(1,ceil(maxhealth/3)+1);
		}
	}
	if(canspirit = 1){
		has_spawned = false;
	} else {
		if (has_spawned = false){
			has_spawned = true;
			spawn_spood(1,maxhealth-1)
		}
	}
}

#define race_name
// return race name for character select and various menus
return "Crystal Spider";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#@sNORMAL MOVEMENT #ON @wALL TERRAIN";


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
	case 2: return "Beacon of Lightning";
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
		global.snd_dead_current = global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m[irandom_range(0,array_length_1d(global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m)-1)];
		global.snd_hurt_current = global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m[irandom_range(0,array_length_1d(global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m)-1)];
	break;
}


#define race_ttip
// return character-specific tooltips
return choose("So smooth", "Shot web", "So shiny", "Many legs", "Many eyes");


#define spood_step
if(my_health > 0){
	// speed management
	speed = clamp(speed, 0, maxspeed);
	// collision
	move_bounce_solid(true);

	// targeting
	var _e = instance_nearest(x, y, enemy);
	var _p = instance_nearest(x, y, Player);
	if(instance_exists(_e) and distance_to_object(_e) < 100 and !collision_line(x, y, _e.x, _e.y, Wall, true, true)){
		if(target == _p or target == noone){instance_create(x,y-8,AssassinNotice)}
		maxspeed = 4.6;
		target = _e;
	} else if(instance_exists(_p) and player_get_race(_p.index) == "spider" and distance_to_object(_p) < 100 and !collision_line(x, y, _p.x, _p.y, Wall, true, true)){
		maxspeed = 4.6;
		target = _p;
	} else {
		maxspeed = 2.6;
		target = noone;
	}
	
	// movement
	if(canTarget = true){
		if(target = noone){	// no target, random movement
			if(alarm[0] = 0){
				if(random(100) < 45){
					friction = 0.2;
					direction = random(360);
					move_bounce_solid(true);
					motion_set(direction, maxspeed);
				}

				alarm[0] = irandom_range(10, 30);
			}
		}
		else{
			if(alarm[0] = 0){	// target, pursue
				direction = point_direction(x, y, target.x, target.y) + random_range(-25, 25);
				move_bounce_solid(true);
				motion_set(direction, maxspeed);
				friction = 0.1;
				alarm[0] = irandom_range(10, 15);
			}
		}
	}

	//dealing with portals and walls
	if(touched_portal == true){
		if(portal_cd < 30){
			portal_cd += 1;
		} else {
			with(instance_create(x,y,CaveSparkle)){
				image_xscale = 2;
				image_yscale = 2;
				depth = -4;
			}
			with(instance_create(x,y,CaveSparkle)){
				image_xscale = 2;
				image_yscale = 2;
				image_angle = 135;
				depth = -4;
			}
			instance_delete(self);
			exit;
		}
	}
	
	_wStuck = instance_place(x,y,Wall);
	if(instance_exists(_wStuck)){
		if(place_meeting(x,y,_wStuck)){
			wall_stuck += 1;
			if(wall_stuck >= 15){
				with(_wStuck){
					instance_create(x,y,FloorExplo);
					instance_destroy();
				}
			}
		}
	} else {
			wall_stuck = 0;
		}
	_w = instance_nearest(x, y, Wall);
	_port = instance_nearest(x,y,Portal);
	if(instance_exists(_port)){
		if(instance_place(x + hspeed*3,y + vspeed*3,_w)){
			with(_w){
				instance_create(x,y,FloorExplo);
				instance_destroy();
			}
		}

		if(point_distance(x,y,_port.x,_port.y) < 50){
			motion_add(point_direction(x,y,_port.x,_port.y), 2);
			canTarget = false;
			if(distance_to_object(_port) < 10){
				if(touched_portal = false){
					if("spoods_to_spawn" in creator){
						creator.spoods_to_spawn += 1;
					}
					array_push(creator.spooder_health, my_health);
					touched_portal = true;
				}
				sprite_angle += 35;
				sprite_index = spr_hurt;
				image_index = 2;
				depth = -4;
			} 
		} else {
			sprite_angle = 0;
			canTarget = true;
			depth = -1.9;
		}
	}

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
			motion_add(other.direction, 2);
			if(meleedamage > 0){
				other.my_health -= meleedamage;
			}
		}
	}
		
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
	if(place_meeting(x,y,TrapFire)){
		sprite_index = spr_hurt;
	}
}
else{
	instance_destroy();
}

#define spood_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, sprite_angle, c_white, 1);

#define spood_destroy
sound_play(snd_dead);
// make corpse
with(instance_create(x, y, Corpse)){
	sprite_index = sprInvSpiderDead;
	size = 1;
	direction = other.direction;
	speed = other.speed;
	friction = 0.3;
}

//splitting
if(random(100) < 25 + (75*global.debug_haHAA)){
	oldmaxhealth = spood_maxhealth;
	if(oldmaxhealth > 1){
		with(spawn_spood(2, oldmaxhealth-1)){
			creator = other.creator;
		}
	}
}

#define spood_hurt(damage, kb_vel, kb_dir)
sound_play(snd_hurt);
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
        draw_sprite_ext(sprite_index, -1, x - 1, y, 1 * right, 1, sprite_angle, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x + 1, y, 1 * right, 1, sprite_angle, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y - 1, 1 * right, 1, sprite_angle, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y + 1, 1 * right, 1, sprite_angle, playerColor, 1);
    }
}
d3d_set_fog(0,c_lime,0,0);

#define spawn_spood(number_of_spoods, spood_health)
if(abs(number_of_spoods)>0){
	repeat(number_of_spoods){
		_sp = (instance_create(x, y, CustomHitme));
		with(_sp){
			name = "CursedSpiderFriendly";
			if(object_get_name(other.object_index) == "Player"){
				creator = other;
			} else {
				creator = other.creator;
			}
			team = creator.team;
			//sprites
			spr_idle = sprInvSpiderIdle;
			spr_walk = sprInvSpiderWalk;
			spr_hurt = sprInvSpiderHurt;
			spr_dead = sprInvSpiderDead;

			sprite_index = spr_idle;
			
			// sounds
			snd_hurt = global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m[irandom_range(0,array_length_1d(global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m)-1)];
			snd_dead = global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m[irandom_range(0,array_length_1d(global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m)-1)];
			
			spood_maxhealth = spood_health;
			my_health = spood_maxhealth;
			maxspeed = 2.6;
			mask_index = mskSpider;
			size = 1;
			image_speed = 0.4;
			sprite_angle = 0; //for portal animation
			depth = -1.9;
			spr_shadow = shd24;
			direction = random(360);
			move_bounce_solid(true);
			friction = 1;
			my_damage = 3 - (global.debug_haHAA * 2);
			right = choose(-1, 1);
			alarm = [0,0];	// alarm[0] = waiting, alarm[1] = how long to move for
			target = noone;
			canTarget = true;
			touched_portal = false;
			portal_cd = 0;
			on_step = script_ref_create(spood_step);
			on_hurt = script_ref_create(spood_hurt);
			on_destroy = script_ref_create(spood_destroy);
			on_draw = script_ref_create(spood_draw);
			// friendly outline
			playerColor = player_get_color(creator.index);
			toDraw = self;
			script_bind_draw(draw_outline, depth, playerColor, toDraw);
			wall_stuck = 0;
		}
	}
} return _sp;
=======
#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACiSURBVDhPvZIxEkAwEEVzLJ3CFRiF1hE0zqDQuIzGXdzDTIjxM/FtNBvMPJPJ/v8K1lRFbjWY43EvcRiCHOePs1KwLpN1cICZx+aGnyUXDH0ngnl6gRR+A0X/EaXQGw9BW5c2RCqFpBdgsGXmhIUMchClEzAISDPH9wLggxe8eHoBVpOLuH8UGLUAARbgHr8PBSyQXyS1gIsxYqL/BOAuyO0ODw4D6C6rLowAAAAASUVORK5CYII=", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/sprPortraitRat.png",1 , 15, 185); //weird lookin spider

global.debug_haHAA = true; //for debugging. duh

global.snd_hurt_current = sndSpiderHurt;
global.snd_dead_current = sndSpiderDead;
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

global.snd_hurt_current = snd_hurt;
global.snd_dead_current = snd_dead;


//for ultra
snd_melee = sndSpiderMelee;

// stats
maxspeed_base = 2.6 + (skill_get(mut_extra_feet) * 0.5); //original wandering speed
maxspeed_close = 4.6 + (skill_get(mut_extra_feet));
maxspeed = 2.6;
team = 2;
maxhealth = 18;
spr_shadow_y = 0;

has_spawned = false;

// vars
melee = 1;	// can melee or not

spoods_to_spawn = 0;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init

#define step
// executed within each player instance of this race after step
// most actives and passives handled here

//update stats for muts
maxspeed_base = 2.6 + (skill_get(mut_extra_feet) * 0.5); //original wandering speed
maxspeed_close = 4.9 + (skill_get(mut_extra_feet));

//passive - normal movement on all terrain
friction = 0.45

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

	//sounds
	snd_hurt = global.snd_hurt_current;
	snd_dead = global.snd_dead_current;
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

with(collision_rectangle(x + 12, y + 10, x - 12, y - 10, prop, 0, 1)){

	if(sprite_index != spr_hurt){
		sprite_index = spr_hurt;
		my_health -= 6;
		sound_play(snd_hurt);
		sound_play_pitchvol(other.snd_melee, random_range(0.9, 1.1), 0.6);
		direction = other.direction;
	}
}

//speed changes
e = instance_nearest(x,y,enemy);
if(instance_exists(e)){
	if (point_distance(x,y,e.x,e.y) < 100){
		//line of sight to enemy
		if(collision_line(x,y,e.x,e.y,Wall,false, true) == noone){
			maxspeed = lerp(maxspeed, maxspeed_close, 0.25);
		}
	} else {
		maxspeed = lerp(maxspeed, maxspeed_base, 0.05);
		}
} else {
	maxspeed = lerp(maxspeed, maxspeed_base, 0.05);
}
maxspeed *= 10;
maxspeed = floor(maxspeed);
maxspeed /= 10;

//ultra A:
if(u1 == 1){
	if(my_health < 1){
		if(random(100) <= 25 + (global.debug_haHAA*75)){
			my_health = 17 - (global.debug_haHAA * 16);
			spawn_spood(1);
		}
	}
	if(sprite_index == spr_hurt and image_index == 1){
		if(random(100) <= 5 + (95*global.debug_haHAA)){
			spawn_spood(1);
			trace("spawned hit")
		}
	}
	if(canspirit = 1){
		has_spawned = false;
	} else {
		if (has_spawned = false){
			has_spawned = true;
			spawn_spood(1)
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
	case 2: return "Beacon of Lightning";
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
		global.snd_dead_current = global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m[irandom_range(0,array_length_1d(global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m)-1)];
		global.snd_hurt_current = global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m[irandom_range(0,array_length_1d(global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m)-1)];
	break;
}


#define race_ttip
// return character-specific tooltips
return choose("So smooth", "Shot web", "So shiny", "Many legs", "Many eyes");


#define spood_step
if(my_health > 0){
	// speed management
	speed = clamp(speed, 0, maxspeed);
	// collision
	move_bounce_solid(true);

	// targeting
	var _e = instance_nearest(x, y, enemy);
	var _p = instance_nearest(x, y, Player);
	if(instance_exists(_e) and distance_to_object(_e) < 100 and !collision_line(x, y, _e.x, _e.y, Wall, true, true)){
		if(target == _p or target == noone){instance_create(x,y-8,AssassinNotice)}
		maxspeed = 4.6;
		target = _e;
	} else if(instance_exists(_p) and player_get_race(_p.index) == "spider" and distance_to_object(_p) < 100 and !collision_line(x, y, _p.x, _p.y, Wall, true, true)){
		maxspeed = 4.6;
		target = _p;
	} else {
		maxspeed = 2.6;
		target = noone;
	}
	
	// movement
	if(canTarget = true){
		if(target = noone){	// no target, random movement
			if(alarm[0] = 0){
				if(random(100) < 45){
					friction = 0.2;
					direction = random(360);
					move_bounce_solid(true);
					motion_set(direction, maxspeed);
				}

				alarm[0] = irandom_range(10, 30);
			}
		}
		else{
			if(alarm[0] = 0){	// target, pursue
				direction = point_direction(x, y, target.x, target.y) + random_range(-25, 25);
				move_bounce_solid(true);
				motion_set(direction, maxspeed);
				friction = 0.1;
				alarm[0] = irandom_range(10, 15);
			}
		}
	}

	//dealing with portals and walls
	if(touched_portal == true){
		if(portal_cd < 30){
			portal_cd += 1;
		} else {
			with(instance_create(x,y,CaveSparkle)){
				image_xscale = 2;
				image_yscale = 2;
				depth = -4;
			}
			with(instance_create(x,y,CaveSparkle)){
				image_xscale = 2;
				image_yscale = 2;
				image_angle = 45;
				depth = -4;
			}
			instance_delete(self);
			exit;
		}
	}
	
	_wStuck = instance_place(x,y,Wall);
	if(instance_exists(_wStuck)){
		if(place_meeting(x,y,_wStuck)){
			wall_stuck += 1;
			if(wall_stuck >= 15){
				with(_wStuck){
					instance_create(x,y,FloorExplo);
					instance_destroy();
				}
			}
		}
	} else {
			wall_stuck = 0;
		}
	_w = instance_nearest(x, y, Wall);
	_port = instance_nearest(x,y,Portal);
	if(instance_exists(_port)){
		if(instance_place(x + hspeed*3,y + vspeed*3,_w)){
			with(_w){
				instance_create(x,y,FloorExplo);
				instance_destroy();
			}
		}

		if(point_distance(x,y,_port.x,_port.y) < 50){
			motion_add(point_direction(x,y,_port.x,_port.y), 2);
			canTarget = false;
			if(distance_to_object(_port) < 10){
				if(touched_portal = false){
					if("spoods_to_spawn" in creator){
						creator.spoods_to_spawn += 1;
					}
					touched_portal = true;
				}
				sprite_angle += 35;
				sprite_index = spr_hurt;
				image_index = 2;
				depth = -4;
			} 
		} else {
			sprite_angle = 0;
			canTarget = true;
			depth = -1.9;
		}
	}

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
			motion_add(other.direction, 2);
			if(meleedamage > 0){
				other.my_health -= meleedamage;
			}
		}
	}
		
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
	//dealing with portals and walls
	if(touched_portal == true){
		if(portal_cd < 30){
			portal_cd += 1;
		} else {
			instance_delete(self);
		}
	}
}
else{
	instance_destroy();
}

#define spood_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, sprite_angle, c_white, 1);

#define spood_destroy
sound_play(snd_dead);
// make corpse
with(instance_create(x, y, Corpse)){
	sprite_index = sprInvSpiderDead;
	size = 1;
	direction = other.direction;
	speed = other.speed;
	friction = 0.3;
}

//splitting
if(random(100) < 25 + (75*global.debug_haHAA)){
	with(spawn_spood(2)){
		creator = other.creator;
	}
}

#define spood_hurt(damage, kb_vel, kb_dir)
sound_play(snd_hurt);
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
		draw_sprite_ext(sprite_index, -1, x - 1, y, 1 * right, 1, sprite_angle, playerColor, 1);
		draw_sprite_ext(sprite_index, -1, x + 1, y, 1 * right, 1, sprite_angle, playerColor, 1);
		draw_sprite_ext(sprite_index, -1, x, y - 1, 1 * right, 1, sprite_angle, playerColor, 1);
		draw_sprite_ext(sprite_index, -1, x, y + 1, 1 * right, 1, sprite_angle, playerColor, 1);
	}
}
d3d_set_fog(0,c_lime,0,0);

#define spawn_spood(number_of_spoods)
if(abs(number_of_spoods)>0){
	repeat(number_of_spoods){
		_sp = (instance_create(x, y, CustomHitme));
		with(_sp){
			name = "CursedSpiderFriendly";
			if(object_get_name(other.object_index) == "Player"){
				creator = other;
			} else {
				creator = other.creator;
			}
			team = creator.team;
			//sprites
			spr_idle = sprInvSpiderIdle;
			spr_walk = sprInvSpiderWalk;
			spr_hurt = sprInvSpiderHurt;
			spr_dead = sprInvSpiderDead;

			sprite_index = spr_idle;
			
			// sounds
			snd_hurt = global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m[irandom_range(0,array_length_1d(global.a_wide_variety_of_hit_sounds_to_choose_f_r_o_m)-1)];
			snd_dead = global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m[irandom_range(0,array_length_1d(global.a_wide_variety_of_death_sounds_to_choose_f_r_o_m)-1)];
			
			my_health = 17;
			maxspeed = 2.6;
			mask_index = mskSpider;
			size = 1;
			image_speed = 0.4;
			sprite_angle = 0; //for portal animation
			depth = -1.9;
			spr_shadow = shd24;
			direction = random(360);
			move_bounce_solid(true);
			friction = 1;
			my_damage = 3 - (global.debug_haHAA * 2);
			right = choose(-1, 1);
			alarm = [0,0];	// alarm[0] = waiting, alarm[1] = how long to move for
			target = noone;
			canTarget = true;
			touched_portal = false;
			portal_cd = 0;
			on_step = script_ref_create(spood_step);
			on_hurt = script_ref_create(spood_hurt);
			on_destroy = script_ref_create(spood_destroy);
			on_draw = script_ref_create(spood_draw);
			// friendly outline
			playerColor = player_get_color(creator.index);
			toDraw = self;
			script_bind_draw(draw_outline, depth, playerColor, toDraw);
			wall_stuck = 0;
		}
	}
}
>>>>>>> Stashed changes
