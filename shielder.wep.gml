#define init

#define game_start

#define step

#define weapon_name
return "SHIELDER RIFLE";

#define weapon_sprt
return sprPopoHeavyGun;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 40;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return "MANY SHOTS";

#define weapon_fire
// create burst distance from gun
var _x = x + lengthdir_x(7, gunangle);
var _y = y + lengthdir_y(7, gunangle);
with instance_create(_x, _y, CustomObject){
	name = "shielderBurst";
	creator = other;
	team = creator.team;
	mask_index = mskNone;
	spr_shadow = mskNone;
	direction = other.gunangle + (random(other.accuracy) * choose(1, -1));
	friction = 0;
	on_step = script_ref_create(shielderBurst_step);
	on_destroy = script_ref_create(shielderBurst_destroy);
	alarm = [24];
}

#define shielderBurst_step
if(instance_exists(creator)){
	creator.speed = 0;
	creator.canwalk = 0;
	direction = creator.gunangle + (10 * random(creator.accuracy) * choose(1, -1));
	// follow player
	x = creator.x + lengthdir_x(7, creator.gunangle);
	y = creator.y + lengthdir_y(7, creator.gunangle);
	// fire bullets
	if(alarm[0] % 3 = 0){	// 8 bullets
		sound_play_gun(sndGruntFire, 0.2, 0.6);
		with(creator){
			weapon_post(5, 30, 10);	// weapon kick and screen shake
		}
		with(instance_create(x, y, Bullet1)){
			sprite_index = sprIDPDBullet;
			spr_dead = sprIDPDBulletHit;
			creator = other.creator;
			team = creator.team;
			direction = other.direction;
			image_angle = direction;
			friction = 0;
			speed = 8;
			damage = 3;
		}
	}
	for(i = 0; i < array_length(alarm); i++){
		alarm[i]--;
	}
	if(alarm[0] <= 0){
		instance_destroy();
	}
}
else{
	instance_destroy();
}

#define shielderBurst_destroy
if(instance_exists(creator)){
	with(creator){
		canwalk = true;
	}
}