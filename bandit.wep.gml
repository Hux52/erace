#define init

#define game_start

#define step

#define weapon_name
return "BANDIT RIFLE";

#define weapon_sprt
return sprBanditGun;

#define weapon_type
return 1;

#define weapon_auto
if(GameCont.level = 10){
	return true;
}
else{
	return false;
}

#define weapon_load
return 21 - GameCont.level;

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
weapon_post(5, 30, 10);	// weapon kick and screen shake
sound_play(sndEnemyFire);
with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), AllyBullet){
	creator = other;
	team = creator.team;
	direction = creator.gunangle;
	image_angle = direction;
	friction = 0;
	speed = 6;
	damage = 2.5 + (0.5 * GameCont.level) + (GameCont.loops * 0.33);
}