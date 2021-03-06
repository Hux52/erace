#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABgSURBVDhPY1jfn/WfEjxqwPAwAAhABE6MTRMyBqrBrhGGsWlCxkA12DXCMDZNyJjhyv71/5HxjqlVKJiQYcPFAGQN6AYiY2yGDRIDShOc4RhdEzIepAYgC5KCB4sBWf8B/5uAJW+PFKIAAAAASUVORK5CYIIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==", 1, 0, 0);
global.sprPortrait = sprite_add("/sprites/portrait/sprPortraitRadMaggot.png", 1, 22, 200);

// character select sounds
global.sndSelect = sound_add("sounds/sndMaggotSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "radmaggot"){
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
spr_idle = sprRadMaggot;
spr_walk = sprRadMaggot;
spr_hurt = sprRadMaggotHurt;
spr_dead = sprRadMaggotDead;
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndHitFlesh;
snd_dead = sndEnemyDie;

// stats
maxspeed = 3;
team = 2;
maxhealth = 2;
spr_shadow = shd16;
spr_shadow_y = 0;
mask_index = mskMaggot;
canwalk = 1;

// vars
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

// face direction you're moving in, as you have no weps
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

// outgoing contact damage
if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= 1;
			sound_play_pitch(snd_hurt, random_range(0.9, 1.1));
			sound_play_pitch(sndMaggotBite, random_range(0.9, 1.1));
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
}

//respawn as other maggot
if(my_health = 0){
	//before respawn
	

	//respawn
	mod_script_call("mod","erace","respawn_as", true, "radmaggot", "RadMaggot");

	
}

#define race_name
// return race name for character select and various menus
return "RADMAGGOT";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#CAN'T STAND STILL";


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
return false;


#define race_menu_button
// return race menu button icon
return -1;

#define race_skins
// return number of skins the race has
return 0;


#define race_skin_avail
// return if skin is unlocked
return 0;

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
return choose("HUNGRY", "WRIGGLE", "FAMILY", "RADICAL");