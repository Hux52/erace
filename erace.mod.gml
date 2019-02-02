#define init
if(instance_exists(CustomObject)){
	with(instances_matching(CustomObject,"name", "AreaBackgr")){
		instance_delete(self);
	}
}

global.healthChance = 30;	//percent chance of transforming an ammo pickup into a health pickup
global.erace_raddrop = 1;	//extra rads to drop
global.select_exists = false;	// checks for character select
global.sprAreaSelect = sprite_add("/sprites/sprAreaSelect.png", 8, 8, 12);	// area buttons sprite strip
global.sprAreaSelected = sprite_add("/sprites/sprAreaSelected.png", 8, 8, 12);	// area buttons sprite strip
global.races = [
					["maggotspawn", "bigmaggot", "bandit", "scorpion"],
					["rat", "ratking", "exploder", "gator", "assassin"],
					["raven", "salamander", "sniper"],
					["spider", "lasercrystal"],
					["snowbot", "wolf"],
					["freak","explofreak","rhinofreak","necromancer"],
					["guardian", "exploguardian", "dogguardian"],
					["jock"]
				];	// please add races in the order and area you want them to be displayed

global.player_races = ["unknown", "unknown", "unknown", "unknown"];

global.race_names = ["maggotspawn", MaggotSpawn, "bigmaggot", BigMaggot, "bandit", Bandit, "scorpion", Scorpion, "rat",
					Rat, "ratking", Ratking, "exploder", Exploder, "gator", Gator, "assassin", MeleeBandit, "raven", Raven,
					"salamander", Salamander, "sniper", Sniper, "spider", Spider, "lasercrystal", LaserCrystal, "snowbot", SnowBot, "wolf", Wolf, "freak", Freak,
					"explofreak", ExploFreak, "rhinofreak", RhinoFreak, "necromancer", Necromancer, "guardian", Guardian,
					"exploguardian", ExploGuardian, "dogguardian", DogGuardian, "jock", Jock];	// piss off

global.deselect_color = make_color_hsv(0, 0, 80);	// dimmnessss :)
global.hover_color = make_color_hsv(0, 0, 190);	// same

global.backgrounds_A = [sprFloor1,sprFloor2,sprFloor3,sprFloor4,sprFloor5,sprFloor6,sprFloor7,sprFloor100];
global.backgrounds_B = [sprFloor1B,sprFloor2B,sprFloor3B,sprFloor4B,sprFloor5B,sprFloor6B,sprFloor7B,sprFloor100B];

// disable default races
for(i = 1; i < 16; i++){
	race_set_active(i, 0);
}

// disable weapon/ammo specific mutations as well as thronebutt
skill_set_active(mut_throne_butt, 0);
skill_set_active(mut_bolt_marrow, 0);
skill_set_active(mut_recycle_gland, 0);
skill_set_active(mut_laser_brain, 0);
skill_set_active(mut_shotgun_shoulders, 0);
skill_set_active(mut_lucky_shot, 0);
skill_set_active(mut_back_muscle, 0);

// replace chest corpse sprites
open_sprites = [sprAmmoChestMysteryOpen, sprAmmoChestOpen, sprAmmoChestSteroidsOpen, sprWeaponChestOpen, sprWeaponChestBigOpen, sprWeaponChestSteroidsUltraOpen];
for(i = 0; i < array_length(open_sprites); i++){
	sprite_replace_base64(open_sprites[i], "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAa0lEQVR4nGNgoBQ4NDAwMDAw/CcHOzQwMDAyMDD8n7n1DFmWp3ubMLAgc0gBMEuZyLIaCYwawICIBXKjkoWBgYHh0KHDDNdP7WfQNHMkShOy2oEPAyYGBoiTSAUwPUwMDAxE+x0ZwPVQmhsBNc02ZBtsCAsAAAAASUVORK5CYII=", 1)
}

