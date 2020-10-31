#define init
// global.sprGas = sprite_add_base64("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", 8, 24, 48);
// global.sprGas = sprRevive;
global.sprGas = sprite_add_base64("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", 8, 24, 48);
global.sprSkull = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAAcAAAAFCAYAAACJmvbYAAAAAXNSR0IArs4c6QAAAC5JREFUCJljZGBgYPj///9/BjTAyMjIyIhNAgaYGBgYGErEUQVhfLw6GZDtRKcBy1UZCLtpzLUAAAAASUVORK5CYII=", 1, 4, 2);

#define game_start

#define step
if("rev_cooldown" not in self){rev_cooldown = 0;}
if(rev_cooldown <= 0){
	if(button_pressed(index, "spec")){
		// if mouse on floor inside boundaries
		if!(collision_point(mouse_x[index], mouse_y[index] - 8, Wall, false, true)){
			if(collision_point(mouse_x[index], mouse_y[index] - 8, Floor, false, true)){
				weapon_post(5, 0, 0);
				// create revive area
				SpawnRevive(mouse_x[index], mouse_y[index], "big");
			rev_cooldown = 15;
			}
		} else {
			rev_cooldown = 0;	// refund reload upon clicking outside border/wall
		}
	}
} else {
	rev_cooldown -= current_time_scale;
}

if("ultra_timer" not in self){
	ultra_timer = 15;
} else {
	ultra_timer -= current_time_scale * ultra_get(race, 2);
}

if(ultra_timer <= 0){
	corpse_list = instances_matching_ge(Corpse, "size", 0);
	if(array_length(corpse_list) > 0){
		target_corpse = corpse_list[irandom(array_length(corpse_list) - 1)];
	} else {
		target_corpse = noone;
	}
	if(instance_exists(target_corpse)){
		if(abs((view_xview[index] + game_width/2) - target_corpse.x) < game_width/2 and
			abs((view_yview[index] + game_height/2) - target_corpse.y) < game_height/2 and
			target_corpse.speed < 1){
				//successful
				SpawnRevive(target_corpse.x,target_corpse.y,"smol");
				ultra_timer = irandom_range(300,600);
		} else {
			//unsuccessful, retry
			ultra_timer = 15;
		}
	}
	
}

#define gas_step
with(enemy){
	if(place_meeting(x,y,other)){		
		if(team != other.team){
			if(nexthurt <= current_frame){
				projectile_hit(self, 0, 1, other.direction);
				ApplyPoison(self);
			}
		}
	}
}

with(prop){
	if(place_meeting(x,y,other)){		
		if(team == 0){
			if(nexthurt <= current_frame){
				projectile_hit(self, 0, 0);
				ApplyPoison(self);
			}
		}
	}
}

if(ceil(image_index) >= 8){
	instance_destroy();
}

#define poison_debuff_step
if(instance_exists(target)){
	if(active){
		if(object_is_ancestor(target.object_index, becomenemy) == false){
			x = target.x;
			y = target.y;
			depth = target.depth - 0.1;
			if(timer <= 0){
				dmg = min(ticks,2);
				
				snd = choose(sndFrogEggSpawn1,sndFrogEggSpawn2,sndFrogEggSpawn3);
				projectile_hit_raw(target, dmg, 0);
				nexthurt = current_frame;
				sound_play_pitchvol(sndOasisCrabAttack, (1.3 + (ticks/15)), 0.25);
				sound_play_pitchvol(sndNothingFire, (1.5 + (ticks/15)), 0.1);
				sound_play_pitchvol(sndNothingSmallball, (0.5 + (ticks/15)), 0.05);
				sound_play_pitchvol(snd, (1.5 + (ticks/15)), 0.15);
				sound_play_pitchvol(sndSnowBotHurt, (2.5 + (ticks/15)), 0.15);
				repeat(ticks){
					// with(instance_create(x + random_range(-1 * sprite_get_width(target.sprite_index)/2, sprite_get_width(target.sprite_index)/2),y + random_range(-16,16),Curse)){
					with(instance_create(x,y,Curse)){
						direction = 90 + random_range(-60,60);
						image_angle = direction - 90;
						speed = random_range(4,6);
						image_index = 4;
						friction = random_range(0.2,0.6);
					}
				}
				ticks -= 1;
				timer = min(20 - ticks, 15);
			} else {
				timer -= current_time_scale;
			}
		}
	}
	
	if(ticks > 0) {
		active = true;
	} else {
		active = false;
	}

} else {
	instance_destroy();
}


