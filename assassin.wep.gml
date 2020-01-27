#define init
global.alt = false; //true = energy, false = lightning

// global.sprPipeBlue = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAB0AAAAGCAYAAAA/gpVXAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5AENAiITroPRyQAAAHFJREFUKM9jZGBgYBCc83YeA43A+xThJHQxFsE5b+e9TxFOpJWlgnPeYjiCBcaxlxRGkVQQE6aKpQvRPCQ45y0D3NKDz1FdhM4nF8TrqzEwMDAwPHj1Fm4my/sU4ST0IKAmWIgl6hgZaAzQE+n7FOEkAMN4I0CfxJ0sAAAAAElFTkSuQmCC", 1, 0, 2);
global.sprPipeBlue = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAB0AAAAGCAYAAAA/gpVXAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5AENAjAQT37woAAAAGhJREFUKM9jZGBgYBCc8/Y/A43A+xRhRnQxRsE5b/+/TxGmlZ0MgnPeYjiCBcaxl0S1WEGMOg5ZiOYhwTlv/8MtPfgc1UXofHJBvL4aAwMDA8ODV2/hZjLSIU4xgpuRgcYA3UPvU4QZAf/cJDX0WaJ8AAAAAElFTkSuQmCC", 1, 0, 2);
global.sprPipeGreen = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAB0AAAAGCAYAAAA/gpVXAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5AENAjcYDuTuVQAAAGlJREFUKM9jZGBgYBB8K/2fgUbgvfBTRnQxRsG30v/fCz+llZ0Mgm+lMRzBAuPYSwqjSCqICVPF0oXCt9Ad8Z/mPo3XV2NgYGBgePDqLcPB528ZBN9KMzDSIU4xgpuRgcYA3UPvhZ8yAgD/PSOUI57oqgAAAABJRU5ErkJggg==", 1, 0, 2);

#define game_start

#define step
if ("weapon_custom_delay" not in self){
	weapon_custom_delay = 0;
}
if(weapon_custom_delay >= 0){
	weapon_custom_delay-= current_time_scale;
} 
if(weapon_custom_delay = 0){
	// swing
	weapon_post(3, 20, 5);	// weapon kick and screen shake
	if(race == "jungleassassin"){
		sound_play_pitchvol(sndJungleAssassinAttack, random_range(0.9, 1.1), 0.65);
	} else {
		sound_play_pitchvol(sndAssassinAttack, random_range(0.9, 1.1), 0.65);
	}
	sound_play_pitchvol(sndEnemySlash, random_range(0.9, 1.1), 0.65);
	if(ultra_get("assassin", 2)){
		if(global.alt = true){
			sound_play_pitchvol(sndEliteInspectorFire, random_range(1.7, 1.9), 0.25);
			sound_play_pitchvol(sndEnergySword, random_range(1.5, 1.7), 0.55);
			
			with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), EnergySlash)){
				creator = other;
				team = creator.team;
				direction = creator.gunangle;
				image_angle = direction;
				friction = 0;
				damage = 15;
			}
		}
		else{
			sound_play_pitchvol(sndLightningHammer, random_range(1.5, 1.7), 0.35);
			sound_play_pitchvol(sndLightningHit, random_range(1.5, 1.7), 0.85);

			with(instance_create(x + lengthdir_x(6, gunangle), y + lengthdir_y(6, gunangle), LightningSlash)){
				creator = other;
				team = creator.team;
				direction = creator.gunangle;
				image_angle = direction;
				friction = 0;
				damage = 10;
			}
		}
	}
	else{
		with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), Slash)){
			creator = other;
			team = creator.team;
			direction = creator.gunangle;
			image_angle = direction;
			friction = 0;
			damage = 5;
		}
	}
	
	if(global.alt = true){
		global.alt = false;
	}
	else{
		global.alt = true;
	}
	
	if(wepangle = 120){
		wepangle = 235;
	}
	else{
		wepangle = 120;
	}
	
}
#define weapon_name
return "PIPE";

#define weapon_sprt
if(ultra_get("assassin", 2)){
	if(global.alt) return global.sprPipeGreen;
	else return global.sprPipeBlue;
} else return sprPipe;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 20;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapHammer;

#define weapon_melee
return true;

#define weapon_laser_sight
return false;

#define weapon_text
return "YOU ARE ALREADY DEAD";

#define weapon_fire
// effect
instance_create(x, y - 8, AssassinNotice);
weapon_custom_delay = 5;
