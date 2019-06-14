#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprExploGuardianSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("/sprites/portrait/sprPortraitExploGuardian.png", 1, 10, 205);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_ExploGuardian.png", 1, 10, 10);

// character select sounds
global.sndSelect = sndExploGuardianCharge;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "exploguardian"){
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
spr_idle = sprExploGuardianIdle;
spr_walk = sprExploGuardianWalk;
spr_hurt = sprExploGuardianHurt;
spr_dead = sprExploGuardianDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndExploGuardianHurt;
snd_dead = sndExploGuardianDead;
snd_chrg = sndExploGuardianCharge;
snd_fire = sndExploGuardianFire;
snd_cgdd = sndExploGuardianDeadCharge;

// stats
maxspeed = 4;
team = 2;
maxhealth = 50;
spr_shadow = shd32;
spr_shadow_y = 5;
mask_index = mskPlayer;
canwalk = 1;

// vars
melee = 0;	// can melee or not
cooldown = 0;
cooldown_base = 15;
explo_timer = 0;
explo_timer_base = 60;
can_explo = true;
has_exploded = true;
is_exploding = false;
died = 0;
fireAngle_base = 135;
fireAngle = fireAngle_base;
ang = 0;
bullets = 0;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

bullets_max = 14 + (GameCont.level*2);
charge_factor = explo_timer_base/bullets_max;

// no weps
canswap = 0;
canpick = 0;
if(wep != 0){
	wep = 0;
}

footstep = 10;

//passive: is floaty
friction = 0.3;

// face direction you're moving in, as you have no weps
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

// outgoing contact damage
if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			projectile_hit_push(self, 2, 4);
		}
	}
}

//purist
//on click
// if(button_pressed(index, "fire")){
// 	if(can_explo = true){
// 		if(is_exploding = false){
// 			is_exploding = true;
// 			has_exploded = false;
// 			canwalk = 0;
// 			explo_timer = explo_timer_base;
// 			sound_play_pitch(snd_chrg, 1 + random_range(-0.1, 0.1));
// 			spr_idle = sprExploGuardianCharge;
// 			spr_walk = sprExploGuardianCharge;
// 			spr_hurt = sprExploGuardianChargeHurt;
// 			sprite_index = spr_idle;
// 			speed = 0;
// 		}
// 	}
// }


if(can_explo = true){
	is_exploding = button_check(index, "spec");
}

if(button_pressed(index,"spec")){
	pdir = point_direction(x,y, mouse_x[index], mouse_y[index]);
}

if(is_exploding){
	if(explo_timer == 0){
		chargesound = sound_play_pitch(snd_chrg, 1 + random_range(-0.1, 0.1));
	}
	has_exploded = false;
	canwalk = 0;
	explo_timer += current_time_scale;
	spr_idle = sprExploGuardianCharge;
	spr_walk = sprExploGuardianCharge;
	spr_hurt = sprExploGuardianChargeHurt;
	sprite_index = spr_idle;
	speed = 0;
	fireAngle = lerp(fireAngle, 15, 0.05 * current_time_scale);

	bullets = floor(explo_timer/charge_factor);
	
	//ang -= angle_difference(ang, 360/bullets) * 0.99 * current_time_scale;
	ang = 360/bullets;

	pdir -= angle_difference(pdir, point_direction(x,y,mouse_x[index],mouse_y[index])) * 0.5 * current_time_scale;
}

if(explo_timer >= 60 || button_released(index,"spec")){
	if(has_exploded = false){
		var _o = random(360);
		sound_play_pitch(snd_fire, 1 + random_range(-0.1, 0.1));
		sound_stop(chargesound);

		for(i = 0; i < bullets; i++){
			with(instance_create(x, y, EnemyBullet2)){
				creator = other;
				team = creator.team;
				sprite_index = sprExploGuardianBullet;
				mask_index = mskBullet2;
				speed = 12;
				direction = other.pdir + other.ang * other.i;
				image_angle = direction;
				damage = 3;	// damage is normally 2 for exploguardian, this is player bullet damage
			}
		}
		

		for (i = -2; i < 3; i++) { 
			with(instance_create(x, y, EnemyBullet2)){
					creator = other;
					team = creator.team;
					sprite_index = sprExploGuardianBullet;
					mask_index = mskBullet2;
					speed = 18;
					direction = other.pdir + ((other.fireAngle/5) * other.i);
					image_angle = direction;
					damage = 3;	// damage is normally 2 for exploguardian, this is player bullet damage
				}
		}
		spr_idle = sprExploGuardianIdle;
		spr_walk = sprExploGuardianWalk;
		spr_hurt = sprExploGuardianHurt;
		sprite_index = spr_idle;
		canwalk = 1;
		explo_timer = 0;
		cooldown = cooldown_base;
		has_exploded = true;
		is_exploding = false;
		fireAngle = fireAngle_base;
	}
}

if(distance_to_object(Portal) < 20){
	spr_idle = sprExploGuardianIdle;
	spr_walk = sprExploGuardianWalk;
	spr_hurt = sprExploGuardianHurt;
	sprite_index = spr_idle;
	canwalk = 1;
}

if(my_health <= 0){
	if(died = 0 and is_exploding == true){
		sound_dead = snd_cgdd;
		for(i = 0; i < bullets; i++){
			with(instance_create(x, y, EnemyBullet2)){
				creator = other;
				team = creator.team;
				sprite_index = sprExploGuardianBullet;
				mask_index = mskBullet2;
				speed = 4;
				direction = other.pdir + other.ang * other.i;
				image_angle = direction;
				damage = 3;	// damage is normally 2 for exploguardian, this is player bullet damage
			}
		}
		died = 1;
	}
} else {
	died = 0;
}

if (cooldown >= 0 and is_exploding == false){
	can_explo = false;
	cooldown -= current_time_scale;
} else {
	can_explo = true;
}

#define draw
r = 40;
num = 32;
a = draw_get_alpha();
//draw_triangle_color(x - 15, y - 10, x - 15 + ((fire_remaining/fire_max)*30), y - 10, x - 15 + ((fire_remaining/fire_max)*30), y - 10 - ((fire_remaining/fire_max)*5),c_red,c_orange,c_yellow, false);
if(is_exploding){
	draw_primitive_begin(pr_trianglestrip);
	draw_set_color(c_lime);

	for(i = (num/2) * -1; i <= num/2; i += 1){
			draw_set_alpha(1);
			draw_vertex(x + lengthdir_x(r, pdir + fireAngle * (i/num)), y + lengthdir_y(r, pdir + fireAngle * (i/num)));
			draw_set_alpha(0.9);
			
			draw_vertex(x + lengthdir_x(r - 3, pdir + fireAngle * (i/num)), y + lengthdir_y(r - 3, pdir + fireAngle * (i/num)));
	}
	draw_primitive_end();

	draw_primitive_begin(pr_linelist);
	draw_set_color(c_lime);
	for(i = 0; i < bullets; i++){
			draw_set_alpha(1);
			draw_set_color(c_lime);
			draw_vertex(x + lengthdir_x(r/2, pdir + ang*i), y + lengthdir_y(r/2, pdir + ang*i));
			
			draw_set_color(merge_color(c_lime, c_white, 0.5));
			draw_vertex(x + lengthdir_x(r*0.66, pdir + ang*i), y + lengthdir_y(r*0.66, pdir + ang*i));
	}
	draw_primitive_end();
}
draw_set_alpha(a);

#define race_name
// return race name for character select and various menus
return "EXPLOGUARDIAN";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#@sCHARGE @gBURST";


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
return choose("RADICAL");