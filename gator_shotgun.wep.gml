#define init

#define game_start

#define step

if ("proj" not in self){
	proj = Bullet2;
}

if("boom" not in self){
	boom = false;
}

if ("smoke_buff_bullets" not in self){
	smoke_buff_bullets = 0;
}

blts = smoke_buff_bullets;

if(weapon_custom_delay >= 0){
	weapon_custom_delay--;
}

if(weapon_custom_delay = 0){
	weapon_post(6, 10, 10);	// weapon kick and screen shake
	sound_play_pitch(sndShotgun, random_range(0.85,1.15));
	if(boom = true){
		sound_play_pitch(sndFireballerFire, 1 + 0.2*smoke_buff_bullets);
		if(ultra_get("gator", 2) == 1){
			sound_play_pitch(sndSuperFireballerFire, 1 + 0.2*smoke_buff_bullets);
		}
	}
	for (i = 0; i < 7 + blts; i++){
		with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), proj){
			creator = other;
			team = creator.team;
			direction = creator.gunangle + random_range(-20 - other.blts*3,20 + other.blts*3);
			image_angle = direction;
			friction = random_range(0.8,1.2);
			speed = 15 + other.blts;
			damage = 1 + ultra_get("gator", 2);
		}
	}
	motion_add(gunangle+180, blts)
}
#define weapon_name
return "GATOR SHOTGUN";

#define weapon_sprt
return sprGatorShotgun;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 16;

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
return "Kablam";

#define weapon_fire
// effect
instance_create(x, y - 8, AssassinNotice);
// delay to shoot
weapon_custom_delay = 6 - smoke_buff_bullets;
boom = smoke_buff_bullets > 0 ? true : false;

if(ultra_get("gator", 2) == 1 && boom = true){
	proj = FlameShell;
} else {
	proj = Bullet2;
}