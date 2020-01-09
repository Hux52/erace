#define init
// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

global.sprSkull = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAAcAAAAFCAYAAACJmvbYAAAAAXNSR0IArs4c6QAAAC5JREFUCJljZGBgYPj///9/BjTAyMjIyIhNAgaYGBgYGErEUQVhfLw6GZDtRKcBy1UZCLtpzLUAAAAASUVORK5CYII=", 1, 4, 2);

// character select button
global.sprMenuButton = sprite_add("sprites/selectIcon/sprAssassinSelect.png", 1, 0, 0);

global.sprPortrait = sprite_add("sprites/portrait/sprPortraitAssassin.png", 1, 15, 205);

global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Assasin.png", 1, 10, 10);

global.sprShuriken = sprite_add("sprites/sprShuriken.png", 2, 6, 6);

// level start init- MUST GO AT END OF INIT
while(true){
	// first chunk here happens at the start of the level, second happens in portal
	if(instance_exists(GenCont)) global.newLevel = 1;
	else if(global.newLevel){
		global.newLevel = 0;
		level_start();
	}
	var hadGenCont = global.hasGenCont;
	global.hasGenCont = instance_exists(GenCont);
	if (!hadGenCont && global.hasGenCont) {
		// nothing yet
	}
	wait 1;
}

//lol


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprMeleeIdle;
spr_walk = sprMeleeWalk;
spr_hurt = sprMeleeHurt;
spr_dead = sprMeleeDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndAssassinHit;
snd_dead = sndAssassinDie;

// stats
maxspeed = 4.5;
team = 2;
maxhealth = 7;
melee = 0;	// can melee or not
firing = false;
spec_load = 0;
want_load = false;

// vars
getup = 0;	// alarm to get up from faking

#define level_start
with(instances_matching(Player, "race", "assassin")){
	// fake player
	with(instance_create(x, y, CustomObject)){
		creator = other;
		index = creator.index;
		sprite_index = sprMeleeFake;
		image_speed = 0;
		getup = 180;
		mask_index = mskNone;
		on_step = script_ref_create(fake_step);
		// outline
		playerColor = player_get_color(creator.index);
		toDraw = self;
		script_bind_draw(draw_outline, depth, playerColor, toDraw);
	}
	// temp lighting fix
	with(instance_create(x, y, Wall)){
		creator = other;
		index = creator.index;
		topspr = mskNone;
		outspr = mskNone;
		sprite_index = mskNone;
		mask_index = mskNone;
	}
	fake = instances_matching(CustomObject, "index", index);
	light = instances_matching(Wall, "index", index);
	view_object[index] = fake[0];
	mask_index = mskNone;
	spr_idle = mskNone;
}


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no more weps
canswap = 0;
canpick = 0;

if(firing = true){
	canwalk = false;
} else {
	canwalk = true;
}

if(button_check(index, "spec")){
	if("fake" in self){
		if(!instance_exists(fake[0])){
			if(spec_load <= 0){
				shuriken_burst();
				want_load = true;
				spec_load = 30;
			}
		}
	}
}

if(spec_load > 0){
	spec_load -= current_time_scale;
}
else{
	if(want_load = true){
		sound_play_pitchvol(sndSwapBow, 1.5 + random_range(-0.1, 0.1), 0.25);
		sound_play_pitchvol(sndMenuOptions, 2.5 + random_range(-0.1, 0.1), 0.45);
		sound_play_pitchvol(sndMeleeFlip, 2 + random_range(-0.1, 0.1), 0.65);
		want_load = false;
	}
}

if(ultra_get("assassin", 1)){
	with(BoltStick){
		if("poison" not in self){
			ApplyPoison(target);
			poison = true;
		}
	}
}

with(enemy){
	if(my_health <= 0){
		var _e = instance_nearest_notme(x, y, enemy);
		sticks_dir = point_direction(x, y, _e.x, _e.y);
		with(instances_matching(BoltStick, "target", self)){
			sticks_dir = other.sticks_dir;
			with(instance_create(x, y, Splinter)){
				sprite_index = global.sprShuriken;
				mask_index = mskBouncerBullet;
				team = 2;
				direction = other.sticks_dir;
				image_angle = direction;
				friction = 0;
				speed = 14;
				damage = 2.80 + (0.20 * GameCont.level) + (GameCont.loops * 0.33);
				spin = true;
				script_bind_step(shuriken_step, 0, self);
			}
		}
	}
}

