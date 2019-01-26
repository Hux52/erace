#define init
// character select button
global.sprMenuButton = sprite_add("sprites/sprBigMaggotSelect.png", 1, 0, 0);
// character select portrait
global.sprPortrait = sprite_add("/sprites/sprPortraitBigMaggot.png", 1, 10, 230);

// character select sounds
global.sndSelect = sound_add("sounds/sndBigMaggotSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "bigmaggot"){
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
spr_idle = sprBigMaggotIdle;
spr_walk = sprBigMaggotIdle;
spr_hurt = sprBigMaggotHurt;
spr_dead = sprBigMaggotDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndBigMaggotHit;
snd_dead = sndBigMaggotDie;

// stats
maxspeed = 3;
team = 2;
maxhealth = 22;
spr_shadow = shd32;
mask_index = mskPlayer;

// vars
dig_alarm = 0;	// digging
cooldown = 0;	// cooldown til you can dig again
coords = [0, 0];	// dig destination
died = 0;	// deny extra death frames
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

// face the direction you're moving in- no gun
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

// constant movement
if(canwalk = 1){
	move_bounce_solid(true);
	motion_add(direction, maxspeed / 4);
}

// special - burrow
if(button_pressed(index, "spec")){
	if(cooldown = 0 and canspec = 1){
		// if floor inside borders...
		if!(collision_point(mouse_x[index], mouse_y[index] - 8, Wall, false, true)){
			if(collision_point(mouse_x[index], mouse_y[index] - 8, Floor, false, true)){
				// start burrowing
				spr_idle = sprBigMaggotBurrow;
				spr_walk = sprBigMaggotBurrow;
				image_index = 0;
				cooldown = -1;
				dig_alarm = 50;
				canwalk = 0;
				sound_play(sndBigMaggotBurrow);
				// log coordinates for later
				coords[0] = mouse_x[index];
				coords[1] = mouse_y[index] - 8;
			}
		}
	}
}

// digging!
if(dig_alarm > 0){
	// emerging
	if(dig_alarm = 20){
		spr_idle = sprBigMaggotAppear;
		spr_walk = sprBigMaggotAppear;
		image_index = 1;
		x = coords[0];
		y = coords[1];
		sound_play(sndBigMaggotUnburrow);
	}
	// fully out
	else if(dig_alarm = 1){
		cooldown = 30;
		canwalk = 1;
		spr_idle = sprBigMaggotIdle;
		spr_walk = sprBigMaggotIdle;
	}
	// while digging
	instance_create(x + random_range(-10, 10), y + random(5), Dust);
	nexthurt = current_frame + 1;	// invincibility
	dig_alarm--;
}

// cooldown management
if(cooldown > 0){
	cooldown--;
}

// outgoing contact damage
if(collision_rectangle(x + 20, y + 10, x - 20, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= 1;
			sound_play(snd_hurt);
			sound_play(sndBigMaggotBite);
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
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
	// spawn maggots
	repeat(5){
		with(instance_create(x, y, CustomHitme)){
			name = "Maggot";
			creator = other;
			team = creator.team;
			spr_idle = sprMaggotIdle;
			spr_walk = sprMaggotIdle;
			spr_hurt = sprMaggotHurt;
			spr_dead = sprMaggotDead;
			sprite_index = spr_idle;
			my_health = 2;
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
			toDraw = self;
			script_bind_draw(draw_outline, depth, playerColor, toDraw);
		}
	}
	died = 1;
	// become small maggot
	race = "maggot";
	my_health = 2;
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
			alarm[i]--;
		}
	}
	
	// outgoing/incoming contact damage
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		with(instance_nearest(x, y, enemy)){
			if(sprite_index != spr_hurt){
				my_health -= 1;
				sound_play(snd_hurt);
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
	sprite_index = sprMaggotDead;
	size = 1;
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
return "BIG MAGGOT";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#CAN'T STAND STILL#@sCAN @yBURROW";


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
return choose("BURROW", "BABY ON BOARD", "SEXTUPLETS", "LOVE THE SAND", "FAMILY");

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