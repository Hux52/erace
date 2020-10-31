#define init

isDashing = false;

#define game_start

#define step

if("timer" not in self) timer = 0;
if("charged" not in self) charged = false;
if("flash" not in self) flash = 0;
if("rl" not in self) rl = 0;

script_bind_draw("laser_draw", depth);

if(rl > 0) rl -= current_time_scale;

if(timer > 35){
	if(charged == false) {
		sound_play_pitchvol(sndSwapPistol, 2.5, 0.15);
		sound_play_pitchvol(sndSwapBow, 2.5, 0.15);
		sound_play_pitchvol(sndShotReload, 3.5, 1);
		charged = true;
		flash = 3;
	}
} else {
	charged = false;
}

if(flash > 0) flash -= current_time_scale;

ang = max(1, 150/timer - 1);

if(rl <= 0){
	firing = button_check(index, "fire");

	if(button_released(index,"fire")){
		if(timer > 10){
			if(charged == false){ //normal
				weapon_post(8, -5, 5);	// weapon kick and screen shake
				sound_play_pitchvol(sndSniperFire, random_range(0.9,1.1), 0.65);
				sound_play_pitchvol(sndShotgun, random_range(1.9,2.1), 0.45);
				
				for (i = -1; i < 2; i++){
					with(instance_create(x + lengthdir_x(4, gunangle), y + lengthdir_y(4, gunangle), Bullet1)){
						creator = other;
						team = creator.team;
						direction = creator.gunangle + (creator.i*creator.ang);
						image_angle = direction;
						speed = 20;
						friction = 0;
						damage = 3;
					}
				}
			} else { //power shot
				weapon_post(10, -5, 35);	// weapon kick and screen shake
				sound_play_pitchvol(sndSniperFire, random_range(1.1,0.9), 0.65);
				sound_play_pitchvol(sndGoldCrossbow, random_range(0.3,0.5), 0.35);
				sound_play_pitchvol(sndCrossbow, random_range(1.7,1.5), 0.45);
				sound_play_pitchvol(sndStatueXP, random_range(0.5,0.5), 0.25);
				sound_play_pitchvol(sndStatueHurt, random_range(2.5,2.7), 0.45);
				for (i = -1; i < 2; i++){
					with(instance_create(x + lengthdir_x(4, gunangle), y + lengthdir_y(4, gunangle), HeavyBullet)){
						creator = other;
						team = creator.team;
						direction = creator.gunangle + (creator.i*creator.ang);
						image_angle = direction;
						speed = 25;
						friction = 0;
						damage = 7;
					}
				}
			}
			
			flash = 0;
		}
		rl = 10 - (charged*5);
	}
}

if(firing){
	view_pan_factor[index] = max(2.8, 3.8 - (timer/35));
	if(timer == 0){
		if(isDashing){
			sound_play_pitchvol(sndSniperTarget, random_range(1.6,1.8), 0.65);
			sound_play_pitchvol(sndCrossReload, random_range(2,2.2), 0.95);
		} else {
			sound_play_pitchvol(sndSniperTarget, random_range(0.9,1.1), 0.65);
		}
	}
	timer += current_time_scale * 1 + (isDashing * 5);
} else {
	timer = 0;
	view_pan_factor[index] = 4;
}

laser_alpha = 1/30 * timer;

#define laser_draw
with(instances_matching(Player, "race", "sniper")){
	oldAlpha = draw_get_alpha();
	oldColor = draw_get_color();
	if(firing){
		draw_set_alpha(laser_alpha);
		if(flash){
			draw_set_color(c_white);
		} else {
			draw_set_color(merge_color(c_red,c_orange, 0.5 - (charged*0.5)));
		}

		for(i = -1; i < 2; i++){
			draw_lasersight(x + lengthdir_x(4, gunangle), y + lengthdir_y(4, gunangle),gunangle + (i*ang),900,0.75 + (charged*0.5));
		}	
	}
	draw_set_alpha(oldAlpha);
	draw_set_color(oldColor);
}


instance_destroy();

#define weapon_name
return "SNIPER RIFLE";

#define weapon_sprt
return sprSniperGun;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 30;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapHammer;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return "IN MY SIGHTS";

#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)
    var _sx = _x,
        _sy = _y,
        _lx = _sx,
        _ly = _ly,
        _md = _maxDistance,
        d = _md,
        m = 0; // Minor hitscan increment distance

    while(d > 0){
         // Major Hitscan Mode (Start at max, go back until no collision line):
        if(m <= 0){
            _lx = _sx + lengthdir_x(d, _dir);
            _ly = _sy + lengthdir_y(d, _dir);
            d -= sqrt(_md);

             // Enter minor hitscan mode:
            if(!collision_line(_sx, _sy, _lx, _ly, Wall, false, false)){
                m = 2;
                d = sqrt(_md);
            }
        }

         // Minor Hitscan Mode (Move until collision):
        else{
            if(position_meeting(_lx, _ly, Wall)) break;
            _lx += lengthdir_x(m, _dir);
            _ly += lengthdir_y(m, _dir);
            d -= m;
        }
    }

    draw_line_width(_sx, _sy, _lx, _ly, _width);

return [_lx, _ly];