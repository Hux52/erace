#define init
global.sprMenuButton = sprite_add("sprites/sprMaggotSpawnSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/sprPortraitMaggotSpawn.png",1 , 0, 190);

// level start init- MUST GO AT END OF INIT
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;
global.sndSelect = sound_add("sounds/sndMaggotSpawnSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "maggotspawn"){
			sound_play(global.sndSelect);
		}
		_race[i] = r;
	}
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

#define level_start

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprMSpawnIdle;
spr_walk = sprMSpawnIdle;
spr_hurt = sprMSpawnHurt;
spr_dead = sprMSpawnDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_dead = sndMaggotSpawnDie;

// stats
maxspeed = 0;
team = 2;
maxhealth = 12;
spr_shadow = shd32;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
self_destruct = -1;	// self destruction alarm init
died = 0;	// prevent frames after death
melee = 0;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps, no movement
canswap = 0;
canpick = 0;
canwalk = 0;

// max health fix
if(maxhealth != 12 + skill_get(mut_rhino_skin) * 4){
	maxhealth = 12 + skill_get(mut_rhino_skin) * 4;
}

// face direction you're "moving" as you have no weps
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

// special- self destruct init
if(button_pressed(index, "spec") or button_pressed(index, "fire")){
	if(self_destruct = -1){
		spr_idle = sprMSpawnChrg;
		spr_walk = sprMSpawnIdle;
		self_destruct = 30;	// init self destruct
	}
}

// alarm management
if(self_destruct > 0){
	self_destruct-= current_time_scale;
}
else if(self_destruct != -1){
	my_health = 0;
}

// on death
if(my_health = 0 and died = 0){
	// effects
	repeat(3){
		instance_create(x, y, MeatExplosion);
	}
	for(i = 0; i < 360; i += 120){
		with(instance_create(x, y, BloodStreak)){
			speed = 8;
			direction = other.i + random_range(-30, 30);
		}
	}
	// maggot spawn
	repeat(5 + max(0, GameCont.hard)){
		with(instance_create(x, y, CustomHitme)){
			name = "Maggot";
			creator = other;
			team = creator.team;
			if!(ultra_get(mod_current, 1)){
				spr_idle = sprMaggotIdle;
				spr_walk = sprMaggotIdle;
				spr_hurt = sprMaggotHurt;
				spr_dead = sprMaggotDead;
				my_health = 2;
				maxspeed = 2;
			}
			else{
				spr_idle = sprRadMaggot;
				spr_walk = sprRadMaggot;
				spr_hurt = sprRadMaggotHurt;
				spr_dead = sprRadMaggotDead;
				my_health = 3;
				maxspeed = 3;
			}
			sprite_index = spr_idle;
			mask_index = mskMaggot;
			size = 1;
			image_speed = 0.3;
			spr_shadow = shd16;
			direction = random(360);
			move_bounce_solid(true);
			my_damage = 1;
			right = choose(-1, 1);
			alarm = [0];	// movement alarm
			on_step = script_ref_create(maggot_step);
			on_hurt = script_ref_create(maggot_hurt);
			on_destroy = script_ref_create(maggot_destroy);
			// friendly player outline
			playerColor = player_get_color(creator.index);
			toDraw = self;
			on_draw = script_ref_create(outline_draw);
		}
	}
	// become maggot
	died = 1;
	if!(ultra_get(mod_current, 1)){
		race = "maggot";
		wantrace = "maggotspawn";
	}
	else{
		race = "radmaggot";
		wantrace = "maggotspawn";
	}
	maxhealth = 2 + max(0, floor(GameCont.hard / 2));	// get +1 max hp every 2 levels
	my_health = maxhealth;
}

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
	if(direction > 90 and direction <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
	// ...cont
	if(right = 1){
		image_xscale = 1;
	}
	else{
		image_xscale = -1;
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
		if(alarm[0] = 0){
			direction = random(360);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			alarm[0] = irandom_range(20, 40);
		}
	}
	else{
		if(alarm[0] = 0){	// target- go for it!
			direction = point_direction(x, y, target.x, target.y) + random_range(-20, 20);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			alarm[0] = irandom_range(30, 50);
		}
	}


	var _w = instance_nearest(x, y, Wall);
	// OLD WALL COLLISION DEBUG
	/*if(collision_rectangle(_w.x, _w.y + 15, _w.x + 15, _w.y, self, false, false)){
		//trace("hit wall");		// debug
		var _f = instance_nearest(x, y, Floor);
		x = _f.x + 8;
		y = _f.y + 8;
	}*/

	// stop showing hurt sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	// alarm management
	for(i = 0; i < array_length_1d(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]-= current_time_scale;
		}
	}
	
	// outgoing/incoming contact damage
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		with(instance_nearest(x, y, enemy)){
			if(sprite_index != spr_hurt){
				my_health -= 1;
				if(other.name = "radmaggot"){
					my_health -= 2;
				}
				sound_play_pitch(snd_hurt, random_range(0.9, 1.1));
				sprite_index = spr_hurt;
			}
		}
	}
}
else{
	instance_destroy();
}

#define maggot_destroy
// create corpse
with(instance_create(x, y, Corpse)){
	sprite_index = other.spr_dead;
	size = 1;
}

// ultra
if(ultra_get(mod_current, 1)){
	with(instance_create(x, y, HorrorBullet)){
		damage = 8;
		direction = random(360);
		image_angle = direction;
		speed = 8;
	}
}

#define maggot_hurt(damage, kb_vel, kb_dir)
// incoming damage
if(sprite_index != spr_hurt){
	my_health -= argument0;
	motion_add(argument2, argument1);
	nexthurt = 3;
	sprite_index = spr_hurt;
}


#define race_name
// return race name for character select and various menus
return "CORPSE";


#define race_text
// return passive and active for character selection screen
return "CAN'T MOVE#@rSELF DESCTRUCT";


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
	case 1: return "IRRADIATED";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "SPAWN @gRAD MAGGOTS @wTHAT FIRE @gRADS";
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
return choose("HUNGRY", "WRIGGLE", "FAMILY", "LET'S GET SOME GRUB      @r@qL@qO@qO@qO@qO@qO@qO@qO@qO@qO@qO@qO@qO");

#define outline_draw
if(instance_exists(creator)){
	playerColor = player_get_color(creator.index);
} 
d3d_set_fog(1,playerColor,0,0);
if(instance_exists(toDraw)){
    with(toDraw){
		if(instance_exists(creator)){
			playerColor = player_get_color(creator.index);
		}
        draw_sprite_ext(sprite_index, -1, x - 1, y, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x + 1, y, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y - 1, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y + 1, 1 * right, 1, 0, playerColor, 1);
    }
}
d3d_set_fog(0,c_lime,0,0);
draw_self();