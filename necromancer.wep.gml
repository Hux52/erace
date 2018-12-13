#define init

#define game_start

#define step

#define weapon_name
return "NECRO GUN";

#define weapon_sprt
return sprNecrogun;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 58;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapEnergy;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return "RISE FROM YOUR GRAVE";

#define weapon_fire
if!(collision_point(mouse_x[index], mouse_y[index] - 8, Wall, false, true)){
	if(collision_point(mouse_x[index], mouse_y[index] - 8, Floor, false, true)){
		weapon_post(5, 0, 0);
		with(instance_create(mouse_x, mouse_y, CustomProjectile)){
			name = "revarea";
			creator = other;
			team = creator.team;
			sprite_index = sprReviveArea;
			mask_index = mskReviveArea;
			image_speed = 0.5;
			alarm = [50];
			rev = false;
			on_wall = script_ref_create(revarea_wall);
			on_hit = script_ref_create(revarea_hit);
			on_step = script_ref_create(revarea_step);
			on_destroy = script_ref_create(revarea_destroy);
		}
	}
}
else{
	reload = 0;
}

#define revarea_wall
// nothing

#define revarea_hit
// nothing

#define revarea_step
alarm[0]--;
if(alarm[0] = 1){
	with(Corpse){
		if(place_meeting(x, y, other)){
			o = other;
			o.rev = true;
			with(instance_create(x, y, CustomHitme)){
				name = "freak";
				creator = other.o;
				grandcreator = creator.creator;
				team = creator.team;
				spr_idle = sprFreak1Idle;
				spr_walk = sprFreak1Walk;
				spr_hurt = sprFreak1Hurt;
				spr_dead = sprFreak1Dead;
				sprite_index = spr_idle;
				my_health = 7;
				maxspeed = 3.6;
				mask_index = mskFreak;
				size = 1;
				image_speed = 0.3;
				spr_shadow = shd24;
				direction = random(360);
				move_bounce_solid(true);
				my_damage = 3;
				right = choose(-1, 1);
				alarm = [0];	// 7 - 10
				on_step = script_ref_create(freak_step);
				on_hurt = script_ref_create(freak_hurt);
				on_destroy = script_ref_create(freak_destroy);
				playerColor = player_get_color(grandcreator.index);
				toDraw = self;
				script_bind_draw(draw_outline, depth, playerColor, toDraw);
			}
			instance_create(x, y, ReviveFX);
			instance_destroy();
		}
	}
}

if(alarm[0] <= 0){
	instance_destroy();
}

#define revarea_destroy
if(rev = true){
	sound_play(sndNecromancerRevive);
}

#define freak_step
if(my_health > 0){

	// speed
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	// collision stuff and variables
	move_bounce_solid(true);
	
	// sprite stuff
	if(speed > 0 and sprite_index != spr_hurt){
		sprite_index = spr_walk;
	}
	else if(sprite_index != spr_hurt){
		sprite_index = spr_idle;
	}
	
	if(direction > 90 and direction <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
	
	// face right or left
	if(right = 1){
		image_xscale = 1;
	}
	else{
		image_xscale = -1;
	}


	// deciding what to target
	if(instance_exists(enemy)){
		var _e = instance_nearest(x, y, enemy);
		if(distance_to_object(_e) < 200 and !collision_line(x, y, _e.x, _e.y, Wall, true, true)){
			target = _e;
		}
		else{
			target = noone;
		}
	}
	else{
		target = noone;
	}

	// movement
	if(target = noone){
		if(alarm[0] = 0){
			direction = random(360);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			alarm[0] = irandom_range(10, 30);
		}
	}
	else{
		if(alarm[0] = 0){
			direction = point_direction(x, y, target.x, target.y) + random_range(-50, 50);
			move_bounce_solid(true);
			motion_add(direction, maxspeed);
			alarm[0] = irandom_range(30, 40);
		}
	}


	var _w = instance_nearest(x, y, Wall);
	/*if(collision_rectangle(_w.x, _w.y + 15, _w.x + 15, _w.y, self, false, false)){
		//trace("hit wall");		// debug
		var _f = instance_nearest(x, y, Floor);
		x = _f.x + 8;
		y = _f.y + 8;
	}*/

	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	// alarm management
	for(i = 0; i < array_length_1d(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]--;
		}
	}
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		with(instance_nearest(x, y, enemy)){
			if(sprite_index != spr_hurt){
				my_health -= other.my_damage;
				sound_play(snd_hurt);
				sound_play(sndFreakMelee);
				sprite_index = spr_hurt;
				if(meleedamage > 0){
					other.my_health -= meleedamage;
				}
			}
		}
	}
}
else{
	instance_destroy();
}

#define freak_destroy
with(instance_create(x, y, Corpse)){
	sprite_index = sprFreak1Dead;
	size = 1;
}

#define freak_hurt(damage, kb_vel, kb_dir)
if(sprite_index != spr_hurt){
	my_health -= argument0;
	motion_add(argument2, argument1);
	nexthurt = 3;
	sprite_index = spr_hurt;
}

#define draw_outline(playerColor, toDraw)
d3d_set_fog(1,playerColor,0,0);
if(instance_exists(toDraw)){
    with(toDraw){
        draw_sprite_ext(sprite_index, -1, x - 1, y, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x + 1, y, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y - 1, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y + 1, 1 * right, 1, 0, playerColor, 1);
    }
}
d3d_set_fog(0,c_lime,0,0);