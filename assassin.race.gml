#define init
// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

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

if(button_pressed(index, "spec")){
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
		sound_play_pitchvol(sndSwapBow, 1.2 + random_range(-0.1, 0.1), 0.5);
		want_load = false;
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
		sound_play_pitchvol(sndSwapSword, 1.7 + random_range(-0.1, 0.1), 0.8);
		with(instance_create(x, y, Splinter)){
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
			image_angle += 24;
		}
		else{
			image_angle -= 24;
		}
	}
}

#define race_name
// return race name for character select and various menus
return "ASSASSIN";


#define race_text
// return passive and active for character selection screen
return "@sBE @wHIDDEN#@sHAS @wPIPE";


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