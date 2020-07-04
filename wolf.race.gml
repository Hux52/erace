#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprWolfSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitWolf.png",1 , 5, 190);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Robotwolf.png", 1, 10, 10);
global.mskDeflect = sprite_add("sprites/mskDeflect.png", 1, 12, 12);
global.sprArrow = sprite_add("/sprites/arrow.png", 1, 6, 5);

// character select sounds
global.sndSelect = sndHalloweenWolf;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "wolf"){
			//sound_play_pitchvol(global.sndSelect,0.8,0.65);
			sound_play(sndWolfRoll);
		}
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprWolfIdle;
spr_walk = sprWolfWalk;
spr_hurt = sprWolfHurt;
spr_dead = sprWolfDead;
spr_fire = sprWolfFire; //rolling animation
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndWolfHurt;
snd_dead = sndWolfDead;

snd_roll = sndWolfRoll; //also for rolling
snd_mele = sndMaggotBite;

// stats
team = 2;
maxhealth = 12;
maxspeed_base = 3.1 + (skill_get(mut_extra_feet) * 0.5);
maxspeed = 3.1 + (skill_get(mut_extra_feet) * 0.5);
spr_shadow_y = 0;
melee_damage_base = 1;
melee_damage = 2;

// vars
melee = 1;	// can melee or not
is_rolling = false;
can_roll = true;
roll_cooldown = 0;
finished_roll = 0;
roll_time = 0;
roll_minimum = 15;
loop = noone;
bullets = 0;
firing = false;
fireDelay = 0;
flash = 0;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
footstep = 1;
script_bind_draw("wolf_draw", depth-1);
flash -= current_time_scale;
if(can_roll){
	if(button_pressed(index,"fire")){ //launch self
		d = gunangle; //set initial direction
		is_rolling = true;
		can_roll = false;
		canwalk = false;
		bullets = 0;
		maxspeed = 6 + (skill_get(mut_extra_feet) * 0.5);
		motion_set(gunangle, 1);
		melee_damage = 5;
		rSound = sound_play_pitchvol(snd_roll,random_range(0.9,1.1), 0.6);
		view_shake[index] = 6;
		shield = instance_create(x, y, CustomSlash);
		image_index = 0;
		with(CustomSlash){
			creator = other;
			team = creator.team;
			sprite_index = global.mskDeflect;
			visible = false;
			index = creator.index;
			can_deflect = 1;
			image_speed = 0;
			walled = false;
			txt = noone;
			on_step = script_ref_create(shield_step);
			on_wall = script_ref_create(shield_wall);
			on_hit = script_ref_create(shield_hit);
			on_projectile = script_ref_create(shield_projectile);
			on_grenade = script_ref_create(shield_grenade);
			on_end_step = script_ref_create(shield_end_step);
		}
	}
}

if(is_rolling){
	roll_time += current_time_scale;
	move_bounce_solid(true);

	if(button_check(index, "fire")){
		friction = 0.35;
		motion_add(direction - (angle_difference(direction,gunangle) * 0.7) , min(1,3/roll_time));

		//add momentum while attacking enemies
		motion_add(direction,smoke/18);
	} else {
		if(speed > 2) motion_add(direction - 180, speed/30);
		// friction = 1;
	}
	
	_f = instance_place(x,y,Floor);
	if(instance_exists(_f)){
		friction = lerp(friction, _f.traction, 0.5);
	}

	//sprite stuff	
	sprite_index = spr_fire;

	if(image_index >= 5 and image_index <= 6){
		image_index = 2;
	}
	if(image_index > 3 and image_index < 4){
		image_index = 4;
	}

	if(!audio_is_playing(loop)){
		loop = sound_play_pitchvol(sndSnowBotSlideLoop, max(0.8, speed/2), 1 - (speed/20));
	}

	if(audio_sound_get_track_position_nonsync(loop) >= 0.6){
		sound_stop(loop);
	}

	if(audio_sound_get_track_position_nonsync(rSound) >= 0.59){
		audio_pause_sound(rSound);
	}

	footstep = -1;

	if(place_meeting(x + hspeed,y + vspeed,Wall)){
		sound_play_pitchvol(snd_hurt, max(2, speed * 0.5), min(speed*0.1, 0.4));
		with(instance_create(x + hspeed,y + vspeed,RainSplash)){
			image_angle = direction;
		}
		speed *= 0.98;
		flash = 2;
	}

	if(roll_time > roll_minimum){
		if(speed <= 3){ //end roll
			is_rolling = false;
			can_roll = true;
			finished_roll = 3;
			with(instances_matching(CustomSlash, "creator", self)){
				instance_destroy();
			}
			canwalk = true;
			roll_time = 0;
			maxspeed = maxspeed_base;
			melee_damage = 2;

			//shoot bullet
			if(bullets < 5){
				fireType = choose("pop", "rifle", "bounce");
			} else {
				fireType = choose("shotgun", "eraser", "bounceShotgun");
			}
			bullets += 3;
		}
	}
} else {
	sound_stop(loop);
	if(bullets > 0){
		firing = true;
	}
	fireDelay -= current_time_scale;
}

