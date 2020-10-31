#define init
global.ammoPack = [0, 32, 8, 7, 6, 10];
global.maxAmmo = [999, 255, 55, 55, 55, 55];
global.ammoType = ["", "BULLETS", "SHELLS", "BOLTS", "EXPLOSIVES", "ENERGY"];
global.sprStand = sprite_add("sprStand.png", 10, 16, 30);
global.mskStand = sprite_add("sprStand.png", 10, 16, 15);
global.sprStandDead = sprite_add("sprStandDead.png", 4, 16, 30);
global.icons = [
	mskNone,
	sprBulletIcon,
	sprShotIcon,
	sprBoltIcon,
	sprExploIcon,
	sprEnergyIcon
]

global.iconsBG = [
	mskNone,
	sprBulletIconBG,
	sprShotIconBG,
	sprBoltIconBG,
	sprExploIconBG,
	sprEnergyIconBG
]

#define step
with(instances_matching(CustomHitme, "name", "sentry")){
	nearplayer = noone;	
}

with(Player){
	if(!instance_exists(GenCont) and !instance_exists(mutbutton)){
		if(button_pressed(index, "pick")){
			if(nearwep != -4){
				var _wp = instance_nearest(x, y, WepPickup);
				//put turrant
				create_sentry(_wp.x, _wp.y, _wp.wep);

				sound_play_pitchvol(sndGoldUnlock, 2 + random_range(-0.1,0.1), 0.65);
				sound_play(weapon_get_swap(_wp.wep));
				if(_wp.curse){
					projectile_hit(self,4, 5,gunangle-180);
					sound_play_pitchvol(sndStrongSpiritLost, 0.6 + random_range(-0.1,0.1), 0.4);
				}
				instance_delete(_wp);
			}
		}
	}
	if(instance_exists(Portal)){
		if(distance_to_object(Portal) < 10){
			with(instances_matching(CustomHitme,"name", "sentry")){
				if(creator = other) {
					sentry_refund();
				}
			}
		}
	}
}

#define sentry_draw
if(my_health > 0){
if(nexthurt > current_frame){
	d3d_set_fog(true,c_white,0,0);	
} else {
	d3d_set_fog(false,c_white,0,0);	
}

draw_sprite_part(global.sprStand, anim div 10, 0, height, sprite_get_width(global.sprStand), 37, x - 16, y - 15);

draw_sprite_ext(sprite_index, 0, x2, y2 - height + sin((current_frame + bob) / 5), 1, yscale, gunangle + wepangle, c_white, 1);

d3d_set_fog(false,c_white,0,0);
}
#define sentry_step

