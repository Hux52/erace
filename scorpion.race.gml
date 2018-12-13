#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAADJSURBVDhPrZK9DcJADEazBDuAxAAMQY2oKVOwADU1E2QGGlagZyAkg5Ge5VhOQuREetHd+b53P0lzv7VSoS74PvpKi/9QF2xWa1EQzZU15/1FInNkdcFxe5AxpkR2B1MMSeqC7A488ShRZHfASrHtySR1wXvXiELIQw0I92RZMEMn0+7tyk8aY1Cghe56ktfzYWifMdpRYMfCHsMItObDCGwHiwkIEWDM972EBU0Av2/r+gT8GLtbTuAn8Ichoh4lBgUfzAT5nFY+0Mns1z+fF7oAAAAASUVORK5CYII=", 1, 0, 0);


#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprScorpionIdle;
spr_walk = sprScorpionWalk;
spr_hurt = sprScorpionHurt;
spr_dead = sprScorpionDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndScorpionHit;
snd_dead = sndScorpionDie;

// stats
maxspeed = 5;
team = 2;
maxhealth = 15;
spr_shadow = shd32;
spr_shadow_y = 5;
mask_index = mskPlayer;

// vars
cooldown = 0;
venom = 0;
dir = 0;


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;

if(button_pressed(index, "spec")){
	if(cooldown = 0){
		cooldown = 60;
		venom = 15;
		dir = gunangle;
		spr_idle = sprScorpionFire;
		spr_walk = sprScorpionFire;
		sound_play(sndScorpionFireStart);
	}
}

if(venom > 0){
	canwalk = 0;
	move_bounce_solid(true);
	move_towards_point(x + lengthdir_x(maxspeed, direction), y + lengthdir_y(maxspeed, direction), maxspeed);
	if(dir > 90 and dir <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
	sound_play_gun(sndScorpionFire, 0.2, 0.6);
	with(instance_create(x, y, Bullet1)){
		var acc = 60;
		creator = other;
		team = creator.team;
		sprite_index = sprScorpionBullet;
		direction = other.dir + (random(creator.accuracy) * choose(1, -1) * random(acc));
		image_angle = direction;
		friction = 0;
		speed = 5;
		damage = 2;
	}
	venom--;
}
else{
	spr_idle = sprScorpionIdle;
	spr_walk = sprScorpionWalk;
	canwalk = 1;
}

if(cooldown > 0){
	cooldown--;
}

if(collision_rectangle(x + 20, y + 10, x - 20, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= 5;
			sound_play(snd_hurt);
			sprite_index = spr_hurt;
			sound_play(sndScorpionMelee);
		}
	}
}

if(my_health = 0){
	for(i = 0; i < 360; i += 120){
		with(instance_create(x, y, AcidStreak)){
			speed = 8;
			direction = other.i + random_range(-30, 30);
		}
	}
}

#define race_name
// return race name for character select and various menus
return "SCORPION";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#CAN SPRAY VENOM";


#define race_portrait
// return portrait for character selection screen and pause menu
return sprBigPortraitChickenHeadless;


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
return choose("HISS", "STINGER", "PINCH PINCH", "VENOMOUS");