#define poison_debuff_draw
if(instance_exists(target) and active){
	if(object_is_ancestor(target.object_index, becomenemy) == false){
		with(target){
			if("z" not in self){z = 0;}
			if("right" not in self){right = image_xscale;}
			d3d_set_fog(true, merge_color(c_purple, c_fuchsia, other.ticks/20), 0, 0);
			
			if("drawspr" in self and "drawimg" in self){
				draw_sprite_ext(drawspr, drawimg, x, y - z, right, image_yscale, image_angle, c_white, 0.25 + other.ticks/40);
			} else {
				draw_sprite_ext(sprite_index, image_index, x, y - z, right, image_yscale, image_angle, c_white, 0.25 + other.ticks/40);
			}

			draw_sprite_ext(global.sprSkull, 1, x, y - z - 16 + 2, 1, 1, 0, c_purple, 1-other.timer/10);

			d3d_set_fog(false, c_purple, 0, 0);
			
			draw_sprite_ext(global.sprSkull, 1, x, y - z - 16, 1, 1, 0, c_white, 1-other.timer/10);
		}
	}
}

#define weapon_name
return "NECRO GUN";

#define weapon_sprt
return sprNecrogun;

#define weapon_type
return 0;	// "melee"

#define weapon_auto
return true;

#define weapon_load
return 18;	// reload

#define weapon_cost
return 0;	// no ammo cost

#define weapon_area
return -1;	// never drop

#define weapon_swap
return sndSwapEnergy;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return "RISE FROM YOUR GRAVE";

#define weapon_fire

weapon_post(4.5, 4, 2);	// weapon kick and screen shake
// sound_play_pitchvol(sndPopgun, random_range(0.25,0.35), 0.35);
sound_play_pitchvol(sndToxicBoltGas, random_range(1.25,1.35), 0.25);
sound_play_pitchvol(sndSwapCursed, random_range(1.8,1.9), 0.35);
sound_play_pitchvol(sndFastRatExpire, random_range(0.6,0.8), 0.45);
with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), CustomObject){
	name = "NecroGas";
	creator = other;
	team = creator.team;
	sprite_index = global.sprGas;
	image_speed = 0.4;
	image_index = 1;
	direction = other.gunangle + random_range(-5,5);
	image_angle = direction - 90;
	image_blend = c_fuchsia;
	friction = 0.7;
	speed = 8;
	depth = -2.2;
	on_step = script_ref_create(gas_step);
}

for(i = -2; i < 3; i++){
	with instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), Curse){
		direction = other.gunangle + other.i * 10;
		image_angle = direction - 90;
		speed = random_range(7,8);
		// image_blend = c_gray;
		image_blend = make_color_hsv(0,0,180);
		friction = random_range(0.4,0.7);
	}
}


#define revarea_step
// alarm management
alarm[0]-= current_time_scale;
// right before destruction
if(alarm[0] <= 0){
	SpawnFreak();
	instance_destroy();
}

