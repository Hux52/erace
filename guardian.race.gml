#define init
global.sprMenuButton = sprite_add("sprites/sprGuardianSelect.png", 1, 0,0);

// level start init- MUST GO AT END OF INIT
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;
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


#define level_start
teleport = 0;
cooldown = 30;
spr_idle = sprGuardianIdle;
spr_walk = sprGuardianIdle;

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprGuardianIdle;
spr_walk = sprGuardianIdle;
spr_hurt = sprGuardianHurt;
spr_dead = sprGuardianDead;
spr_tele = [sprGuardianDisappear, sprGuardianAppear];	// teleport sprites
spr_fire = [sprGuardianFire];	// shoot bullets
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndGuardianHurt;
snd_dead = sndGuardianDead;
snd_tele = [sndGuardianDisappear, sndGuardianAppear];	// teleport sounds
snd_fire = sndGuardianFire;	// shoot bullets

// stats
maxspeed = 0;
team = 2;
maxhealth = 35;
spr_shadow = shd24;
spr_shadow_y = 4;
mask_index = mskPlayer;
canwalk = 1;

// vars
teleport = 0;	// teleport duration
cooldown = 0;	// cooldown til you can teleport again
coords = [0, 0];	// teleport destination
nudge = 15;	// movement jitter
died = 0;	// deny extra death frames
canwalk = 0;
melee = 0;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

// no walking
canwalk = 0;

// constant movement
if(nudge = 0){
	move_bounce_solid(true);
	motion_add(gunangle, 1);
	nudge = 15;
}
else{
	nudge--;
}

// special - teleport
if(button_pressed(index, "spec")){
	if(cooldown = 0 and canspec = 1 and sprite_index != spr_hurt){
		// if floor inside borders...
		if!(collision_point(mouse_x[index], mouse_y[index] - 8, Wall, false, true)){
			if(collision_point(mouse_x[index], mouse_y[index] - 8, Floor, false, true)){
				// disappear sprite
				spr_idle = spr_tele[0];
				spr_walk = spr_tele[0];
				image_index = 0;
				sound_play(snd_tele[0]);	// disappear sound
				cooldown = -1;
				teleport = 70;	// full teleport duration
				// log coordinates for later
				coords[0] = mouse_x[index];
				coords[1] = mouse_y[index] - 8;
			}
		}
	}
}

// teleporting
if(teleport > 0){
	nudge = 15;	// no movement
	// finishing up
	if(teleport = 40){
		spr_idle = spr_tele[1];
		spr_walk = spr_tele[1];
		image_index = 0;
		x = coords[0];
		y = coords[1];
		sound_play(snd_tele[1]);
	}
	// done
	else if(teleport = 1){
		cooldown = 30;
		spr_idle = sprGuardianIdle;
		spr_walk = sprGuardianIdle;
	}
	// while teleporting, if hit, cancel
	if(sprite_index = spr_hurt){
		teleport = 0;
		cooldown = 30;
		spr_idle = sprGuardianIdle;
		spr_walk = sprGuardianIdle;
	}
	// no firing
	reload = 2;
	teleport--;
}

// firing
if(reload > 2 and sprite_index != spr_hurt){
	spr_idle = spr_fire;
	spr_walk = spr_fire;
}
else if(spr_idle = spr_fire){
	spr_idle = sprGuardianIdle;
	spr_walk = sprGuardianIdle;
}

// cooldown management
if(cooldown > 0){
	cooldown--;
}

#define race_name
// return race name for character select and various menus
return "GUARDIAN";


#define race_text
// return passive and active for character selection screen
return "FIRE RAD BALLS#CAN TELEPORT";


#define race_portrait
// return portrait for character selection screen and pause menu
return sprBigPortraitChickenHeadless;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return "guardian";


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
return choose("THE PALACE", "GEIGER OFF THE CHARTS", "PROTECT", "REPOSITIONING");