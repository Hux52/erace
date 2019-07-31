#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprBoneFishSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitBonefish.png",1 , 15, 210);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Bonefish.png", 1, 10, 10);

// character select sounds
global.sndSelect = sndOasisChest;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "bonefish"){
			sound_play_pitchvol(global.sndSelect,1.2,1);
		}
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprBoneFish1Idle;
spr_walk = sprBoneFish1Walk;
spr_hurt = sprBoneFish1Hurt;
spr_dead = sprBoneFish1Dead;
spr_sit1 = sprBoneFish1Idle;
spr_sit2 = sprBoneFish1Idle;

// sounds
snd_hurt = sndOasisHurt;
snd_dead = sndOasisDeath;
snd_melee = sndOasisMelee;

// stats
maxspeed = 4;
erace_maxspeed_orig = maxspeed;
team = 2;
maxhealth = 6;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
melee = 1;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

//passive: swimming
friction = 0.25;
footstep = 10;

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
			sound_play_pitchvol(other.snd_melee,random_range(0.9,1.1),1);
		}
	}
}

#define race_name
// return race name for character select and various menus
return "BONEFISH";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE";


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
return true;


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
return choose("BLUB", "HOW AM I SWIMMING");