if(firing){
	_x = x + lengthdir_x(8, direction);
	_y = y + lengthdir_y(8, direction);
	if(bullets > 0){
		switch(fireType){
			case "pop":
				if(fireDelay<=0){
					with(instance_create(_x,_y,Bullet2)){
						team = other.team;
						direction = other.direction + random_range(-15,15);
						image_angle = direction;
						damage = 2;
						friction = 0.6;
						speed = 10 + random(2);
						sound_play_pitchvol(sndPopgun, random_range(0.9,1.1) + other.bullets/6, 0.75);
					}
					bullets--;
					fireDelay = 1;
				}
			break;

			case "rifle":
				if(fireDelay<=0){
					with(instance_create(_x,_y,Bullet1)){
						team = other.team;
						direction = other.direction + random_range(-5,5);
						image_angle = direction;
						damage = 6;
						speed = 15 + random(2);
						sound_play_pitchvol(sndPistol, random_range(0.9,1.1) + other.bullets/6, 0.75);
					}
					bullets--;
					fireDelay = 3;
				}
			break;

			case "bounce":
				shell = sprBulletShell;
				if(fireDelay<=0){
					with(instance_create(_x,_y,BouncerBullet)){
						team = other.team;
						direction = other.direction + random_range(-30,30);
						damage = 6;
						speed = 6;
						sound_play_pitchvol(sndBouncerSmg, random_range(0.9,1.1) + other.bullets/10, 0.75);
					}
					bullets--;
					fireDelay = 2;
				}
			break;
			
			case "shotgun":
				repeat(bullets){
						with(instance_create(_x,_y,Bullet2)){
						team = other.team;
						direction = other.direction + random_range(-25,25);
						image_angle = direction;
						friction = 0.6;
						speed = 8 + random(8);
					}
				sound_play_pitchvol(sndShotgun, random_range(0.7,0.9), 0.75);
				}
				bullets = 0;
			break;
			
			case "eraser":
				repeat(bullets){
						with(instance_create(_x,_y,Bullet2)){
						team = other.team;
						direction = other.direction + random_range(-3,3);
						image_angle = direction;
						friction = 0.6;
						speed = 8 + random(8);
					}
				sound_play_pitchvol(sndEraser, random_range(0.7,0.9), 0.75);
				}
				bullets = 0;
			break;
			
			case "bounceShotgun":
				repeat(bullets){
						with(instance_create(_x,_y,BouncerBullet)){
						team = other.team;
						damage = 5;
						direction = other.direction + random_range(-60,60);
						image_angle = direction;
						speed = 6;
					}
				sound_play_pitchvol(sndBouncerShotgun, random_range(0.7,0.9), 0.75);
				}
				bullets = 0;
			break;
		}
	} else {
		firing = false; 
	}
}

if(finished_roll > 0){
	if(audio_is_paused(rSound)){
		audio_resume_sound(rSound);
	}
	//after rolling, play unrolling animation while letting player walk
	finished_roll -= current_time_scale/3;
	sprite_index = spr_fire;
	image_index = 7 + (3 - finished_roll);
}

// no weps
canswap = 0;
canpick = 0;

// sprite faces direction, as you have no weps
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

// outgoing contact damage
if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(nexthurt <= current_frame){
			sound_play_pitchvol(other.snd_mele, random_range(0.9,1.1), 0.65);
			if(other.melee_damage > 2){
				sound_play_pitchvol(sndSewerPipeBreak, random_range(2.1,2.7), 0.65);
			}
			projectile_hit(self, other.melee_damage, other.speed, other.direction);
			with(other){
				if(is_rolling) {
					smoke = 12; 
					flash = 1;
				}
			}
		}
	}
}