if(my_health > 0){

x2 = x - lengthdir_x(4 + wkick, gunangle);
y2 = y - lengthdir_y(4 + wkick, gunangle);

move_bounce_solid(true);

if(height < -1){
	sound += current_time_scale;
	if(sound mod 3 == 0){
		sound_play_pitchvol(choose(sndFootOrgRock3,sndFootOrgRock2,sndFootOrgRock1), 2.5 - (sound/15), 0.75);
		sound_play_pitchvol(sndSlider, 1 - (sound/45), 0.35);
	}
	height = lerp(height, 0, 0.1);

	with(instance_create(x + random_range(-7,7), y + 21, Dust)){
		image_xscale = 0.8;
		image_yscale = 0.8;
	    growspeed = -0.01;
	}
}

script_bind_draw(draw_tooltips, -69, self);

if(curse){
	if(random(100 * current_time_scale) < (20 * current_time_scale)){
		instance_create(x + random_range(-4,4),y + random_range(-1,1),Curse);
	}
}

_e = noone;
_seen = [];
_enemies = instances_matching_gt(enemy, "my_health", 0);
// targeting
if(array_length(_enemies) > 0){
    var n = 0;
    for (i = 0; i < array_length(_enemies); i++){
        if(instance_exists(_enemies[i])){
            if(!collision_line(x, y, _enemies[i].x, _enemies[i].y, Wall, false, true)){
                _seen[n] = _enemies[i];
                n++;
            }
        }
    }
}

if(array_length(_seen) > 0){
    curdist = 100000;
    for (i = 0; i < array_length(_seen); i++){
        if(instance_exists(_seen[i])){
            dist = point_distance(x,y, _seen[i].x,_seen[i].y)
            if(dist < curdist){
                curdist = dist;
                _e = _seen[i];
            }
        }
    }
}

var _p = instance_nearest(x, y, Player);
if(distance_to_object(_p) < 60){
	if(host = 0){
		host = 1;
		gunangle = random_range(-20, 180);
		sound_play_pitchvol(sndSwapMotorized, 1.7, 0.8);
		sound_play_pitchvol(sndDiscHit, 1.2, 0.6);
	}
	if(instance_exists(_e)){
		trg_x = _e.x;
		trg_y = _e.y;
		angDif = angle_difference(gunangle, point_direction(x,y,trg_x,trg_y));
		gunangle -= angDif * 0.3 * current_time_scale;
		
		if(abs(angDif) < 10){
			if(canshoot == true){
				if(weapon_is_melee(wep) == false){
					wep_fire();
				}else{
					if(point_distance(x,y,trg_x,trg_y) < 70){
						if(wepangle = 120){
							wepangle = 240;
						}
						else{
							wepangle = 120;
						}
						wep_fire();
					}
				}
			}
		}
	}
}
else{
	if(host = 1){
		host = 0;
		gunangle = random_range(270, 290);
		//sound_play_pitchvol(sndDiscHit, 0.8, 1);
		sound_play_pitchvol(sndBurn, 0.4, 1);
	}
}

fireDelay -= current_time_scale;

if(fireDelay > 0){
	canshoot = false;
} else{
	if(canshoot = false){
		canshoot = true;
		switch(weapon_get_type(wep)){
			case 0:
				sound_play_pitchvol(sndMeleeFlip, 1, 0.65);
				yscale *= -1;
			break;

			case 2:
				sound_play_pitchvol(sndShotReload, 1, 0.65);
				repeat(weapon_get_cost(wep)){
					with(instance_create(x,y,Shell)){
						sprite_index = sprShotShell;
                        speed = random_range(2.5,3.8);
						friction = 0.2;
						direction = other.gunangle + (90*other.yscale) + random_range(-15,15);
					}
				}
			break;

			case 3:
				sound_play_pitchvol(sndCrossReload, 1, 0.65);
			break;
		}
	}
}

if(weapon_is_melee(wep) == false){
	if(gunangle > 90 and gunangle < 270){
		yscale = -1;
	}
	else{
		yscale = 1;
	}
}

anim += current_time_scale;

gunangle = gunangle mod 360;

if(sign(gunangle) == -1) gunangle = 360;

wkick = lerp(wkick, 0, 0.1);

} else {instance_destroy();}

#define sentry_hurt(damage, kb_vel, kb_dir)
if(nexthurt < current_frame){
	my_health -= argument0;
	motion_add_ct(argument2, argument1);
	nexthurt = current_frame + 3;
	sound_play_pitchvol(sndHitMetal,random_range(0.3,0.5),0.7);
	sound_play_pitchvol(sndDiscBounce,random_range(0.3,0.5),0.3);
	sound_play_pitchvol(sndHydrantBreak,random_range(1.5,1.7),0.7);
	sound_play_pitchvol(sndSwapCursed,random_range(0.5, 0.7),0.5);
}

#define sentry_destroy
with(instance_create(x,y,WepPickup)){
	wep = other.wep;
	curse = true;
	rotation = other.gunangle;
	direction = other.direction;
	speed = random_range(3,5);
}
sound_play_pitchvol(sndHydrantBreak,random_range(0.4,0.6),0.7);
sound_play_pitchvol(sndCrownRandom,random_range(0.4,0.6),0.3);
sound_play_pitchvol(sndCursedPickup,random_range(0.4,0.6),0.5);

repeat(8){
	with(instance_create(x + random_range(-5,5), y + 8 - random(5), Curse)){
		image_index = 4;
		image_angle = 180 + random_range(-15,15);
		direction = 90 + random_range(-30,30);
		speed = random_range(1,3);
	}
}

with(instance_create(x,y + 16,Corpse)){
	sprite_index = global.sprStandDead;
	friction = 0.8;
	speed = other.speed;
	direction = other.direction;
	size = 1;
}

// #define draw_dark
// with(instances_matching(CustomHitme, "name", "sentry")){
// 	flicker = random_range(-1,1);
// 	draw_set_color(merge_color(merge_color(c_green,c_black, 0.7), c_white, 0.3));
// 	draw_circle(x,y, 72 + (wkick*3) + flicker, false);
// 	// draw_set_color(merge_color(merge_color(c_green,c_black, 0.6), c_white, 0.2));
// 	// draw_circle(x,y, 48 + (wkick*3) + flicker, false);
// 	// draw_set_color(merge_color(merge_color(c_green,c_black, 0.5), c_white, 0.1));
// 	// draw_circle(x,y, 24 + (wkick*3) + flicker, false);
// }

