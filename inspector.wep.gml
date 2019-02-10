#define init

#define game_start

#define step

#define weapon_name
return "INSPECTOR SLUGGER";

#define weapon_sprt
return sprPopoSlugger;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 10;

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
return "SNIPER";

#define weapon_fire
weapon_post(5, 30, 10);	// weapon kick and screen shake
sound_play_gun(sndGruntFire, 0.2, 0.6);
with(instance_create(x, y, PopoSlug)){
	sprite_index = sprPopoSlug;
	spr_dead = sprPopoSlugDisappear;
	creator = other;
	team = creator.team;
	direction = other.gunangle + (5 * random(creator.accuracy) * choose(-1, 1));
	image_angle = direction;
	friction = 0.8;
	speed = 15;
	damage = 22;
}