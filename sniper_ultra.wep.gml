#define init
firing = false;

#define game_start

#define step
if ("weapon_custom_delay" not in self){
	weapon_custom_delay = 0;
}
if("sniper_ammo" not in self){
	sniper_ammo = 100;
}
if(weapon_custom_delay >= 0){
	weapon_custom_delay-= current_time_scale;
	// no moving
	canwalk = false;
	firing = true;
}
if(weapon_custom_delay <= 0){
	// can walk again
	canwalk = 1;
	if(sniper_ammo < 100 and sniper_ammo % 2 = 1){
		if(sniper_ammo > random(100)){
			proj = FlameShell;
		} else {
			proj = Bullet2;
		}
		reload = 60;		
		weapon_post(5, 20, 5);	// weapon kick and screen shake
		sound_play_pitch(sndSnowTankShoot,1 + (sniper_ammo/200));
				
		if(sniper_ammo > random(200)){
			with(instance_create(x,y,Smoke)){
				direction = random(360);
				friction = 0.3;
				speed = 4;
			}
		}
		
		with(instance_create(x + lengthdir_x(4, gunangle), y + lengthdir_y(4, gunangle), proj)){
			wallbounce = 1;
			creator = other;
			team = creator.team;
			direction = creator.gunangle + (((creator.sniper_ammo/6) * 1) * 1);
			image_angle = direction;
			speed = 20;
			friction = 0.5;
			damage = 4;
		}
		with(instance_create(x + lengthdir_x(4, gunangle), y + lengthdir_y(4, gunangle), proj)){
			wallbounce = 1;
			creator = other;
			team = creator.team;
			direction = creator.gunangle + (((creator.sniper_ammo/6) * -1) * 1);
			image_angle = direction;
			speed = 20;
			friction = 0.5;
			damage = 4;
		}
		sniper_ammo += 1;
	}
	else{
		sniper_ammo += 1;
	}
}

if(sniper_ammo >= 100){
	firing = false;
}

#define weapon_name
return "HYPER SNIPER";

#define weapon_sprt
return sprSniperGun;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 60;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapHammer;

#define weapon_melee
return false;

#define weapon_laser_sight
return firing;

#define weapon_text
return "IN MY SIGHTS";

#define weapon_fire
// effect
sound_play(sndSniperTarget);
weapon_custom_delay = 30;
sniper_ammo = 0;
