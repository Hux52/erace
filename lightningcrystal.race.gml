#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprLaserCrystalSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitLightningCrystal.png",1 , 30, 195);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_LightningCrystal.png", 1, 10, 10);

// character select sounds
// global.sndSelect = sound_add("sounds/sndRatSelect.ogg");
// var _race = [];
// for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
// while(true){
// 	//character selection sound
// 	for(var i = 0; i < maxp; i++){
// 		var r = player_get_race(i);
// 		if(_race[i] != r && r = "rat"){
// 			sound_play(global.sndSelect);
// 		}
// 		_race[i] = r;
// 	}
// 	wait 1;
// }

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprLaserCrystalIdle;
spr_walk = sprLaserCrystalIdle;
spr_hurt = sprLaserCrystalHurt;
spr_dead = sprLaserCrystalDead;
spr_fire = sprLaserCrystalFire; //for when it's firing lol good explanation right
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndLaserCrystalHit;
snd_dead = sndLaserCrystalDeath;
snd_charge = sndLaserCrystalCharge; //no idea what this is for
snd_fire = sndLightningPistol;

// stats
maxspeed = 1.1;
team = 2;
maxhealth = 45;
spr_shadow_y = 8;

//attack
lightningCountBase = 4;
lightningChargeBase = 24;
lightningDelayBase = 5;
lightningCooldownBase = 30;

lightningCount = 4;
lightningCharge = 24;
lightningDelay = 5;
lightningCooldown = 30;

lightningDamage = 2;

lightningFiring = false;
canlightning = true;

// vars
melee = false;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

footstep = 10;

//passive: is floaty
friction = 0.2;

// sprite always faces the same way and doesn't flip
right = -1;

// constant movement
if(canwalk = 1){
	move_bounce_solid(true);
	motion_add(direction, maxspeed/2);
}

if(lightningCooldown > 0){
	canlightning = false;
} else {
	canlightning = true;
}

if(button_pressed(index,"fire")){
	if(canlightning){
		lightningFiring = true;
		sound_play(snd_charge);
	}
}

if(lightningFiring){
	canwalk = false;
	sprite_index = spr_fire;
	lightningCooldown = lightningCooldownBase;
	if(lightningCharge > 0){
		lightningCharge -= current_time_scale;
	} else {
		if(lightningCount > 0){
			if(lightningDelay <= 0){
				//spawn lightning
				sound_play_pitchvol(snd_fire, random_range(0.9,1.1), 0.6);
				d = point_direction(x,y,mouse_x[index],mouse_y[index]);
				with(instance_create(x,y,EnemyLaser)){
					damage = 2;
					team = other.team;
					direction = other.d + random_range(-3,3);

					image_angle = direction;
					alarm0 = 1;
				}
				lightningCount -= 1;
				lightningDelay = laserDelayBase;
			}
			lightningDelay -= 1 * current_time_scale;
		} else {
			lightningFiring = false; //stop firing
		}
	}
} else {
	//reset everything
	canwalk = true;
	lightningCooldown -= 1 * current_time_scale;
	lightningCharge = laserChargeBase;
	lightningCount = laserCountBase;
}

// outgoing contact damage
if(collision_rectangle(x + 4, y + 6, x - 5, y - 5, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			projectile_hit_push(self, 20, 4);
		}
	}
}

#define laser_charge_step
if(point_distance(x,y,destX,destY) <= 5){
	instance_destroy();
}

#define race_name
// return race name for character select and various menus
return "LASER CRYSTAL";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#SHOOTS @rLASERS";


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
	case 1: return "CURSED";
	case 2: return "LIGHTNING";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "WIP";
	case 2: return "WIP";
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
// switch(argument0){
// 	case 1: 
// 		global.snd_dead_current = global.hitSounds[irandom(array_length(global.hitSounds))];
// 		global.snd_hurt_current = global.deathSounds[irandom(array_length(global.deathSounds))];
// 	break;
// }

#define race_ttip
// return character-specific tooltips
return false