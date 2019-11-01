#define init

#define game_start

#define step

#define weapon_name
return "GRUNT RIFLE";

#define weapon_sprt
return sprPopoGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 6;

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
return "FREEZE!";

#define weapon_fire
weapon_post(5, 4, 2);	// weapon kick and screen shake
sound_play_gun(sndGruntFire, 0.2, 0.6);
with(instance_create(x, y, Bullet1)){
	sprite_index = sprIDPDBullet;
	spr_dead = sprIDPDBulletHit;
	creator = other;
	team = creator.team;
	direction = creator.gunangle + (10 * choose(-1, 1) * random(creator.accuracy));
	image_angle = direction;
	friction = 0;
	speed = 8;
	damage = 3;
}
// The below will make it so that releasing the fire key resets the reload time 
// In effect, this makes it so you can click to fire faster than by holding the fire key
if(fork()){
	while instance_exists(self){
		if reload < 3 || wep != mod_current exit;
		if !button_check(index,"fire") || (clicked){
			reload = min(3,reload);
			exit;
		}
		wait 0;
	}
	exit;
}