#define fake_step
if(getup > 0){
	creator.reload = 99;	// no firing
	// stay still
	if(getup > 150){
		image_index = 0;
	}
	// peek around
	if(getup = 150){
		sound_play(sndAssassinPretend);
	}
	// still again
	else if(getup < 115){
		image_index = 0;
	}
	
	// alarm management
	getup-= current_time_scale;
	
	// hide wep
	creator.wkick = 999;
	
	// cancel hiding
	with(creator){
		if(button_check(index, "nort") or button_check(index, "sout") or button_check(index, "east") or button_check(index, "west") or button_pressed(index, "fire") or other.getup = 1){
			x = other.x;
			y = other.y;
			mask_index = mskPlayer;
			spr_idle = sprMeleeIdle;
			sound_play(sndAssassinGetUp);
			wkick = 0;
			other.getup = 0;
			reload = 0;
			view_object[index] = self;
			instance_delete(fake[0]);
			instance_delete(light[0]);
		}
	}
}

#define shuriken_burst()
var _x = x + lengthdir_x(5, gunangle);
var _y = y + lengthdir_y(5, gunangle);
with instance_create(_x, _y, CustomObject){
	name = "shurikenBurst";
	creator = other;
	team = creator.team;
	mask_index = mskNone;
	spr_shadow = mskNone;
	direction = other.gunangle;
	friction = 0;
	on_step = script_ref_create(shurikenBurst_step);
	alarm = [0];
	maxammo = 3;
	ammo = maxammo;
}

#define shurikenBurst_step
if(instance_exists(creator)){
	direction = creator.gunangle + (random(creator.accuracy) * choose(1, -1) * random(6));
	// follow player
	x = creator.x + lengthdir_x(5, creator.gunangle);
	y = creator.y + lengthdir_y(5, creator.gunangle);
	// fire bullets
	if(alarm[0] <= 0){	// 3 bullets
		sound_play_pitchvol(sndMeleeFlip, 1.7 + (0.6 - (ammo/5)), 0.2);
		sound_play_pitchvol(sndSwapSword, 2.5 + (0.6 - (ammo/5)), 0.65);
		sound_play_pitchvol(sndBlackSword, 1.5 + (0.6 - (ammo/5)), 0.35);
		view_shake[creator.index] += 10;
		with(instance_create(x, y, Splinter)){
			if(ultra_get("assassin", 1)){
				image_blend = merge_color(c_white, c_purple, 0.3);
			}
			sprite_index = global.sprShuriken;
			mask_index = mskBouncerBullet;
			creator = other.creator;
			team = creator.team;
			direction = other.direction;
			image_angle = direction;
			friction = 0;
			speed = 14;
			damage = 2.80 + (0.20 * GameCont.level) + (GameCont.loops * 0.33);
			spin = true;
			script_bind_step(shuriken_step, 0, self);
		}
		ammo--;
	}
	for(i = 0; i < array_length(alarm); i++){
		if(alarm[i] <= 0){
			alarm[i] = 3;
		}
		alarm[i]-= current_time_scale;
	}
	if(ammo <= 0){
		instance_destroy();
	}
}

#define shuriken_step(hooh)
with(hooh){
	if(speed > 0){
		if(id % 2 != 0){
			image_angle += 24 * current_time_scale;
		}
		else{
			image_angle -= 24 * current_time_scale;
		}
		if(ultra_get("assassin", 1)){
			if(random(1) < 0.2){
				with(instance_create(x, y, Curse)){
					//	image_blend = merge_color(c_white, c_purple, 0.3);
					direction = other.direction + 180 + random_range(-5, 5);
					speed = 2;
					image_speed = 0.6;
					image_index = 4;
					image_angle = random(360);
				}
			}
		}
	}
}
if(speed = 0){
	instance_destroy();
}

#define race_name
// return race name for character select and various menus
return "ASSASSIN";


#define race_text
// return passive and active for character selection screen
return "@sBE @wHIDDEN#@sTHROW @wSHURIKENS";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return "assassin";


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
return sprMapIconChickenHeadless;


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
return choose("Warm Barrels", "Dust Proof", "Plunder", "Fire First, Aim Later");

#define draw_outline(playerColor, toDraw)
d3d_set_fog(1,playerColor,0,0);
if(instance_exists(toDraw)){
    with(toDraw){
        draw_sprite_ext(sprite_index, -1, x - 1, y, 1, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x + 1, y, 1, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y - 1, 1, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y + 1, 1, 1, 0, playerColor, 1);
    }
}
d3d_set_fog(0,c_lime,0,0);

#define instance_nearest_notme
var _x = x;
x -= 10000000;
var _inst = instance_nearest(_x, y, enemy);
x = _x;
return _inst;



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