#define revarea_destroy
// play sound if prompted
if(rev = true){
	sound_play(sndNecromancerRevive);
}
numparts = random_range(radius/2,radius);
for (i = 0; i < numparts; i++){
	with(instance_create(x + lengthdir_x(radius, (360/numparts)*i),y + lengthdir_y(radius, (360/numparts)*i),CustomObject)){
		direction = 90;
		speed = random_range(4,6);
		friction = random_range(0.2,0.7);
		image_blend = c_purple;
		sprite_index = sprSweat;
		image_index = irandom(image_number);
		image_speed = 0;
		a = choose(3,4,5);
		on_step = script_ref_create(part_step);
	}
}

#define part_step
image_alpha -= a/room_speed;
if(image_alpha<=0) instance_destroy();

#define freak_step
if(my_health > 0){
	// speed management
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	_f = instance_place(x,y,Floor);
	if(instance_exists(_f)){
		friction = lerp(friction, _f.traction, 0.5);
	}

	// collision
	move_bounce_solid(true);
	
	if (nexthurt > current_frame and current_frame > fresh){
		if (sprite_index != spr_hurt){
			sprite_index = spr_hurt;
		}
	} else {
		if (speed != 0){
			sprite_index = spr_walk;
		} else {
			sprite_index = spr_idle;
		}
	}
	
	// face right or left
	if(right = 1){
		image_xscale = 1;
	}
	else{
		image_xscale = -1;
	}
	if(direction > 90 and direction <= 270){
		right = -1;
	}
	else{
		right = 1;
	}

	// targeting
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
	if(target = noone){	// no target, random movement
		if(alarm[0] <= 0){
			dir = random(360);
			move_bounce_solid(true);
			motion_add_ct(direction, maxspeed);
			maxtimer = irandom_range(60, 100);
			relax = choose(2,3,4);
			alarm[0] = maxtimer;
		}
	}
	else{
		if(alarm[0] <= 0){	// target, persue
			dir = point_direction(x, y, target.x, target.y) + random_range(-50, 50);
			move_bounce_solid(true);
			motion_add_ct(direction, maxspeed);
			maxtimer = irandom_range(20, 30);
			relax = 10;
			alarm[0] = maxtimer;
		}
	}

	if(alarm[0] >= maxtimer/relax){
		motion_add_ct(dir, maxspeed/4);
	}

	if(place_meeting(x + (dcos(direction) * 8), y - (dsin(direction) * 8), Wall)){
		newd = choose(-90, 90);
		direction += newd;
		
		dir += newd;
		speed /= 2;
	}
		
	// alarm management
	for(i = 0; i < array_length_1d(alarm); i++){
		if(alarm[i] >= 0){
			alarm[i] -= current_time_scale;
		}
	}

	if(instance_exists(grandcreator) and instance_is(grandcreator, Player)){
		wantpois = ultra_get(grandcreator.race, 1);
	} else {wantpois = 0;}

	// incoming/outgoing contact damage
	with(collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, enemy, 0, 1)){
		if(nexthurt <= current_frame){
			projectile_hit(self, other.my_damage, 4, other.direction);
			sound_play_pitchvol(sndFreakMelee, random_range(0.9,1.1), 0.25);
				//with poison
				if(other.wantpois){ApplyPoison(self);}
		}
		
		if(meleedamage > 0){
			if(other.nexthurt <= current_frame and nexthurt < current_frame + 3){
				sound_play_pitchvol(snd_mele, random_range(0.9,1.1), 0.35);
				projectile_hit(other, meleedamage, 4, direction);
			}
		}
	}
}
else{
	instance_destroy();
}