// replace ammo in rabbit paw icons with health
sprite_replace_base64(sprSkillIcon, "iVBORw0KGgoAAAANSUhEUgAAAtAAAAAgCAMAAAAMhL+eAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAABUUHBgSEh4WIhMvARwjJhMvOh0pNyMcEz8ZEycZKSofLyAlKCogICkvMisoOSs2OzI5PhknQTAUQyI2WSw5UB9KAiFPAiROCS1JLTN7BF4XF04qMl8vJlA/KmkDA2skH2A7NEIwS0E8Zmg4Q2pLIEJLUkhVW0xWXU9YX3heRmxhQm9nQX9kQxFLrCFUjAB4/B9y/1t3j2xAgmJckGx6hAKdJAC4ADvHMTHSVUicEUj9CHiAhH6ivkKc/40yG54gAJ8oKKMFBaUJK4dAO4FpIqNEAKptQcIqAPw4ANhTMcxjANtqAK1QuYq3BrSdFYqETp2FYqSWao/WC4zHMbPULr79CIHSVbHcSdeMFNGdANavBMunOuyEIv+kD/y4AMmfd9m0RerIGv/ILv//AND0WOfbaoqWnp2rr6eutJm1zKm8xu+Vu+agj9+W1NDFtPDXvv30vdjTxcXV4uzo1P///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPo16PsAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGHRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4xLjVkR1hSAAAk4klEQVR4Xo2cj2McR7VmizhZL/DsZ1h5ZMYhgGISRXogvQivny1+2VpExENOrF0SxsR+QhGIIKI4iebv3z3nu9Uzozg4exNP9/T0VN+6deqrW9Wtaf/3n9irWDt8hh22divmoVcvX2537rTxnTt3+Oem22Xt+qLxvrX2b9p7773X+Ncth2bnt5WVlUsrW2f7W/v7vPAR39L62f38XDxu8NHB+f375wfr7P2309O2tLS0sXE6t42ljdPptE1PN8s2ptjpxqabaQrrBXfLoZe0K4vW9ve32v+Y+Tm3HJqdr6s5/0oOrVXMsLVPyx41XZ9MJrtHR0ftTtvdnbQ25js5n0u38Xg0mfDZuO1ORr7Z3W35sModLIdycZzg5FbuzP3p5w2W87G2skV4B2t1vNzU28P2cVUgx3fbCGdwoHw6wp9xOYPltLLj42Oiefy4jlMFajdJtWZ+trZmHDCv9azFzxju/0Tv29nZFrbS2uWhfT/7zFb67LOBt+BQ7dQ2v/vd7270RrUYOCg7ONjZ2anyvx7ow8O2iLTfGcG0tsDzWHgxnJwF+nrb2dvr+LStBaJFiHLqHHkuoLf2z8728X99/eDg4PzgItJcOi60BsvybD3W1xuoDjwbiWkRDc4XeZ5Ol2ZA90JxargCB22WCwbPHejys1vecLDO58DmxuZGJ9qmXEvjETV4foRBdDNuLUBPCuje8p6vP51oGYWfxhltNPNnuzYxDs78udMms2jrD3v9rLiVLecXzwtAb/ERRwsyvD1sb3Sgc1ygJRrNGgH0iKbtXeBifAro6XEd72fjfD7kIJhAcoh+1oGurheH209e03kULESD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", 30);