#define draw_dark
oldAlpha = draw_get_alpha();

with(instances_matching(CustomHitme, "name", "sentry")){
	flicker = random_range(-1,1);
	draw_set_alpha(0.3)
	draw_set_color(merge_color(c_green,c_black, 0.7));
	draw_circle(x,y, 72 + (wkick*3) + flicker, false);

	draw_set_alpha(0.5)
	draw_set_color(merge_color(c_green,c_black, 0.6));
	draw_circle(x,y, 48 + (wkick*3) + flicker, false);

	draw_set_alpha(1)
	draw_set_color(merge_color(c_green,c_black, 0.5));
	draw_circle(x,y, 24 + (wkick*3) + flicker, false);
}
draw_set_alpha(oldAlpha);

#define draw_tooltips(whoami)
with(whoami){
	if(instance_exists(nearplayer)){
		a = 999;
		if(weapon_get_type(wep) == 1){
			full = floor((1-(a/255)) * 7);
		} else {
			full = floor((1-(a/55)) * 7);
		}
		icon = global.icons[weapon_get_type(wep)];
		iconB = global.iconsBG[weapon_get_type(wep)];
		draw_sprite(sprEPickup, 0, x, y - 7);
		draw_sprite(iconB, 2, x + 7, y - 21);
		draw_sprite(icon, full, x + 7, y - 21);
		draw_set_halign(fa_center);
		draw_text_nt(x, y - 31, weapon_get_name(wep));
	}
}
instance_destroy();


#define instance_nearest_sentry(x, y)
var _x = x;
x -= 10000000;
var _inst = instance_nearest(_x, y, CustomHitme);

x = _x;
if (_inst != noone){
	if(_inst.name = "sentry") return _inst;
}
return noone;

#define create_sentry(x,y, w)
sentry = instance_create(x, y, CustomHitme);
with(sentry){
	name = "sentry";
	creator = other;
	maxhealth = 12;
	my_health = maxhealth;
	wep = w;
	sprite_index = weapon_get_sprt(wep);
	yscale = 1;
	if("rotation" in other)	{gunangle = other.rotation;}
		else if("gunangle" in other) {gunangle = other.gunangle;}
		else gunangle = 0;
	if(weapon_is_melee(wep)){
			if("right" in other) {wepangle = 120 + (120*other.right);}
		} else {wepangle = 0;}
	mask_index = global.mskStand;
	spr_shadow = shd24;
	spr_shadow_y = 12;
	depth = 0.5 - (y * 0.0000001);
	team = 2;
	bob = irandom(1000);
	x2 = x;
	on_step = script_ref_create(sentry_step);
	on_draw = script_ref_create(sentry_draw);
	on_hurt = script_ref_create(sentry_hurt);
	on_destroy = script_ref_create(sentry_destroy);
	todraw = self;
	friction = 0.95;
	fireDelay = 30;
	anim = 0;
	wkick = 0;
	canshoot = false;
	height = -20;
	_e = noone;
	nearplayer = noone;
	sound = 0;
	nexthurt = current_frame;
	trg_x = x;
	trg_y = y;
	curse = false;
	creator = other;
	host = 0;

	sound_play_pitchvol(sndClick, 0.15 + random_range(-0.1,0.1), 0.25);
	sound_play_pitchvol(sndCursedPickup, 0.7 + random_range(-0.1,0.1), 0.45);
	sound_play_pitchvol(sndBigGeneratorHurt, 0.4 + random_range(-0.1,0.1), 0.65);
}

return sentry;

#define wep_fire
var _w = sprite_get_width(weapon_get_sprite(wep)) / 4;
player_fire_ext(gunangle, wep, x + lengthdir_x(_w, gunangle), y + lengthdir_y(_w, gunangle), team, self);
wkick = 4 + min(4, weapon_get_load(wep)/3);
fireDelay = weapon_get_load(wep);

#define sentry_refund
with(instance_create(x,y,WepPickup)){
	wep = other.wep;
	curse = other.curse;
}
wtype = weapon_get_type(wep);
repeat(12) instance_create(x + random_range(-2,2), y  + random(16), Dust);
sound_play_pitchvol(sndCursedReminder, random_range(1.7,1.9), 1);
sound_play_pitchvol(sndCursedPickupDisappear, random_range(0.3,0.5), 1);
sound_play_pitchvol(sndHitMetal, random_range(0.3,0.5), 0.65);
instance_delete(self);