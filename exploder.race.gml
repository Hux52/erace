#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACXSURBVDhPzZMxDoAgDEU7s3IOFyc3BwcvoKNHcfXUJpiSlFTzURAGhpcQ+vsoIdA6ja6ERgRElEx9AW8u+3ajm3oP2nvKSAp/8CJUSCUIzoECzxBC58ME+r45lAtkIaLZGHdYm0wQaBEKxqgjkPEFFIzRiECTLZBTtYCfUoMahXKBbkTNX/gJRMKg0BvlAt3M8B9HQYxxF3SMiB75OeSoAAAAAElFTkSuQmCC", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/sprPortraitExploder.png", 1, 10, 205);

// character select sounds
global.sndSelect = sound_add("sounds/sndExploderSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "exploder"){
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
spr_idle = sprExploderIdle;
spr_walk = sprExploderWalk;
spr_hurt = sprExploderHurt;
spr_dead = sprExploderDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_dead = sndFrogExplode;

// stats
maxspeed = 3;
team = 2;
maxhealth = 5;
spr_shadow = shd24;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
close = 0;	// timer for when close to an enemy- prevents sound spam
exploded = 0;	// prevent extra death frames
melee = 1;	// can melee or not
dead = false; // death effect

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;
u2 = ultra_get("exploder", 2); // ULTRA B

//ULTRA A: TOXIC BALLGUY
if (ultra_get("exploder",1) = 1){
	if (player_get_race(index) == "exploder"){
		player_set_race(index, "superfrog");
		race = "superfrog";
	}
}

// face the direction you're moving in- no gun
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

// constant movement
if(canwalk = 1){
	move_bounce_solid(true);
	motion_add(direction, maxspeed / 4);
}

// explode on contact- make noise when close
if(collision_rectangle(x + 10, y + 10, x - 10, y - 10, enemy, 0, 1) && exploded <= 0){
	exploder_explode();
	my_health -= 1;
}
else if(collision_rectangle(x - 30, y - 10, x + 30, y + 10, enemy, 0, 1)){
	if(close = 0){
		sound_play(sndFrogClose);
		close = 30;
	}
}

if(exploded > 0){
	exploded--;
}

// noise cooldown to prevent spam
if(close > 0){
	close--;
}

// on death
if(my_health = 0 && dead = false){
	exploder_explode();
	dead = true;
}

#define exploder_explode
exploded = 30;
	sound_play_pitchvol(sndFrogPistol, random_range(0.9, 1.1), 0.5);
	// 8 bullets
	for(i = 0; i < 360; i += 45){
		if(u2 = 0){
			with(instance_create(x, y, Bullet1)){
				creator = other;
				team = creator.team;
				sprite_index = sprScorpionBullet;
				direction = other.i + random_range(-5, 5);
				image_angle = direction;
				friction = 0;
				speed = 4;
				damage = 2;
			}
		} else {
			// ULTRA B: HYPER REVENGE
			with(instance_create(x, y, Devastator)){
				creator = other;
				team = creator.team;
				direction = other.i + random_range(-5, 5);
				image_angle = direction;
				friction = 0;
				speed = 16;
				damage = 8;
			}
		}
	}
	
	// effect
	for(i = 0; i < 360; i += 120){
		with(instance_create(x, y, AcidStreak)){
			speed = 8;
			direction = other.i + random_range(-30, 30);
			image_angle = direction;
			friction = 0.9;
		}
	}
	
	if (u2 = 1){
		sound_play(sndDevastator);
	}

#define race_name
// return race name for character select and various menus
return "BALLGUY";


#define race_text
// return passive and active for character selection screen
return "CAN'T STAND STILL#@gEXPLODE @wON CONTACT";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


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
	case 1: return "TRANSFORMATION";
	case 2: return "HYPER REVENGE";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "EXTRA @gTOXIC";
	case 2: return "@gDEVASTATING @sREPERCUSSIONS";
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
return choose("RIBBIT", "CAN'T STOP, PROBABLY WON'T STOP");