sprite_replace_base64(sprSkillIconHUD, "iVBORw0KGgoAAAANSUhEUgAAAeAAAAAQCAMAAAD571wKAAAABGdBTUEAALGPC/xhBQAAAwBQTFRFAAAAHhYiHCMmNTc7IjZZJE4JM3sEQjBLSk5USFVbTFZdW2BneF5GbGFCaW53IVSMAHj8W3ePbECCALgAAKgmNpwRAP8AMdJVSJwRSP0IfYKMQpz/zAAA/DgA22oArVC5ircGvv0IgdJV14wU0Z0Ay6c6/LgAyZ936sga//8AoKSrmbXMs7rBu77D35bU8Ne+297h7OjU////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjRXNjwAAAQB0Uk5T////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////AFP3ByUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjEuNWRHWFIAAAlySURBVFhHvZiNVtw4EkZFOttN4+zA0LskeCCEwAaYjEPT7/9u7P2+Ksl2A5nZc/ZMAbJKKpV+rkqWKc//JymSzP9MqpXt/5feZ9bk326bln/dvUYiSTVkT/upr1eav2gx1cN62mTP+oW7PXWmy1jqtFEte22ZplaZ+VMpZRiG/qX7l1K6C9WVngZjiz37V5qXrh+t0eQj1T0pXeea+nwp4XzsogwaTT9MOy3/mmlj527oATaDcnp6enV1OrFXi6bKrpTNRB+2Wzp7eHhoHoZh0rpodfpZ/5PFlUzty+6SH9TJhL28bjJrZinr6rmQjZzy45o7P28ovo2Xac8HOEq5uOguLoJvV1GUw647nPifqZZSFo0wnXcd+dFiNqLSLZRXi5mLJuX+Uub3960Fo+379ZpVS3bie3bWfLLi43SU1+gb9OC7R7i1JbthRZYVsHxtt2XbP+x2u0p4CowOjhgOyehBAxwN5vYAvpwAjuELQKhpNUpZV6xjzg2qzzH46iQ05tGgrFb9wJz3N11Ykw5ABrPwGoF4Sg7T22HoIB4dlB6+4VDRWzpYRGu57Iedes/qhcnWp8tmu+GeBel7kkpY419LCOJnwEKW+C1CHPXUYJAKG1N9xUMFK8tpA6xx669K2SyHBrhst12nCO4edrcJWBMYAwK+R+fX1+dHjTCzBXCdjOzlsNkL8HeUBKz9LUCdZvN6BJN4gBnBUib8gqXmmAGY+BGpZQXcA/6CcBsGB5KnI8CFY9qEPKLkm4Thu0CkT0MQBjHFWAwA+5kFBAPuQj3R8a1M6U6ifXko5VtjXFiPAHwZBcxTESPCBhx4Ne0ADF8D9mqYLAseqVeJCTuAV1dh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", 30);

trace ("Welcome to Hell.");
trace ("Type '/ehelp list' for a list of commands.");

oldPick = array_create(4, 0);
charEnemies = array_create(4," ");
global.e = array_create(4, 0);

global.t = -1;

#define step
if(global.t < 10){
	global.t += 1;
}

// global.pNum = 0;

// for (i = 0; i < array_length(oldPick); i++){
// 	oldPick[i] = player_get_race(i);
// 	wait(1);	
// }

// for (i = 0; i < array_length(oldPick); i ++ ){
// 	if(player_get_race(i) != oldPick[i]){
// 		trace(string(player_get_race(i)) + ":" + string(oldPick[i]));
		
// 	}
// }


// if(player_get_race(0) != oldPick[0]){
// 	//first get rid of existing enemies
// 	with(enemy){
// 		instance_delete(self);
// 	}
	
// 	//next, spawn in all the selected enemies
// 	for (i = 0; i < 4; i++){
// 		if((player_get_uid(i)) > 0){
// 			global.pNum += 1;
// 		}
// 	}

// 	if(GameCont.area == 0){
// 		for (i = 0; i < global.pNum; i++){
// 			for (j = 0; j < array_length(global.races); j++){			
// 				if(array_find_index(global.races[j],player_get_race(i)) >= 0){
// 					global.e[i] = global.enemies[j][array_find_index(global.races[j],player_get_race(i))];
// 				}
// 			}
// 		if(instance_exists(global.e[i])){
// 			instance_delete(global.e[i]);
// 		}
// 			r = random(360);
// 			//trace(global.e[i]);
// 			instance_create(Campfire.x + lengthdir_x(40,r),Campfire.y + lengthdir_y(40,r), global.e[i]);
// 		}
// 	}
// }

// replace big chests with health chests

if (instance_exists(GenCont) == false){
with(AmmoChest){
		instance_create(x, y, HealthChest);
		instance_create(x, y, HealFX);
		instance_create(x, y, BloodLust);
		instance_destroy();
	}
	
	with(WeaponChest){
		instance_create(x, y, HealthChest);
		instance_create(x, y, HealFX);
		instance_create(x, y, BloodLust);
		instance_destroy();
	}
	
} else {
	//stop snowbot loop in portal
		if(audio_is_playing(sndSnowBotSlideLoop)){
		sound_stop(sndSnowBotSlideLoop);
	}
}
// chance for ammo pickups to become hp- delete otherwise
with(AmmoPickup){
	if(random(100) > 100 - global.healthChance){
		instance_create(x, y, HPPickup);
		instance_create(x, y, HealFX);
		instance_create(x, y, BloodLust)
	}
	instance_destroy();
}

