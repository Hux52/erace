#define init
// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

// character select button
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACESURBVDhPYwCC/+g41NmeaAxUT6EBETph/9ExKQbRxgAYJsYgyg3QFNX4TwjDDMJm2CAwAJvf0TFtDUCWhOE/FqgYWY4+BpCIsQoSj0sTnP/PbU0iGVPPAGySxGDqGQDyAi6MTSMMU88AbJL4MMxw6hkAyiwwQWwaQBgmj6wRkpTt/wMAPXKuCw+8+LAAAAAASUVORK5CYIIAAAAAAAAAAAAAAAAAAAAAAA==", 1, 0, 0);

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

// vars
getup = 0;	// alarm to get up from faking

#define level_start
with(instances_matching(Player, "race", "assassin")){
	// fake player
	with(instance_create(x, y, CustomHitme)){
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
	with(instance_create(x, y, Tangle)){
		creator = other;
		index = creator.index;
		sprite_index = mskNone;
		mask_index = mskNone;
	}
	x = -99999999;
	y = -99999999;
	fake = instances_matching(CustomHitme, "index", index);
	light = instances_matching(Tangle, "index", index);
	view_object = fake[0];
	mask_index = mskNone;
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
	getup--;
	
	// cancel hiding
	with(creator){
		if(button_check(index, "nort") or button_check(index, "sout") or button_check(index, "east") or button_check(index, "west") or button_pressed(index, "fire") or other.getup = 1){
			x = other.x;
			y = other.y;
			mask_index = mskPlayer;
			sound_play(sndAssassinGetUp);
			wkick = 0;
			other.getup = 0;
			reload = 0;
			view_object = self;
			instance_delete(fake[0]);
			instance_delete(light[0]);
		}
	}
}

#define race_name
// return race name for character select and various menus
return "ASSASSIN";


#define race_text
// return passive and active for character selection screen
return "CAN HIDE#HAS PIPE";


#define race_portrait
// return portrait for character selection screen and pause menu
return sprBigPortraitChickenHeadless;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


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