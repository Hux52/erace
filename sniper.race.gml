#define init
// character select button
//global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACOSURBVDhPYwCC/9jw231BRGGgWgoNmNua9B8bJtYgyg24cHTLf3yYkEGUG4DN+dgwLoMoNwCbs5Ex7Q2ASaDjPxaoGCZOPwNIwFgFice2GvL/QTjfw5IkTD0DsEkSgzFcgAtj0wzC1DMAmyQ+DDOYegbA0jxMApsmEEbXCE+JFBsAy23oGKYBl0YIDvoPABoXHHo1+L+9AAAAAElFTkSuQmCCAAAAAAAAAA==", 1, 0, 0);
global.sprMenuButton = sprite_add("sprites/selectIcon/sprSniperSelect.png", 1, 0,0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitSniper.png", 1, 0, 200);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Sniper.png", 1, 10, 10);
global.sprArrow = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAAYAAAAGCAYAAADgzO9IAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5AEQFCYA9IkFkwAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAAAH0lEQVQI12P4/////3Xr1v3/////fwZ0QLok8YL4AABnlzcGWUuLLwAAAABJRU5ErkJggg==", 1, 3,3);

// character select sounds
global.sndSelect = sound_add("sounds/sndSniperSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "sniper"){
			sound_play(global.sndSelect);
		}
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprSniperIdle;
spr_walk = sprSniperWalk;
spr_hurt = sprSniperHurt;
spr_dead = sprSniperDead;
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndSniperHit;
//snd_dead = doesn't have one

// stats
maxspeed_base = 1.7;
maxspeed = maxspeed_base;
team = 2;
maxhealth = 6;
hasDied = false;
firing = false;
cooldown_base = 10;
cooldown = 0;
dash_speed = 7;
isDashing = false;
dashes = 3;
maxDashes = 3;
dashRecharge = 0;
dashRechargeFull = 30;
dashHide = 3;
dash_queued = false;

// vars
melee = 0;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;

//basic stuff
if (cooldown > 0){
	cooldown-= current_time_scale;
	canspec = false;
} else {
	canspec = true;
}

if(firing == true){
	canwalk = false;
	canspec = false;
} 

if(cooldown < cooldown_base - 8){ //can't walk for 8 frames
	isDashing = false;
} else {
	isDashing = true;
}


if(button_pressed(index, "spec") && dashes >= 1 && cooldown <= 4 && firing == false){
	dash_queued = true;
}

//dash event
if(dash_queued && canspec){
	isDashing = true;
	instance_create(x,y,Dust);
	maxspeed = dash_speed;
	if(speed > 0){
		motion_add(direction, dash_speed);
	} else {
		motion_add(gunangle, dash_speed);
	}
	cooldown = cooldown_base;
	sound_play_pitchvol(sndAssassinGetUp, 1.2 + (dashes * 0.1),0.15);
	sound_play_pitchvol(sndSnowBotSlideStart, 1.8 + (dashes * 0.3),0.55);
	sound_play_pitchvol(sndEnemySlash, 1.5 + (dashes * 0.4),0.85);

	dashes--;
	dash_queued = false;
}

if (my_health == 0 && hasDied == false){
	sound_play(sndExplosion);
	instance_create(x,y,Explosion);
	hasDied = true;
}

//fixing speed
if(isDashing){
	canwalk = false;
	maxspeed = dash_speed;
	
	with(instance_create(x,y,BoltTrail)){
		image_xscale = other.speed;
		image_yscale = 1.5;
		image_angle = other.direction;
		image_blend = merge_color(player_get_color(other.index), c_white, 0);
	}
	with(instance_create(x,y,BoltTrail)){
		image_xscale = other.speed;
		image_yscale = 2;
		image_angle = other.direction;
		image_blend = merge_color(player_get_color(other.index), c_black, 0.3);
	}
} else {
	if(firing == false){
		canwalk = true;
	}
	maxspeed = maxspeed_base;
}
if(dashes < maxDashes){
	dashHide = 3;
	if(dashRecharge >= dashRechargeFull){
		dashRecharge = 0;
		dashes++;
	} else {
		dashRecharge += current_time_scale;
	}
} else {
	dashHide -= 1/room_speed;
}

if (ultra_get("sniper", 1) == 1){
	if(wep != "sniper_ultra"){
		wep = "sniper_ultra";
	}
}
else if (ultra_get("sniper", 2) == 1){
	if(wep != "super_sniper_cannon"){
		wep = "super_sniper_cannon";
	}
}
else{
	if(wep != "sniper"){
		wep = "sniper";
	}
}

#define draw
for(i = 0; i < dashes; i++){
	draw_sprite_ext(global.sprArrow, 0, x - 10 + (i * 4), y - 10 + (2 * i), 1, 1, 0, c_white, dashHide);
}

#define race_name
// return race name for character select and various menus
return "SNIPER";


#define race_text
// return passive and active for character selection screen
return "LONG RANGED#@yEXPLODES @wON DEATH#@sCAN @wDASH";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return "sniper";


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
	case 1: return "ARMAMENT UPGRADE";
	case 2: return "CLONING";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "MOW THEM DOWN";
	case 2: return "IT LOOKS FAMILIAR";
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