#define necromancer_step
if(my_health > 0){
	// speed management
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	_f = instance_place(x,y,Floor);
	if(instance_exists(_f)){
		friction = lerp(friction, _f.traction, 0.5);
	}
	
	// collision
	move_bounce_solid(true);
	
	if (nexthurt > current_frame){
		if (sprite_index != spr_hurt){
			sprite_index = spr_hurt;
		}
	} else {
		if (speed != 0){
			sprite_index = spr_walk;
		} else {
			sprite_index = spr_idle;
		}
	}
	
	// face right or left
	image_xscale = right;

	if(gunangle > 90 and gunangle <= 270){
		right = -1;
	}
	else{
		right = 1;
	}

	//weapon shit
	wkick = max(0, wkick - current_time_scale);

	_c = instance_nearest(x, y, Corpse);
	_e = instance_nearest(x, y, enemy);

	if(instance_exists(enemy)){
		if(distance_to_object(_e) < 150 and !collision_line(x, y, _e.x, _e.y, Wall, true, true)){
			mode = "flee";
			if(alarm[0] <= 0){
				maxtimer = random_range(15,25);
				relax = choose(3,4,5);
				alarm[0] = maxtimer;
				dir = point_direction(_e.x,_e.y,x,y);
			}

		} else {
			if(alarm[0] <= 0){
				mode = "wander";
				dir = 90 * (irandom(3));
			}
		}
	} else {
		mode = "wander";
	}


	if(alarm[0] <= 0){
		maxtimer = random_range(40,70);
		relax = choose(3,4,5);
		changedir = false;
		alarm[0] = maxtimer;
		
		gunangle = direction + (random_range(10,45) * choose(-1,1));
	}
	
	if(alarm[0] >= maxtimer/relax and wkick<=0){

		if(place_meeting(x + (dcos(direction) * 8), y - (dsin(direction) * 8), Wall)){
			newd = choose(-90, 90);
			direction += newd;
			
			dir += newd;
			speed /= 2;
			
			gunangle = direction + (random_range(10,45) * choose(-1,1));
		}

		switch(mode){
			case "flee":
				motion_add_ct(dir, maxspeed/3);

				if(random(100*current_time_scale) < 10*current_time_scale){
					instance_create(x,y,Sweat);
				}
				
			break;

			case "wander":
				motion_add_ct(dir, maxspeed/4);

				if(random(100*current_time_scale) < 3*current_time_scale and changedir == false){
					dir += choose(90 * (irandom(3)), random(360));
					changedir = true;
				}

				if(alarm[1] <= 0){ //fire
					if(instance_exists(_c)){
						if(distance_to_object(_c) < 225 and !collision_line(x, y, _c.x, _c.y, Wall, true, true) and _c.speed < 1){
							SpawnRevive(_c.x,_c.y, "big");
							wkick = 15;
							gunangle = point_direction(x,y,_c.x,_c.y);
							direction = gunangle;
							speed /= 4;							
							alarm[1] = random_range(90, 270);							
						}
					}
				}
			break;
		}
	}
			
	// alarm management
	for(i = 0; i < array_length_1d(alarm); i++){
		if(alarm[i] >= 0){
			alarm[i]-= current_time_scale;
		}
	}

	// incoming contact damage
	with(collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, enemy, 0, 1)){
		if(meleedamage > 0){
			if(other.nexthurt <= current_frame){
				sound_play_pitchvol(snd_mele, random_range(0.9,1.1), 0.35);
				projectile_hit(other, meleedamage, 4, direction);
			}
		}
	}

	_wStuck = instance_place(x,y,Wall);
	if(instance_exists(_wStuck)){
		motion_add_ct(point_direction(_wStuck.x + 8, _wStuck.y + 8, x, y), 1);
	}
}
else{
	instance_destroy();
}

#define necromancer_draw

