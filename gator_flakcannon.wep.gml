#define init

#define game_start

#define step

if ("smoke_buff_bullets" not in self){
	smoke_buff_bullets = 0;
}

if(weapon_custom_delay >= 0){
	weapon_custom_delay--;
}

blts = smoke_buff_bullets;

if(weapon_custom_delay = 0){
	weapon_post(6, 10, 10);	// weapon kick and screen shake
	sound_play_pitch(sndFlakCannon, random_range(0.85,1.15));
	with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), FlakBullet){
		creator = other;
		team = creator.team;
		direction = creator.gunangle + random_range(-5,5);
		image_angle = direction;
		friction = 0.35;
		speed = 9 + other.boom;
		damage = 1 + other.boom;
	}
	motion_add(gunangle+180,boom);
}

with(Bullet2){
    if("boosted" not in self){
        speed = random_range(6 + other.boom,12 + other.boom);
		friction = 0.85;
        boosted = true;
    }
}

#define weapon_name
return "GATOR FLAK CANNON";

#define weapon_sprt
return sprBuffGatorFlakCannon;

#define weapon_type
return 2;

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
return "Blam";

#define weapon_fire
// effect
instance_create(x, y - 8, AssassinNotice);
// delay to shoot
weapon_custom_delay = 5 - smoke_buff_bullets;
boom = blts;