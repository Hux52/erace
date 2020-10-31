#define init

#define game_start

#define step

#define weapon_name
return "MOLESARGE SHOTGUN";

#define weapon_sprt
return sprMolesargeGun;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 30;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapShotgun;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return "Kablam";

#define weapon_fire

weapon_post(6, 10, 10);	// weapon kick and screen shake
sound_play_pitch(sndMolesargeFire, random_range(0.85,1.15));

for (i = 0; i < 5; i++){
	with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), Bullet2){
		creator = other;
		team = creator.team;
		direction = creator.gunangle - 25 + (other.i*12.5);
		image_angle = direction;
		friction = random_range(0.8,1.2);
		speed = 15;
		damage = 1;
	}
}