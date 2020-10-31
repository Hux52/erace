#define init

#define game_start

#define step

#define weapon_name
return "MOLEFISH GUN";

#define weapon_sprt
return sprMolefishGun;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 15;

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
return false;

#define weapon_fire
weapon_post(5, 4, 2);	// weapon kick and screen shake
sound_play_pitchvol(sndMolefishFire,random_range(0.9,1.1),0.65);
with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), AllyBullet){
	creator = other;
	team = creator.team;
	direction = creator.gunangle;
	image_angle = direction;
	friction = 0;
	speed = 4;
	damage = 3;
}