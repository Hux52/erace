#define init
global.sprMenuButton = sprite_add("sprites/sprRatSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/sprPortraitRat.png",1 , 15, 185);

// level start init- MUST GO AT END OF INIT
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;
global.sndSelect = sndVanWarning;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "van"){
			sound_play(global.sndSelect);
		}
		_race[i] = r;
	}
	// first chunk here happens at the start of the level, second happens in portal
	if(instance_exists(GenCont)) global.newLevel = 1;
	else if(global.newLevel){
		global.newLevel = 0;
	}
	var hadGenCont = global.hasGenCont;
	global.hasGenCont = instance_exists(GenCont);
	if (!hadGenCont && global.hasGenCont) {
		//
	}
	wait 1;
}

#define level_start
// turn back into van
with(instances_matching(Player, "race", "grunt")){
	if(player_get_race_pick(index) = "van"){
		race = "van";
	}
}

with(instances_matching(Player, "race", "inspector")){
	if(player_get_race_pick(index) = "van"){
		race = "van";
	}
}

with(instances_matching(Player, "race", "shielder")){
	if(player_get_race_pick(index) = "van"){
		race = "van";
	}
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprVanDrive;
spr_walk = sprVanDrive;
spr_hurt = sprVanHurt;
spr_dead = sprVanDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndVanHurt;
snd_dead = sndExplosion;

// stats
maxspeed = 5;
team = 2;
maxhealth = 262;
spr_shadow_y = 0;
mask_index = mskVan;
canwalk = 0;
right = choose(-1, 1);

// vars
melee = 1;	// can melee or not
stop_alarm = 0;	// it's time to stop
want_van = 50;	// time until van
sprite_change = false;	// sprites not changed


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

// sprite faces direction, as you have no weps
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

// movement
friction = 0;
direction = 90;

if(want_van <= 0){
	if(sprite_change = false){
		spr_idle = sprVanDrive;
		spr_walk = sprVanDrive;
		spr_hurt = sprVanHurt;
		spr_dead = sprVanDead;
		sprite_change = true;
	}
	with(collision_rectangle(x + 37, y + 22, x - 37, y - 22, Wall, 0, 1)){
		if(sprite_index != mskNone){
			if(x > other.x + 25){
				other.stop_alarm = 3;
			}
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
	}

	if(stop_alarm <= 0){
		x += maxspeed * right;
	}
	else if(stop_alarm <= 2){
		x += 3 + maxspeed * right;
	}

	if(stop_alarm >= 0){
		stop_alarm -= current_time_scale;
	}

	// outgoing contact damage
	with(collision_rectangle(x + 37, y + 22, x - 37, y - 22, enemy, 0, 1)){
		if(sprite_index != spr_hurt){
			my_health -= 20;
			sound_play_pitch(snd_hurt, random_range(0.9, 1.1));
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
}
else{
	if(
}

if(want_van >= 0){
	want_van -= current_time_scale;
}

#define race_name
// return race name for character select and various menus
return "VAN";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE";


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
return choose("OPEN UP", "POLICE", "PAGING ALL UNITS", "FREEZE!", "YES POPO");