if(gunangle >= 0 and gunangle <= 180){

	d3d_set_fog(1, playerColor, 0, 0);
	// gun outline
	draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick/2, gunangle) - 1, y - lengthdir_y(wkick/2, gunangle), 1, right, gunangle, playerColor, 1);
	draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick/2, gunangle) + 1, y - lengthdir_y(wkick/2, gunangle), 1, right, gunangle, playerColor, 1);
	draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick/2, gunangle), y - lengthdir_y(wkick/2, gunangle) - 1, 1, right, gunangle, playerColor, 1);
	draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick/2, gunangle), y - lengthdir_y(wkick/2, gunangle) + 1, 1, right, gunangle, playerColor, 1);
	d3d_set_fog(0,c_lime,0,0);
	// draw gun
	draw_sprite_ext(weapon_get_sprite(wep), 0, x - lengthdir_x(wkick/2, gunangle), y - lengthdir_y(wkick/2, gunangle), 1, right, gunangle, c_white, 1);

	draw_self();
} else {
	draw_self();
d3d_set_fog(1, playerColor, 0, 0);
	// gun outline
	draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick/2, gunangle) - 1, y - lengthdir_y(wkick/2, gunangle), 1, right, gunangle, playerColor, 1);
	draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick/2, gunangle) + 1, y - lengthdir_y(wkick/2, gunangle), 1, right, gunangle, playerColor, 1);
	draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick/2, gunangle), y - lengthdir_y(wkick/2, gunangle) - 1, 1, right, gunangle, playerColor, 1);
	draw_sprite_ext(weapon_get_sprite(wep), -1, x - lengthdir_x(wkick/2, gunangle), y - lengthdir_y(wkick/2, gunangle) + 1, 1, right, gunangle, playerColor, 1);
	d3d_set_fog(0,c_lime,0,0);
	// draw gun
	draw_sprite_ext(weapon_get_sprite(wep), 0, x - lengthdir_x(wkick/2, gunangle), y - lengthdir_y(wkick/2, gunangle), 1, right, gunangle, c_white, 1);
}

#define custom_hitme_destroy
// make corpse
sound_play_pitchvol(snd_dead, random_range(0.9,1.1), 0.6);
with(instance_create(x, y, Corpse)){
	sprite_index = other.spr_dead;
	if(other.name == "freak") freak_nerf = true;
	speed = other.speed;
	direction = other.direction;
	size = 1;
}

#define custom_hitme_hurt(damage, kb_vel, kb_dir)
// incoming damage
sound_play_pitchvol(snd_hurt,random_range(0.9,1.1),0.4);
my_health -= argument0;
motion_add_ct(argument2, argument1);
nexthurt = current_frame + 6;
sprite_index = spr_hurt;
image_index = 0;

