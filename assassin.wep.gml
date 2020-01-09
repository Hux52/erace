#define init
global.alt = false;

#define game_start

#define step
if ("weapon_custom_delay" not in self){
	weapon_custom_delay = 0;
}
if(weapon_custom_delay >= 0){
	weapon_custom_delay-= current_time_scale;
	// no moving
	firing = true;
	speed = 0;
} else {
	firing = false;
}
if(weapon_custom_delay = 0){
	// swing
	weapon_post(3, 20, 5);	// weapon kick and screen shake
	sound_play(sndAssassinAttack);
	if(ultra_get("assassin", 1)){
		if(global.alt = true){
			with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), EnergySlash)){
				creator = other;
				team = creator.team;
				direction = creator.gunangle;
				image_angle = direction;
				friction = 0;
				damage = 15;
			}
		}
		else{
			with(instance_create(x + lengthdir_x(6, gunangle), y + lengthdir_y(6, gunangle), LightningSlash)){
				creator = other;
				team = creator.team;
				direction = creator.gunangle;
				image_angle = direction;
				friction = 0;
				damage = 10;
			}
		}
	}
	else{
		with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), Slash)){
			creator = other;
			team = creator.team;
			direction = creator.gunangle;
			image_angle = direction;
			friction = 0;
			damage = 5;
		}
	}
	
	if(global.alt = true){
		global.alt = false;
	}
	else{
		global.alt = true;
	}
	
	if(wepangle = 120){
		wepangle = 235;
	}
	else{
		wepangle = 120;
	}
	
}
#define weapon_name
return "PIPE";

#define weapon_sprt
return sprPipe;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 20;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapHammer;

#define weapon_melee
return true;

#define weapon_laser_sight
return false;

#define weapon_text
return "YOU ARE ALREADY DEAD";

#define weapon_fire
// effect
instance_create(x, y - 8, AssassinNotice);
weapon_custom_delay = 5;
