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
return true;

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
if(fork()){
	var ammo = 8;
	while instance_exists(self){
		if instance_exists(GenCont) || instance_exists(menubutton) exit;
		if ammo <= 0 exit;
		if (button_check(index,"spec")){
			exit;			
		}
		if !button_check(index,"fire") && ammo <= 3{
			if wep = mod_current reload = 8;
			exit;
		}
		with(instance_create(x, y, Bullet1)){
			sprite_index = sprIDPDBullet;
			spr_dead = sprIDPDBulletHit;
			creator = other;
			team = creator.team;
			direction = creator.gunangle + random_range(-10,10);
			image_angle = direction;
			friction = 0;
			speed = 8;
			damage = 3;
		}
		sound_play_gun(sndGruntFire, 0.2, 0.6);
		weapon_post(5, 30, 10);
		ammo --;
		var num = 3;
		if skill_get(mut_stress) num = 1 + (2 * (my_health/maxhealth));
		wait num;
	}
	exit;
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
		alarm[i]-= current_time_scale;
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