#define wolf_draw
with(Player){
	maxArrows = min(5, max(1, floor(speed - 2)*2));
	if(is_rolling){
		for(i = 0; i < maxArrows; i++){
			distX = lengthdir_x(10 + (i*4),direction - (angle_difference(direction,gunangle) * (i/10)));
			distY = lengthdir_y(10 + (i*4),direction - (angle_difference(direction,gunangle) * (i/10)));
			// draw_triangle(x + distX + lengthdir_x(triangle_size, direction-90), y + distY + lengthdir_y(triangle_size, direction-90), 
			// x + distX + lengthdir_x(triangle_size, direction+90), y + distY + lengthdir_y(triangle_size, direction+90), 
			// x + distX + lengthdir_x(triangle_size, direction), y + distY + lengthdir_y(triangle_size, direction), false);
			draw_sprite_ext(global.sprArrow, 0, x + distX, y + distY, 0.7 + (i * 0.05), 0.7 + (i * 0.05), direction - (angle_difference(direction,gunangle) * (i/3)) - 90,make_color_hsv(80 - min(80,i*abs(angle_difference(direction,gunangle)/4)),160,255), 0.05 + speed/5);
		}
	}

	if(flash > 0){
		draw_set_fog(true, c_white, 1, 1);
		draw_set_color(c_white);
		draw_self();
		draw_set_fog(false, c_white, 1, 1);
	}
}
instance_destroy();

#define shield_step
if(instance_exists(creator)){
	x = creator.x + lengthdir_x(creator.speed + 2, creator.direction);
	y = creator.y + lengthdir_y(creator.speed + 2, creator.direction);
	xprevious = x;
	yprevious = y;
}
else{
	instance_delete(self);
}

#define shield_projectile
with(other){
	switch(object_index){
		case Grenade:
		case Flame:
		case TrapFire:
		case PopoPlasmaBall:
		case HorrorBullet:
		case EnemyLaser:
		case EnemyLightning:
		case ToxicGas:
		case EnemySlash:
			return;
		break;

		case EFlakBullet:
			other.creator.bullets += 4;
		break;

		default:
			other.creator.bullets += 1;
		break;
	}
	
	sound_play_pitchvol(sndCrystalRicochet, random_range(0.5, 0.7), 1);
	sound_play_pitchvol(sndSnowBotHurt, random_range(2.1, 2.3), 0.35);
	with(other){
		creator.flash = 1;
		if(instance_exists(txt)) instance_delete(txt);
		txt = PopupText;
		with(instance_create(x,y,txt)){
			xstart = x;
			ystart = y;
			if(other.creator.bullets < 5){
				mytext = "@y" + string(other.creator.bullets);
			} else {
				mytext = "@r" + string(other.creator.bullets) + "@w!";
			}
			time = 8;
			alarm1 = max(8, other.creator.bullets * 3);
			target = 0;
			
		}
	}
	with(other.creator){
		motion_add(other.direction, other.speed / 5);
	}
	repeat(irandom_range(5,8)){
		with(instance_create(x, y, choose(CaveSparkle, WepSwap))){
			direction = other.direction + random_range(-40, 40);
			speed = random_range(4,6);
			friction = 0.4;
			image_angle = direction;
		}
	}
	
	instance_create(x, y, Deflect);

	instance_destroy();
}

// sound_play_pitchvol(sndPlantFireTB, 1.5 + creator.bullets * 0.25 + creator.shells + 0.25 + random_range(0.1, -0.1), 1);
sound_play_pitchvol(sndChickenReturn, 1.5 + creator.bullets * 0.15, 1);
sound_play_pitchvol(sndRecGlandProc, 0.5 + creator.bullets * 0.05 + random_range(0.1, -0.1), 1);
if(creator.bullets > 5){
	sound_play_pitchvol(sndSwapPistol, 1.5, 0.25);
}
#define shield_grenade
shield_projectile();

#define shield_wall
if(other.solid){
	walled = true;
}

#define shield_hit

#define shield_end_step
if(walled){
	x += hspeed_raw;
	y += vspeed_raw;
}

#define race_name
// return race name for character select and various menus
return "ROBOT WOLF";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#@sCAN @wROLL";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return 0;


#define race_avail
// return if race is unlocked
return 1;


#define race_menu_button
// return race menu button icon
sprite_index = global.sprMenuButton;

#define race_skins
// return number of skins the race has
return 1;


#define race_skin_avail
// return if skin is unlocked
return 1;

#define race_skin_button
// return skin switch button sprite
return global.sprIcon;


#define race_soundbank
// return build in race id for default sounds
return 0;


#define race_tb_text
// return description for Throne Butt
return "DOES NOTHING";


#define race_tb_take
// run when Throne Butt is taken
// player of race may not be alive at the time

#define race_ultra_name
// return a name for each ultra
// determines how many ultras are shown
switch(argument0){
	case 1: return "NOTHING";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "DOES NOTHING";
	default: return "";
}


#define race_ultra_button
// called by ultra mutation button on creation
// recieves ultra mutation index
switch(argument0){
	case 1: return mskNone;
}


#define race_ultra_take
// recieves ultra mutation index
// called when ultra for race is picked
// player of race may not be alive at the time


#define race_ttip
// return character-specific tooltips
return choose("WOOF", "BARK", "STRAY MODE ENGAGED", "AWOO.WAV", "ARF!", "POODLE BITES");