// weapons become hp, guaranteed
with(WepPickup){
	instance_create(x, y, HPPickup);
	instance_create(x, y, HealFX);
	instance_create(x, y, BloodLust);
	instance_create(x, y, StrongSpirit);
	sound_play_pitchvol(sndSwapGold,0.8,1);
	sound_play_pitchvol(sndSwapCursed,0.8,2);
	
	instance_destroy();
}

// no contact damage, rad bonus
with(enemy){
	if("erace_has_dropped_rads" not in self){
		raddrop += global.erace_raddrop;
		erace_has_dropped_rads = true;
	}
	if(meleedamage > 0){
        var _p = instance_nearest(x, y, Player);
		if(instance_exists(_p)){
			if("melee" in _p){
				if(_p.melee = true){
					if(point_distance(x, y, _p.x, _p.y) < 80){
						canmelee = 0;
					} else {
						canmelee = 1;
					}
				}
			}
        }
    }
}

// berid of locked race buttons
// with(instances_matching(CharSelect, "sprite_index", sprCharSelectLocked)){
// 	instance_delete(self);
// }

// assign race buttons an area and index in said area
with(CharSelect){
	if("area" not in self and sprite_index != sprCharSelect){
		xstart = -999;
		ystart = -999;
		for(i = 0; i < array_length(global.races); i++){
			for(k = 0; k < array_length(global.races[i]); k++){
				if(race = global.races[i][k]){
					index = k;
					area = i;
					break;
				}
			}
		}
	}
}

// spawn enemies
if(instance_exists(CharSelect)){
	for(i = 0; i < 4; i++){
		if(global.player_races[i] != player_get_race(i)){
			if(player_get_race(i) != "unknown" and player_get_race(i) != ""){
				for(m = 0; m < array_length(global.race_names); m += 2){
					if(global.race_names[m] = player_get_race(i)){
						var _e = instances_matching(enemy, "index", i);
						if(array_length(_e) > 0){
							instance_delete(_e[0]);
						}
						with(instance_create(64 + lengthdir_x(50, 90 * i), 64 + lengthdir_y(50, 90 * i), global.race_names[m + 1])){
							index = other.i;
							mask_index = mskNone;
							friction = 10;
						}
						break;
					}
				}
			}
		}
		else{
			// view_object[i] = instance_nearest(64, 64, Campfire);
		}
		// var _view = instances_matching(enemy, "index", i);
		// if(array_length(_view) > 0){
		// 	// view_object[i] = _view[0];
		// 	for(j = 0; j < 8; j++){
		// 		alarm_set(j, 999);
		// 	}
		// }
		global.player_races[i] = player_get_race(i);
	}
	with(instances_matching_ne(enemy, "index", null)){
		for(i = 0; i < 8; i++){
			alarm_set(i, 0);
		}
	}
}


