#define init

#define game_start

#define step
if(weapon_custom_delay >= 0){
	weapon_custom_delay--;
}

if(weapon_custom_delay = 0){
	weapon_post(6, 10, 10);	// weapon kick and screen shake
	sound_play_pitch(sndFlakCannon, random_range(0.85,1.15));
	with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), FlakBullet){
		creator = other;
		team = creator.team;
		direction = creator.gunangle + random_range(-5,5);
		image_angle = direction;
		friction = 0.35;
		speed = 9;
		damage = 1;
	}
}

with(Bullet2){
    if("boosted" not in self){
        speed = random_range(6,12);
		friction = 0.85;
        boosted = true;
    }
}

#define weapon_name
return "GATOR FLAK CANNON";

#define weapon_sprt
return sprBuffGatorFlakCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 25;

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
return "Pop pop pop pop";

#define weapon_fire
// effect
instance_create(x, y - 8, AssassinNotice);
// delay to shoot
weapon_custom_delay = 5;