#define SpawnFreak()
	if(instance_exists(enemy) or instance_exists(Portal)){	// no softlock
		with(Corpse){
			// if corpse in range
			if(point_distance(x,y,other.x,other.y - ((other.radius div 32) * 2)) < other.radius + 2){
				o = other;	// other is revive circle
				o.rev = true;	// prompt to make noise
				// make freak from corpse
				with(instance_create(x, y, CustomHitme)){
					creator = other.o;	// revive circle
					grandcreator = creator.creator;	// player

					switch(creator.bigness){
						case "big":
							name = "freak";

							//sprites
							spr_idle = sprFreak1Idle;
							spr_walk = sprFreak1Walk;
							spr_hurt = sprFreak1Hurt;
							spr_dead = sprFreak1Dead;

							//sounds
							snd_hurt = sndFreakHurt;
							snd_dead = sndFreakDead;
							
							if("freak_nerf" in other){
								maxhealth = 1;
								my_health = maxhealth;
								my_damage = 1;
								image_blend = make_color_hsv(0, 0, 200);
							}else{
								maxhealth = 7;
								my_health = maxhealth;
								my_damage = 3;
							}

							mask_index = mskFreak;
							fresh = current_frame + 15;
							
							alarm = [0];	// movement/targeting alarm

							on_step = script_ref_create(freak_step);

						break;

						case "smol":
							name = "necro";

							// sprites
							spr_idle = sprNecromancerIdle;
							spr_walk = sprNecromancerWalk;
							spr_hurt = sprNecromancerHurt;
							spr_dead = sprNecromancerDead;

							// sounds
							snd_hurt = sndNecromancerHurt;
							snd_dead = sndNecromancerDead;
							mask_index = mskRat;

							maxhealth = 6;
							my_health = maxhealth;
							
							alarm = [irandom_range(10,25), irandom_range(45,75)];	// one's the movement alarm, the other's the revive alarm. capiche?

							_e = noone;
							mode = "wander";
							friction = 0.4;
							relax = choose(3,4,5);
							changedir = false;
							
							wep = "necromancer";
							wkick = 0;
							gunangle = random(360);

							_wStuck = noone;
							wall_stuck = 0;

							on_step = script_ref_create(necromancer_step);
							on_draw = script_ref_create(necromancer_draw);

						break;	
					}

					team = creator.team;

					dir = random(360);
					maxtimer = 0;

					sprite_index = spr_idle;
					maxspeed = 3.6;
					size = 5;
					image_speed = 0.4;
					spr_shadow = shd24;
					direction = random(360);
					right = choose(-1, 1);
					
					on_hurt = script_ref_create(custom_hitme_hurt);
					on_destroy = script_ref_create(custom_hitme_destroy);
					
					playerColor = creator.playerCol; //player color inherited from circle

					with(script_bind_draw(0, 0)){
						script = script_ref_create_ext("mod", "erace", "draw_outline", other.playerColor, other);
					}
					_w = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, Wall, false, true);
					if(instance_exists(_w)){
						with(_w){
							instance_create(x,y,FloorExplo);
							instance_destroy();
						}
						
					}
				}
				// effects and corpse destruction
					with(instance_create(x, y, ReviveFX)){						
						if("spr_revive" in other.o){sprite_index = other.o.spr_revive;} // sprNecroRevive
						playerCol = other.o.playerCol;
						with(script_bind_draw(0, depth+0.1)){
							script = script_ref_create_ext("mod", "erace", "draw_outline", other.playerCol, other);
						}
					}
				instance_destroy();
			}
		}
	}

#define ApplyPoison(trg)
with(trg){
	if("poison_debuff" not in self){
		poison_debuff = instance_create(x,y,CustomObject);
		with(poison_debuff){
			image_blend_orig = other.image_blend;
			target = other;
			active = true;
			ticks = 2;
			timer = 15;
			depth = -2.1;
			on_step = script_ref_create(poison_debuff_step);
			on_draw = script_ref_create(poison_debuff_draw);
		}
	} else {
		with(poison_debuff){
			ticks = min(ticks + 2, 15);
		}
	}
}

#define SpawnRevive(_x, _y, _bigness)
	with(instance_create(_x, _y, CustomObject)){
		name = "revarea";
		creator = other;
		team = creator.team;
		if(instance_is(other, Player)){
			playerCol = player_get_color(creator.index);
		} else {
			if("playerColor" in other){
				playerCol = other.playerColor;
			} else {
				playerCol = c_black;
			}
		}
		bigness = _bigness;
		switch(bigness){
			case "big":
				sprite_index = sprReviveArea;
				alarm = [50];	// time til revive occurs
				spr_revive = sprRevive;
				image_speed = 0.4;
				radius = 32;
			break;

			case "smol":
				sprite_index = sprNecroReviveArea;
				alarm = [15];	// time til revive occurs
				spr_revive = sprNecroRevive;
				image_speed = 0.4;
				radius = 16;
			break;
		}
		rev = false;	// noise prompt

		on_step = script_ref_create(revarea_step);
		on_draw = script_ref_create(revarea_draw);
		on_destroy = script_ref_create(revarea_destroy);
	}

#define revarea_draw
alpha_orig = draw_get_alpha();
draw_set_alpha(0.75);
d3d_set_fog(true, make_color_hsv(color_get_hue(playerCol), 255, 255), 0, 0);
draw_sprite(sprite_index, image_index, x,y+1);
draw_sprite(sprite_index, image_index, x,y-1);
d3d_set_fog(false, playerCol,0, 0);

draw_set_alpha(alpha_orig);

draw_sprite(sprite_index, image_index, x,y);