// character selects just appeared
if(global.select_exists != instance_number(CharSelect) and instance_number(CharSelect) > 0){
	// campfire and fix view
	with(Campfire){
		//spr_idle = sprCampfireOff;
		for(i = 0; i < maxp; i++){
			view_object[i] = self;
		}
	}
	with(LogMenu){
		instance_delete(self);
	}
	// remove campfire characters
	with(CampChar){
		x = 64;
		y = 64;
		lastx = 64;
		lasty = 64;
		spr_to = mskNone; spr_slct = mskNone; spr_from = mskNone; spr_menu = mskNone; spr_shadow = mskNone;
		sprite_index = mskNone;
	}
	// get rid of old custom buttons, if any
	with(instances_matching(CustomObject, "name", "AreaSelect")){
		instance_destroy();
	}
	// make custom buttons
	for(i = 0; i < 8; i++){	// 8 buttons
		with(instance_create(-80 + (35 * (i + 1)), 165, CustomObject)){	// 35 * (i + 1)      optimal spacing
		//with(instance_create(view_xview + 16 + (35 * (i + 1)), 165, CustomObject)){	// 35 * (i + 1)      optimal spacing
			name = "AreaSelect";	// object name
			area = other.i;	// area
			selected = false;	// button selected bool
			view_offset = 0;	// offset for if child icons go out of view
			sprite_index = global.sprAreaSelect;	// all in one sprite
			image_index = area;	// specific frame of sprite
			image_speed = 0;	// no anim
			depth = -9999;	// draw on top of ui
			my_bg = array_create(9, noone);
			
			//draw stuff
			t = global.t;
			_x1 = xstart - 8;
			_y1 = ystart - 12;
			_x2 = xstart + 7;
			_y2 = ystart + 11;
			on_step = script_ref_create(area_select_step);	// custom step
			on_draw = script_ref_create(area_select_draw);	// custom step
			
			for(j = 0; j <= 9; j++){
				with(instance_create(-96 + (j*32),999,CustomObject)){
					name = "AreaBackgr";	// object name
					area = other.area;	// area
					if(area == 4){
						sprite_index = global.backgrounds_A[area];
					} else {
						sprite_index = choose(global.backgrounds_A[area], global.backgrounds_B[area]);
					}					
					image_index = irandom(sprite_get_number(sprite_index));	// specific frame of sprite
					image_speed = 0;	// no anim
					image_blend = global.deselect_color;
					depth = -1003;	// draw on top of ui
					other.my_bg[other.j] = self;
				}
			}
		}
	}
}
// character selects just disappeared
else if(global.select_exists != instance_number(CharSelect) and instance_number(CharSelect) = 0){
	with(instances_matching(CustomObject, "name", "AreaSelect")){
		instance_destroy();
	}
}

// // keep custom buttons oriented
// for(i = 0; i < 8; i++){
// 	with(instances_matching(CustomObject, "name", "AreaSelect")){
// 		if(area = other.i){
// 			x = view_xview + 16 + (35 * (other.i + 1));
// 			y = view_yview + 221;
// 			for(j = 0; j <= 9; j++){
// 				with(my_bg[j]){
// 					x = view_xview + (other.j * 32);
// 					y = 999;
// 				}
// 			}
// 		}
// 	}
// }

// manage check
global.select_exists = instance_number(CharSelect);

#define area_select_step
t += 1/room_speed;
// check for player click
image_blend = global.deselect_color;	// dimmest
	mouse_over = false; //is not being moused over
sprite_index = global.sprAreaSelect;
for(i = 0; i < maxp; i++){
	if(abs(mouse_x[i] - x) < 8 and abs(mouse_y[i] - y) < 16){	// if mouse over button
		if(selected = false){
			image_blend = global.hover_color;	// dim
			mouse_over = true; //is being moused over
		}
		if(button_pressed(i, "fire")){	// if clicked
			if(selected = 0){
			sound_play_pitchvol(sndSlider,1.5,1);
			sound_play_pitchvol(sndMenuOptions,2.5,0.2);
				
				// deselect all custom buttons
				with(instances_matching(CustomObject, "name", "AreaSelect")){
					selected = 0;
				}
			selected = 1;	// select button
			} else if (selected = 1){
				selected = 0;
				sound_play_pitchvol(sndSlider,2.5,1);
			}
		}
	}
}

with(instances_matching(CustomObject, "name", "AreaSelect")){
	if("selected" in self){
		if (selected == 1){
			// move loadout as to not interfere with race buttons
			with(Loadout){
				ystart -= 50;
				y -= 50;
				visible = false;
			}
	break;
		} else {
			with(Loadout){
				visible = true;
			}
		}
	}
}

