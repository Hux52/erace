#define init

#define game_start

#define step

#define weapon_name
return "";

#define weapon_sprt
return mskNone;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 20;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapEnergy;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return "RAD ASSAULT";

#define weapon_fire
weapon_post(0, 5, 3);	// weapon kick and screen shake
sound_play(sndGuardianFire);
// mid ball
for(i = -1; i < 2; i++){
	with instance_create(x + lengthdir_x(4, gunangle + (25 * i)), y + lengthdir_y(4, gunangle + (25 * i)), GuardianBullet){
		creator = other;
		team = creator.team;
		direction = creator.gunangle + (25 * creator.i);
		image_angle = direction;
		friction = 0;
		if(other.i = 0){
			speed = 1;
		}
		else{
			speed = 2;
		}
		damage = 5;
	}
}