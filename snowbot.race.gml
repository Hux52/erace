#define init
// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

// charselect sprite
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAADMSURBVDhPzZG9DcIwEIXdsgELUMEGCDECOyCKtBkkTXZAoqJHjOMhSHfkWXrWCxgbEYIovii5u/fFP26/mpvinDPv/QDUtK8z4wUs5NAfqOg7gqpuTDlfrhHWVNIeFoEngQZvXRfgd0rAVUwjeAT9MNxDQZT8n6CfsuNsGSgJwHjBerszQJGdNlHAGvpFQW4F0wq4TA6nSAXB29eYFeABUkGCfkoAHF8oSqEBnQ9no4VXaFDnB4JPwNn9XsBtYflBUNon4XUjyHBVN3YHHHs+RZb9XysAAAAASUVORK5CYII=", 1, 0, 0);

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
spr_idle = sprSnowBotIdle;
spr_walk = sprSnowBotWalk;
spr_hurt = sprSnowBotHurt;
spr_dead = sprSnowBotDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndSnowBotHurt;
snd_dead = sndSnowBotDead;

// stats
maxspeed = 2;
team = 2;
maxhealth = 15;
spr_shadow_y = 0;
spr_shadow = shd24;
mask_index = mskPlayer;

// vars
spr_fire = sprSnowBotFire;	// charging sprite
charge = 0;	// charging duration
loop = 0;	// looped sound
fric = 10;	// control the player has while charging- the higher, the more control
car = 0;	// has car or not
lift = 0;	// lifting car duration



#define level_start
// stop charging between levels
with(instances_matching(Player, "race", "snowbot")){
	charge = 0;
	canwalk = 1;
	spr_idle = sprSnowBotIdle;
	spr_walk = sprSnowBotWalk;
	sound_stop(loop);
}

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no wep
canswap = 0;
canpick = 0;

// sprite faces direction when unequipped, as you have no weapon
if(car = 0){
	if(direction > 90 and direction <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
}

// special- charge
if(button_pressed(index, "spec")){
	if(canspec = 1 and charge = 0 and car = 0){	// if no car and not already charging
		// charge init
		spr_idle = spr_fire;
		spr_walk = spr_fire;
		sound_play(sndSnowBotSlideStart);
		loop = sound_loop(sndSnowBotSlideLoop);
		charge = 60;
	}
}

if(charge > 0){
	// if charging
	if(charge > 1){
		// disable normal controls
		canwalk = 0;
		// crazy bullshit for limited control
		if(button_check(index, "nort")){
			if(button_check(index, "east")){
				if(direction > 45 and direction < 225){
					direction -= fric;
				}
				else{
					direction += fric;
				}
			}
			else if(button_check(index, "west")){
				if(direction > 135 and direction < 315){
					direction -= fric;
				}
				else{
					direction += fric;
				}
			}
			else{
				if(direction > 85 and direction < 265){
					direction -= fric;
				}
				else{
					direction += fric;
				}
			}
		}
		else if(button_check(index, "sout")){
			if(button_check(index, "east")){
				if(direction < 315 and direction > 135){
					direction += fric;
				}
				else{
					direction -= fric;
				}
			}
			else if(button_check(index, "west")){
				if(direction < 225 and direction > 45){
					direction += fric;
				}
				else{
					direction -= fric;
				}
			}
			else{
				if(direction < 265 and direction > 85){
					direction += fric;
				}
				else{
					direction -= fric;
				}
			}
		}
		else if(button_check(index, "east")){
			if(direction > 0 and direction < 180){
				direction -= fric;
			}
			else{
				direction += fric;
			}
		}
		else if(button_check(index, "west")){
			if(direction > 180 and direction < 360){
				direction -= fric;
			}
			else{
				direction += fric;
			}
		}
		motion_add(direction, maxspeed + 4);
		instance_create(x, y, Dust);
		if(collision_rectangle(x + 15, y + 15, x - 15, y - 10, enemy, 0, 1)){
			with(instance_nearest(x, y, enemy)){
				if(sprite_index != spr_hurt){
					my_health -= 4;
					sound_play(snd_hurt);
					sprite_index = spr_hurt;
				}
			}
		}
	}
	else if(charge = 1){
		// charge end, return to normal
		canwalk = 1;
		spr_idle = sprSnowBotIdle;
		spr_walk = sprSnowBotWalk;
		sound_stop(loop);
	}
	charge--;
}

// pickup car
if(distance_to_object(Car) < 20){
	// car sprite
	var _c = instance_nearest(x, y, Car);
	if(_c.spr_idle = sprCarIdle){
		car = 1;
		spr_carc = [sprSnowBotRedCarIdle, sprSnowBotRedCarWalk, sprSnowBotRedCarHurt, sprSnowBotRedCarLift, sprSnowBotRedCarThrow]
	}
	else{
		car = 1;
		spr_carc = [sprSnowBotCarIdle, sprSnowBotCarWalk, sprSnowBotCarHurt, sprSnowBotCarLift, sprSnowBotCarThrow]
	}
	instance_delete(_c);	// pickup car without blowing it up
	// stop charging
	charge = 0;
	canwalk = 1;
	spr_idle = sprSnowBotIdle;
	spr_walk = sprSnowBotWalk;
	sound_stop(loop);
	// start lifting anim
	lift = 6;
}

// lifting anim
if(lift > 0){
	if(lift > 1){
		spr_idle = spr_carc[3];
		spr_walk = spr_carc[3];
		spr_hurt = spr_carc[2]
	}
	else if(lift = 1){
		spr_idle = spr_carc[0];
		spr_walk = spr_carc[1];
	}
	lift--;
}

// spec b- throw car
if(button_pressed(index, "spec") or button_pressed(index, "fire")){	// included fire as this can be confusing
	if(lift = 0 and car = 1){
		spr_idle = sprSnowBotIdle;
		spr_walk = sprSnowBotWalk;
		// car projectile creation
		with(instance_create(x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), CarThrow)){
			creator = other;
			team = other;
			speed = 18;
			direction = other.gunangle;
			image_angle = direction;
		}
		// no longer has car
		car = 0;
	}
}

// stop that infernal racket
if(my_health = 0){
	sound_stop(loop);
}

#define race_name
// return race name for character select and various menus
return "SNOWBOT";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#CHARGE#THROW CARS";


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
return choose("STEEL", "HEAVY METAL", "COMING THROUGH", "SNOWBOT CAN PICK UP CARS");