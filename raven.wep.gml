#define init

#define game_start

#define step

#define weapon_name
return "RAVEN TOMMYGUN";

#define weapon_sprt
return sprRavenGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 30;

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
return "SHORT, CONTROLLED BURSTS";

#define weapon_fire
if("fly_alarm" in self){
	if(fly_alarm = 0){
		// create burst distance from gun
		var _x = x + lengthdir_x(5, gunangle);
		var _y = y + lengthdir_y(5, gunangle);
		with instance_create(_x, _y, CustomObject){
			name = "ravenBurst";
			creator = other;
			team = creator.team;
			mask_index = mskNone;
			spr_shadow = mskNone;
			direction = other.gunangle + (random(other.accuracy) * choose(1, -1));
			friction = 0;
			on_step = script_ref_create(ravenBurst_step);
			alarm = [15];
		}
	}
}

#define ravenBurst_step
if(instance_exists(creator)){
	if("fly_alarm" in creator){
		if(creator.fly_alarm = 0){
			direction = creator.gunangle + (random(creator.accuracy) * choose(1, -1) * random(20));
			// follow player
			x = creator.x + lengthdir_x(5, creator.gunangle);
			y = creator.y + lengthdir_y(5, creator.gunangle);
			// fire bullets
			if(alarm[0] % 5 = 0){	// 3 bullets
				sound_play_gun(sndEnemyFire, 0.2, 0.6);
				with(instance_create(x, y, AllyBullet)){
					creator = other.creator;
					team = creator.team;
					direction = other.direction;
					image_angle = direction;
					friction = 0;
					speed = 4;
					damage = 3;
					with(creator){
						weapon_post(5, 30, 10);	// weapon kick and screen shake
					}
					
				}
			}
			for(i = 0; i < array_length(alarm); i++){
				alarm[i]-= current_time_scale;
			}
			if(alarm[0] <= 0){
				instance_destroy();
			}
		}
		else{
			instance_destroy();
		}
	}
}