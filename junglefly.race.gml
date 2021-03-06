#define init
// character select button
global.sprMenuButton = sprite_add("sprites/selectIcon/sprJungleFlySelect.png", 1, 0, 0);
// character select portrait
global.sprPortrait = sprite_add("/sprites/portrait/sprPortraitJungleFly.png", 1, 25, 225);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_GiantFly.png", 1, 10, 10);

// character select sounds
global.sndSelect = sound_add("sounds/sndFlySelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
 	//character selection sound
 	for(var i = 0; i < maxp; i++){
 		var r = player_get_race(i);
 		if(_race[i] != r && r = "junglefly"){
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
spr_idle = sprJungleFlyIdle;
spr_walk = sprJungleFlyWalk;
spr_hurt = sprJungleFlyHurt;
spr_dead = sprJungleFlyDead;
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndFlyHurt;
snd_dead = sndFlyDead;
snd_fire = sndFlyFire;
snd_melee = sndFlyMelee;

// stats
maxspeed = 3.6;
team = 2;
maxhealth = 40;
melee = 0;	// can melee or not
spr_shadow = shd48;
spr_shadow_y = 4;

canfire = true;
firing = false;
fireDelay = 2;
fireDelayBase = 2;
maggot_count_base = 6;
maggot_count = maggot_count_base;
cooldown_base = 30;
cooldown = cooldown_base;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

//passive: can fly over terrain
friction = 0.45;
footstep = 10;

// no weps
canswap = 0;
canpick = 0;

d = point_direction(x,y,mouse_x[index],mouse_y[index]);

// outgoing contact damage
with(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	_p = other;
	if(sprite_index != spr_hurt){
		projectile_hit_push(self, 5, 4);
		sound_play_pitchvol(other.snd_melee, random_range(0.9, 1.1), 0.6);
	}
}

if(button_pressed(index,"fire") && canfire){
	firing = true;
	with(instances_matching(CustomHitme, "creator", self)){
		instance_destroy();
	}
}

if(firing){
	cooldown = cooldown_base;
	if(maggot_count > 0){
		if(fireDelay <= 0){
			//maggot
			sound_play_pitchvol(snd_fire, random_range(0.9,1.1), 0.6);
				with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), CustomProjectile){
					name = "junglefly_maggot";
					sprite_index = sprFiredMaggot;
					creator = other;
					p = other;
					team = p.team;
					damage = 3;
					force = 2;
					direction = creator.d + random_range(-15,15);
					image_angle = direction;
					friction = 0;
					speed = 10;
					on_hit = script_ref_create(proj_hit);
					on_wall = script_ref_create(proj_wall);
				}
			maggot_count -= 1;
			fireDelay = fireDelayBase;
			view_shake[index] = 4;
		}
		fireDelay -= current_time_scale;
	} else {
		firing = false; //stop firing
	}
}

if(cooldown >= 0){
	canfire = false;
	cooldown -= current_time_scale;
} else {
	canfire = true;
	maggot_count = maggot_count_base;
}

#define proj_hit
SpawnMaggot(2, "normal");
other.my_health -= damage;
instance_destroy();

#define proj_wall
SpawnMaggot(2, "normal");
instance_destroy();

#define maggot_step
if(my_health > 0){
	// speed management
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	// collision stuff
	move_bounce_solid(true);
	
	// sprite stuff
	if(speed > 0 and sprite_index != spr_hurt){
		sprite_index = spr_walk;
	}
	else if(sprite_index != spr_hurt){
		sprite_index = spr_idle;
	}
	// face direction...
	if(right = 1){
		image_xscale = 1;
	}
	else{
		image_xscale = -1;
	}
	// ...cont
	if(direction > 90 and direction <= 270){
		right = -1;
	}
	else{
		right = 1;
	}


	// targeting
	if(instance_exists(enemy)){
		var _e = instance_nearest(x, y, enemy);
		if(distance_to_object(_e) < 100 and !collision_line(x, y, _e.x, _e.y, Wall, true, true)){
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
	if(target = noone){	// no target- random movement
		if(alarm[0] <= 0){
			direction = random(360);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			alarm[0] = irandom_range(20, 40);
		}
	}
	else{
		if(alarm[0] <= 0){	// target- go for it!
			direction = point_direction(x, y, target.x, target.y) + random_range(-20, 20);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			alarm[0] = irandom_range(30, 50);
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

	// stop showing hurt sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	
	// outgoing/incoming contact damage
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		with(instance_nearest(x, y, enemy)){
			if(sprite_index != spr_hurt){
				my_health -= 1;
				sound_play_hit(snd_hurt, 0.1);
				sprite_index = spr_hurt;
			}
		}
	}
}
else{
	instance_destroy();
}

#define maggot_destroy
sound_play_pitchvol(snd_dead, random_range(0.9,1.1), 0.6);
// create corpse
with(instance_create(x, y, CustomObject)){
	name = "MaggotCorpse";
	sprite_index = sprMaggotDead;
	image_speed = 0.6;
	//	image_index = 4;
	speed = 0;
	dir = choose(-1, 1);
	alarm = 45 + irandom(10);
	on_step = script_ref_create(MaggotCorpse_step);
	//	image_xscale = 0.8;
	//	image_yscale = 0.8;
	//	image_angle = random(360);
}
//create explosion
if(type == "meat"){
	repeat(3) {
		instance_create(x,y,MeatExplosion);
		with(instance_create(x,y,BloodStreak)){
			image_angle = random(360);
			speed = 8;
		}
	}
}

#define MaggotCorpse_step
if(image_index > 5 and image_speed != 0){
	image_speed = 0;
}
alarm -= current_time_scale;
if(alarm > 0 and alarm < 45){
	image_alpha = alarm / 45;
	image_xscale = alarm / 45;
	image_yscale = image_xscale;
	image_angle += 25 * dir;
}
else if(alarm <= 0){
	instance_destroy();
}

#define maggot_hurt(damage, kb_vel, kb_dir)
// incoming damage
if(sprite_index != spr_hurt){
	if(nexthurt <= current_frame){
		sound_play_pitchvol(snd_hurt,1,0.6);
		my_health -= argument0;
		motion_add(argument2, argument1);
		nexthurt = current_frame + 3;
		sprite_index = spr_hurt;
	}
}

#define SpawnMaggot(hp, t) //t - type
	with(instance_create(x, y, CustomHitme)){
		name = "Maggot";
		creator = other.p;
		team = creator.team;
		spr_idle = sprMaggotIdle;
		spr_walk = sprMaggotIdle;
		spr_hurt = sprMaggotHurt;
		spr_dead = sprMaggotDead;

		type = t;
		// sounds
		snd_hurt = sndHitFlesh;
		snd_dead = sndEnemyDie;
		sprite_index = spr_idle;
		maxhealth = hp;
		my_health = maxhealth;//2 + (skill_get(mut_rhino_skin) * 4);
		maxspeed = 2;
		mask_index = mskMaggot;
		size = 1;
		image_speed = 0.3;
		spr_shadow = shd16;
		direction = random(360);
		move_bounce_solid(true);
		my_damage = 1;
		right = choose(-1, 1);
		alarm = [0];	// walking/targeting alarm
		on_step = script_ref_create(maggot_step);
		on_hurt = script_ref_create(maggot_hurt);
		on_destroy = script_ref_create(maggot_destroy);
		// outline for friendly distinction
		playerColor = player_get_color(creator.index);
		wall_stuck = 0;
		with(script_bind_draw(0, 0)){
			script = script_ref_create_ext("mod", "erace", "draw_outline", other.playerColor, other);
		}
		switch(type){
			case "normal":
				image_blend = c_white;
			break;
			case "meat":
				image_blend = make_color_hsv(0,169,200);
			break;
		}
	}

#define race_name
// return race name for character select and various menus
return "JUNGLEFLY";


#define race_text
// return passive and active for character selection screen
return "@sCAN @wFLY#@sFIRES @wMAGGOTS";


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
return choose("BUZZ BUZZ", "FLY YOU FOOL", "SIX SHOTS# MORE THAN ENOUGH #TO KILL ANYTHING THAT MOVES");