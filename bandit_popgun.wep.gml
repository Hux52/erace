#define init

#define game_start

#define step

#define weapon_name
return "BANDIT POP GUN";

#define weapon_sprt
return sprJungleBanditGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 0;

#define weapon_area
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return "Pop pop pop pop";

#define weapon_fire
weapon_post(4, 10, 10);	// weapon kick and screen shake
sound_play_pitch(sndPopgun, random_range(0.85,1.15));
with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), Bullet2){
	creator = other;
	team = creator.team;
	direction = creator.gunangle + random_range(-10,10);
	image_angle = direction;
	friction = 0.9;
	speed = 15;
	damage = 1;
}