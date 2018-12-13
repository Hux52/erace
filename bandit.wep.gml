#define init

#define game_start

#define step

#define weapon_name
return "BANDITRIFLE";

#define weapon_sprt
return sprBanditGun;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 20;

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
return "FIRE FIRST, AIM LATER";

#define weapon_fire
weapon_post(5, 30, 10);
sound_play(sndEnemyFire);
with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), AllyBullet){
	creator = other;
	team = creator.team;
	direction = creator.gunangle;
	image_angle = direction;
	friction = 0;
	speed = 4;
	damage = 3;
}