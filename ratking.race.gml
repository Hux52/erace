#define init
// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

// charselect sprite
global.sprMenuButton = sprite_add("sprites/selectIcon/sprRatKingSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitRatKing.png",1,24,200);

global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_BigGreenRat.png", 1, 10, 10);

// character select sounds
global.sndSelect = sound_add("sounds/sndRatKingSelect2.ogg");	// not sure
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "ratking"){
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
spr_idle = sprRatkingIdle;
spr_walk = sprRatkingWalk;
spr_hurt = sprRatkingHurt;
spr_dead = sprRatkingDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndRatKingHit;
snd_dead = sndRatKingDie;

// stats
maxspeed = 3;
team = 2;
maxhealth = 35;
spr_shadow_y = 5;
spr_shadow = shd64;
mask_index = mskPlayer;

// vars
spawn_cool = 0;	// spawn cooldown
charge_cool = 0;	// charge cooldown
died = 0;	// prevent frames after death
melee = 1;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

spr_shadow_x = 4*right;
if(charge_cool > 0){
	// sprite faces direction when charging
	if(direction > 90 and direction <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
}

// special- exchange rats for health
if(button_pressed(index, "fire")){
	if(canspec = 1){
		if(spawn_cool = 0 and charge_cool = 0 and my_health > 6){
			sound_play(sndRatKingVomit);
			spawn_cool = 90;
			my_health -= 6;
		}
	}
}

if(spawn_cool > 0){
	if(spawn_cool > 60){
		// burst spawn of rats
		if(spawn_cool = 90 or spawn_cool = 85 or spawn_cool = 80 or spawn_cool = 75){
			with(instance_create(x, y, CustomHitme)){
				name = "Fastrat";
				creator = other;
				team = creator.team;
				spr_idle = sprFastRatIdle;
				spr_walk = sprFastRatWalk;
				spr_hurt = sprFastRatHurt;
				spr_dead = sprFastRatDead;
				snd_hurt = sndFastRatHit;
				snd_dead = sndFastRatDie;
				sprite_index = spr_idle;
				my_health = 7;
				maxspeed = 4;
				mask_index = mskMaggot;
				size = 1;
				image_speed = 0.3;
				spr_shadow = shd24;
				direction = random(360);
				move_bounce_solid(true);
				my_damage = 2;
				right = choose(-1, 1);
				alarm = [0, 900];	// movement and age
				on_step = script_ref_create(fastrat_step);
				on_hurt = script_ref_create(fastrat_hurt);
				on_destroy = script_ref_create(fastrat_destroy);
				// friendly outline
				playerColor = player_get_color(creator.index);
				with(script_bind_draw(0, 0)){
					script = script_ref_create_ext("mod", "erace", "draw_outline", other.playerColor, other);
				}
			}
		}
		// no control while spawning
		canwalk = 0;
		move_bounce_solid(true);
		move_towards_point(x + lengthdir_x(maxspeed - 2, direction), y + lengthdir_y(maxspeed - 2, direction), maxspeed - 2);
		spr_idle = sprRatkingFire;
		spr_walk = sprRatkingFire;
	}
	else if(spawn_cool = 60){
		// back to normal
		canwalk = 1;
		spr_idle = sprRatkingIdle;
		spr_walk = sprRatkingWalk;
	}
	spawn_cool-= current_time_scale;	// cooldown
}

// special b- self destruct charge
if(button_pressed(index, "spec") and spawn_cool <= 60 and charge_cool = 0){
	sound_play(sndRatkingCharge);
	charge_cool = 90;
}

// if charging
if(charge_cool > 0){
	canwalk = 0;	// lose control
	charge_cool-= current_time_scale;
	spr_walk = sprRatkingRageAttack;
	spr_idle = sprRatkingRageAttack;
	move_towards_point(x + lengthdir_x((maxspeed + 3) * current_time_scale, direction), y + lengthdir_y((maxspeed + 3) * current_time_scale, direction), (maxspeed + 3) * current_time_scale);
	// destroy walls
	var _w = instance_nearest(x, y, Wall);
	if(instance_exists(_w)){
		if(distance_to_object(_w) < 20){
			with(_w){
				instance_create(x, y, FloorExplo);
				instance_destroy();
			}
		}
	}
	// change charge directions
	if((charge_cool % 30) = 0 and charge_cool != 90 and canwalk = 0){
		sound_play(sndRatkingCharge);
		direction = gunangle;
	}
}

// death on charge end
if(charge_cool = 1){
	charge_cool = -1;
	sound_play(snd_dead);
	my_health = 0;
}

// outgoing contact damage
if(collision_rectangle(x + 15, y + 15, x - 15, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= 1;
			// increased damage on rage charge
			if(other.charge_cool > 0){
				my_health -= 3;
			}
			sound_play(snd_hurt);
			sprite_index = spr_hurt;
		}
	}
}

// on death
if(my_health = 0 and died = 0){
	for(i = 0; i < 360; i += 72){
		with(instance_create(x, y, AcidStreak)){
			speed = 8;
			direction = other.i + random_range(-30, 30);
		}
	}
	// if died from rage...
	if(charge_cool = -1){
		// destroy nearby walls
		with(Wall){
			if(distance_to_object(other) < 100){
				instance_create(x, y, FloorExplo);
				instance_destroy();
			}
		}
		// spawn rats
		repeat(4){
			with(instance_create(x, y, CustomHitme)){
				name = "Fastrat";
				creator = other;
				team = creator.team;
				spr_idle = sprFastRatIdle;
				spr_walk = sprFastRatWalk;
				spr_hurt = sprFastRatHurt;
				spr_dead = sprFastRatDead;
				snd_hurt = sndFastRatHit;
				snd_dead = sndFastRatDie;
				sprite_index = spr_idle;
				my_health = 7;
				maxspeed = 4;
				mask_index = mskMaggot;
				size = 1;
				image_speed = 0.3;
				spr_shadow = shd24;
				direction = random(360);
				move_bounce_solid(true);
				my_damage = 2;
				right = choose(-1, 1);
				alarm = [0, 900];	// movement and age
				on_step = script_ref_create(fastrat_step);
				on_hurt = script_ref_create(fastrat_hurt);
				on_destroy = script_ref_create(fastrat_destroy);
				// friendly outline
				playerColor = player_get_color(creator.index);
				with(script_bind_draw(0, 0)){
					script = script_ref_create_ext("mod", "erace", "draw_outline", other.playerColor, other);
				}
			}
		}
		// become a fast rat
		race = "fastrat";
		my_health = 7;
	}
	died = 1;
}


#define fastrat_step
if(my_health > 0){
	// speed management
	if(speed > maxspeed){
		speed = maxspeed;
	}

	// age management
	alarm[1]-= current_time_scale;

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
	if(target = noone){	// no target, wander
		if(alarm[0] = 0){
			direction = random(360);
			move_bounce_solid(true);
			if(random(10) > 2){
				motion_add(direction, maxspeed);
			}
			else{
				motion_add(direction, 0);
			}
			alarm[0] = irandom_range(20, 90);
		}
	}
	else{
		if(alarm[0] = 0){	// target, persue
			direction = point_direction(x, y, target.x, target.y) + random_range(-20, 20);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			alarm[0] = irandom_range(40, 80);
		}
	}

	// OLD WALL DEBUG
	/*var _w = instance_nearest(x, y, Wall);
	if(collision_rectangle(_w.x, _w.y + 15, _w.x + 15, _w.y, self, false, false)){
		//trace("hit wall");		// debug
		var _f = instance_nearest(x, y, Floor);
		x = _f.x + 8;
		y = _f.y + 8;
	}*/

	// stop hurt sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	// alarm management
	for(i = 0; i < array_length_1d(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]-= current_time_scale;
		}
	}
	
	// incoming/outgoing contact damage
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		with(instance_nearest(x, y, enemy)){
			if(sprite_index != spr_hurt){
				my_health -= 2;
				sound_play(snd_hurt);
				sound_play(sndFastRatMelee);
				sprite_index = spr_hurt;
			}
		}
	}
	
	// death from aging
	if(alarm[1] <= 0){
		my_health = 0;
	}
}
else{
	instance_destroy();
}

#define fastrat_destroy
// effects
with(instance_create(x, y, AcidStreak)){
	speed = 8;
	direction = other.direction;
}
sound_play(sndFastRatDie);

// corpse
with(instance_create(x, y, Corpse)){
	sprite_index = sprFastRatDead;
	size = 1;
}

#define fastrat_hurt(damage, kb_vel, kb_dir)
// incoming damage
if(sprite_index != spr_hurt){
	sound_play(sndFastRatHit);
	my_health -= argument0;
	motion_add(argument2, argument1);
	nexthurt = 3;
	sprite_index = spr_hurt;
}


#define race_name
// return race name for character select and various menus
return "RAT KING";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#SPAWN @gRATS";


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
return choose("WHISKERS", "RABID", "ITCHY", "RODENT");
