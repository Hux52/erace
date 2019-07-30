#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACiSURBVDhPvZIxDkBAEEX3SEqJXiVRi8oF3EOlcRmNu7iHZFnxN+ub1cwiebLZ+f8VjKma0mowx+Ne4jAEOc4fZ6VgXSbr4AAzj+0NP0su6IdOBPP0Ain8Bor+I0qhNx6Cos5siFQKSS/AYMvNCQsZ5CBKJ2AQkGaO7wXABy948fQCrCYXcf8oMGoBAizAPX4fClggv0hqARdjxET/CcBdUNodXNPrwW8RonsAAAAASUVORK5CYII=", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitGreenRat.png",1 , 15, 185);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Smallgreenrat.png", 1, 10, 10);

// character select sounds
global.sndSelect = sound_add("sounds/sndFastRatSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "fastrat"){
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
spr_idle = sprFastRatIdle;
spr_walk = sprFastRatWalk;
spr_hurt = sprFastRatHurt;
spr_dead = sprFastRatDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndFastRatHit;
snd_dead = sndFastRatDie;
snd_wrld = sndFastRatSpawn;

// stats
maxspeed = 4;
erace_maxspeed_orig = maxspeed;
team = 2;
maxhealth = 7;
spr_shadow_y = 0;
mask_index = mskPlayer;
canwalk = 1;

hasDied = false;

// vars
age = 900;	// die in 30 seconds
melee = 1;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

// face direction you're moving in- no weps
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

// outgoing contact damage
if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			projectile_hit_push(self, 2, 4);
		}
	}
}

// age management and consequence
age-= current_time_scale;
if(my_health > 0) {
	hasDied = false;
}

if(my_health > lsthealth){
	if (age < 450){
	age = 450;
	instance_create(x,y,HorrorTB);
	}	
}

if(age mod 30 = 0){ 
	with(instance_create(x,y,AllyDamage)){
		depth = -100;
	} 
}

if(age <= 0){
	if(sprite_index != spr_hurt){sprite_index = spr_hurt; image_index = 0;}
	with(instance_create(x,y,ThrowHit)){
		depth = -100;
	}
	sound_play_pitchvol(snd_hurt, random_range(0.9, 1.1), 0.6);
	age = 150;
	my_health -= 1;
}
// on death
if(my_health < 1){
	if(hasDied = false){
		sound_play(snd_dead);
		// effect
		with(instance_create(x, y, AcidStreak)){
			speed = 8;
			direction = other.direction;
		}
		hasDied = true;
	}
	_to = mod_script_call("mod","erace","respawn_as", true, "fastrat", "Fastrat");
	instance_delete(_to);
} else {
	hasDied = false;
}

#define race_name
// return race name for character select and various menus
return "FAST RAT";


#define race_text
// return passive and active for character selection screen
return "AGING#CONTACT DAMAGE";


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
return false;


#define race_menu_button
// return race menu button icon
return -1;

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
return choose("WHISKERS", "RABID", "ITCHY", "RODENT");