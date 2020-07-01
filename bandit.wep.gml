#define init

#define game_start

#define step

#define weapon_name
return "BANDIT RIFLE";

#define weapon_sprt
return mskNone;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 20 - + min(10, 1 * GameCont.level);

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
if("spins" not in self){
	spins = 0;
}
weapon_post(4 + (spins * 6), 3 + (spins * 6), 2 + (spins * 6));	// weapon kick and screen shake
sound_play_pitchvol(sndEnemyFire, random_range(0.9, 1.1) - (spins * 0.1), 2);
if(spins > 0){
	sound_play_pitchvol(sndHammer, random_range(0.9, 1.1) - (spins * 0.1), 0.8);
}
with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), AllyBullet){
	creator = other;
	team = creator.team;
	direction = creator.gunangle;
	image_angle = direction;
	friction = 0;
	image_xscale = 1 + (creator.spins * 0.2);
	image_yscale = 1 + (creator.spins * 0.2);
	speed = 6 + (creator.spins);
	damage = (4 + 0.8 * GameCont.level) * (creator.spins + 1);
}
spins = 0;