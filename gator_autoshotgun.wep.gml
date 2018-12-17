#define init

#define game_start

#define step

#define weapon_name
return "GATOR SHOTGUN";

#define weapon_sprt
return sprAutoShotgun;

#define weapon_type
return 2;

#define weapon_auto
return true;

#define weapon_load
return 6;

#define weapon_cost
return 0;

#define weapon_area
return 1;

#define weapon_swap
return sndSwapShotgun;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return "Bam bam bam bam";

#define weapon_fire
weapon_post(3, 10, 10);	// weapon kick and screen shake
sound_play_pitch(sndShotgun, random_range(0.85,1.15));
for (i = 0; i < 9; i++){
	with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), Bullet2){
		creator = other;
		team = creator.team;
		direction = creator.gunangle + random_range(-35,35);
		image_angle = direction;
		friction = random_range(1.2,2.2);
		speed = 20;
		damage = 1;
	}
}