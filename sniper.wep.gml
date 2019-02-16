#define init
firing = false;

#define game_start

#define step
if ("weapon_custom_delay" not in self){
	weapon_custom_delay = 0;
}
if(weapon_custom_delay >= 0){
	weapon_custom_delay-= current_time_scale;
	// no moving
	canwalk = false;
	firing = true;
}
if(weapon_custom_delay = 0){
	// can walk again
	firing = false;
	canwalk = 1;
	weapon_post(5, 20, 5);	// weapon kick and screen shake
	sound_play(sndSniperFire);
	for (i = 0; i < 3; i++){
		with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), Bullet1)){
			creator = other;
			team = creator.team;
			direction = creator.gunangle - 3 + (3*creator.i);
			image_angle = direction;
			speed = 20;
			friction = 0;
			damage = 6;
		}
	}
}
#define weapon_name
return "SNIPER RIFLE";

#define weapon_sprt
return sprSniperGun;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 60;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapHammer;

#define weapon_melee
return false;

#define weapon_laser_sight
return firing;

#define weapon_text
return "IN MY SIGHTS";

#define weapon_fire
	// effect
	sound_play(sndSniperTarget);
	weapon_custom_delay = 30;