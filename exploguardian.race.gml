#define init
global.sprMenuButton = sprite_add("sprites/sprExploGuardianSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("/sprites/sprPortraitMaggot.png", 1, 22, 200);

// character select sounds
global.sndSelect = sndExploGuardianCharge;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "exploguardian"){
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
spr_idle = sprExploGuardianIdle;
spr_walk = sprExploGuardianWalk;
spr_hurt = sprExploGuardianHurt;
spr_dead = sprExploGuardianDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndExploGuardianHurt;
snd_dead = sndExploGuardianDead;
snd_chrg = sndExploGuardianCharge;
snd_fire = sndExploGuardianFire;
snd_cgdd = sndExploGuardianDeadCharge;

// stats
maxspeed = 4;
team = 2;
maxhealth = 50;
spr_shadow = shd32;
spr_shadow_y = 5;
mask_index = mskPlayer;
canwalk = 1;

// vars
melee = 1;	// can melee or not
explo = 0;
died = 0;


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;
if(wep != 0){
	wep = 0;
}

// face direction you're moving in, as you have no weps
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

// outgoing contact damage
if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= 2;
			sound_play_hit(snd_hurt, 0.1);
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
}

if(button_pressed(index, "spec")){
	if(canspec = true and explo = 0){
		canwalk = 0;
		explo = 60;
		sound_play_pitch(snd_chrg, 1 + random_range(-0.1, 0.1));
		spr_idle = sprExploGuardianCharge;
		spr_walk = sprExploGuardianCharge;
		spr_hurt = sprExploGuardianChargeHurt;
		sprite_index = spr_idle;
		speed = 0;
	}
}

if(explo > 1){
	speed = 0;
	explo--;
}
else if(explo = 1){
	var _o = random(360);
	sound_play_pitch(snd_fire, 1 + random_range(-0.1, 0.1));
	for(i = 0 + _o; i < 360 + _o; i += 14){
		with(instance_create(x, y, Bullet1)){
			creator = other;
			team = creator.team;
			sprite_index = sprBullet2;
			mask_index = mskBullet2;
			speed = 12;
			direction = other.i;
			image_angle = direction;
			damage = 3;	// damage is normally 2 for exploguardian, this is player bullet damage
		}
	}
	spr_idle = sprExploGuardianIdle;
	spr_walk = sprExploGuardianWalk;
	spr_hurt = sprExploGuardianHurt;
	sprite_index = spr_idle;
	canwalk = 1;
	explo--;
}

if(distance_to_object(Portal) < 20){
	spr_idle = sprExploGuardianIdle;
	spr_walk = sprExploGuardianWalk;
	spr_hurt = sprExploGuardianHurt;
	sprite_index = spr_idle;
	canwalk = 1;
	explo = 0;
}

if(my_health <= 0){
	if(died = 0 and explo > 1){
		sound_dead = snd_cgdd;
		for(i = 0 + _o; i < 360 + _o; i += 14){
			with(instance_create(x, y, Bullet1)){
				creator = other;
				team = creator.team;
				sprite_index = sprBullet2;
				mask_index = mskBullet2;
				speed = 12;
				direction = other.i;
				image_angle = direction;
				damage = 3;
			}
		}
		died = 1;
	}
}

#define race_name
// return race name for character select and various menus
return "EXPLOGUARDIAN";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#CHARGE BURST";


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
return true;


#define race_menu_button
// return race menu button icon
sprite_index = global.sprMenuButton;

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
return choose("RADICAL");