// brightness and child button positioning
if(selected = 1){
	image_blend = c_white;	// bright
	// move buttons relative to parent of same area
	with(instances_matching(CharSelect, "area", area)){
		xstart = other.x + 88 + (20 * (index + 1)) - (((array_length(global.races[area]) + 1) * 20) / 2) + other.view_offset;	// :twitchSmile:
		ystart = lerp(ystart, other.y + 16, 0.5);
		if(ystart > 200){
			visible = false;
		} else {
			visible = true;
		}
		// if first button out of view, change offset
		if(index = 0){
			if(xstart < 0){
				other.view_offset = xstart * -1;
			}
		}
		// if last button out of view, change offset
		else if(index = (array_length(global.races[area]) - 1)){
			if(xstart > (game_width - 16)){
				other.view_offset = xstart - (game_width - 16);
			}
		}
	}

	for(i = array_length(my_bg)-1; i >= 0; i--){
		//version A:
		// my_bg[i].y = lerp(my_bg[i].y, ystart-15, clamp(1/(i+1), 0, 1));
		// my_bg[i].x = -96 + (i*32);
		
		//version B:
		my_bg[i].y = ystart - 15;
		my_bg[i].x = lerp(my_bg[i].x, -96 + (i*32), 0.1);

		my_bg[i].image_blend = make_color_hsv(0, 0, 64);
	}

}else{
	// out of my sight
	with(instances_matching(CharSelect, "area", area)){
		xstart = 999;
		ystart = 300;
	}
	
	for(i = 0; i < array_length(my_bg); i++){
		//version A:
		// my_bg[i].x = -1000;
		// my_bg[i].y = ystart + random_range(100,600)

		//version B:
		my_bg[i].x = other.xstart-20;
		my_bg[i].y = -1000;		
	}
}

#define area_select_draw

_c = draw_get_color();
_a = draw_get_alpha();
draw_set_color(c_white);
if(t < pi){
	draw_set_alpha(abs(sin(t*3)));
	draw_rectangle(_x1, _y1, _x2, _y2,true);
}
if(mouse_over){
	draw_set_alpha(1);
	draw_rectangle(_x1, _y1, _x2, _y2,true);
}
draw_set_alpha(_a);
draw_set_color(_c);

#define chat_command
// chat commands
var command = string_upper(argument0);
var parameter = string_upper(argument1);
switch(command){
	case "EHELP":
		//help command for BABIES. go read a book
		switch (parameter){
			case "":
				trace("No one can save you now.");
				trace("Type '/ehelp list' to see a list of commands.");
			break;
			
			case "LIST":
				//list commands
				trace("List of ERACE commands:");
				trace("/ehelp [command] - only use this in case of severe confusion");
				trace("/echance - chance for small ammo pickups to become health pickups");
				trace("/erads - change how many rads the enemies drop for a less unpleasant experience");
			break;
			
			case "EHELP":
				trace("If you need help with getting help, you are truly lost.");
				//I mean, you can't argue there
			break;
			
			case "ECHANCE":
				trace("Sets the chance, in percent, to transform an ammo pickup into a health pickup.");
				trace("/echance default to return to the industry standard of 30.78916478246%.")
			break;
			
			case "ERADS":
				trace("Sets how many additional rads the enemies drop on death. (Default - 1)");
				trace("Use this if you just feel like the enemies don't drop enough rads for your liking.");
			break;
			
			default:
				trace(choose("Wrong.", "Incorrect.", "Are you sure about that?", "Think again.") + " Command not found.");
			break;
		}
	return true;
	break;
	
	case "ECHANCE":
		switch(parameter){
		case "DEFAULT":
			global.healthChance = 30;
			trace("Health pickup transform reverted to normal. (" + string(global.healthChance) + "%)");
		break;
		
		case "":
			trace("You forgot to type in a number.");
		break;
		
		default:
			global.healthChance = real(parameter);
			trace("Chance to transform into a health pickup now " + string(global.healthChance) + "%");
		break;
		}
	return true;
	break;
	
	case "ERADS":
		switch(parameter){
			case "":
				if(global.erace_raddrop == 1){
					trace("Enemies now drop " + string(global.erace_raddrop) + " more rad on death.");
				}else if (global.erace_raddrop == 0){
					trace("Enemies drop their normal amount of rads on death.");
				}else{
					trace("Enemies now drop " + string(global.erace_raddrop) + " more rads on death.");
				}
			break;
			
			default:
			if (real(parameter) < 0){
				trace("Enter a non-negative number, please.");
			} else if (real(parameter) > 200) {
				trace("That number's too high even for me.");
			} else if (real(parameter) > 0) {
				global.erace_raddrop = real(parameter);
				
				if(real(parameter) == 1){
					trace("Enemies now drop " + string(global.erace_raddrop) + " more rad on death.");
				} else {
					trace("Enemies now drop " + string(global.erace_raddrop) + " more rads on death.");
				}
			} else {
				global.erace_raddrop = 0;
				trace("Enemies drop their normal amount of rads on death.");
			}
		}
	return true;
	break;
	}
