#define init

#define game_start

#define step

#define weapon_name
return "TURRET";

#define weapon_sprt
return mskNone;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 35;

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
return "RATATATATATATATATATA";

#define weapon_fire
if("show_anim" in self and "hide_anim" in self){
	if(show_anim <= 0 and hide_anim <= 0){
		spr_idle = sprTurretFire;
		spr_walk = sprTurretFire;
		sprite_index = sprTurretFire;
		// create burst distance from gun
		var _x = x + lengthdir_x(5, gunangle);
		var _y = y + lengthdir_y(5, gunangle);
		with instance_create(_x, _y, CustomObject){
			name = "turretBurst";
			creator = other;
			team = creator.team;
			creator.cooldown = current_time_scale * 2;
			mask_index = mskNone;
			spr_shadow = mskNone;
			direction = other.gunangle + (random(other.accuracy) * choose(1, -1));
			friction = 0;
			on_step = script_ref_create(turretBurst_step);
			alarm = [0];
			ammo = 10;
		}
	}
}

#define turretBurst_step
if(instance_exists(creator)){
	creator.cooldown = current_time_scale * 2;
	if("show_anim" in creator and "hide_anim" in creator){
		if(creator.show_anim <= 0 and creator.hide_anim <= 0){
			direction = creator.gunangle + (random(creator.accuracy) * choose(1, -1) * random(10));
			// follow player
			x = creator.x + lengthdir_x(5, creator.gunangle);
			y = creator.y + lengthdir_y(5, creator.gunangle);
			// fire bullets
			if(alarm[0] <= 0 and ammo > 0){
				ammo--;
				alarm[0] = 3;
				sound_play_gun(sndTurretFire, 0.2, 0.6);
				with(instance_create(x, y, AllyBullet)){
					creator = other.creator;
					team = creator.team;
					direction = other.direction;
					image_angle = direction;
					friction = 0;
					speed = 8;
					damage = 5;
					with(creator){
						weapon_post(5, 30, 10);	// weapon kick and screen shake
					}
				}
			}
			for(i = 0; i < array_length(alarm); i++){
				if(alarm[i] >= 0){
					alarm[i]-= current_time_scale;
				}
			}
			if(ammo <= 0){
				creator.spr_idle = sprTurretIdle;
				creator.spr_walk = sprTurretIdle;
				creator.sprite_index = sprTurretIdle;
				instance_destroy();
			}
		}
		else{
			creator.spr_idle = sprTurretIdle;
			creator.spr_walk = sprTurretIdle;
			creator.sprite_index = sprTurretIdle;
			instance_destroy();
		}
	}
}