#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprTurtleSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitTurtle.png",1 , 0, 200);
global.sprWhirlwind = sprite_add("sprites/boom.png", 1, 200, 150);

// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

// character select sounds
// global.sndSelect = sound_add("sounds/sndRatSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "rat"){
			// sound_play(global.sndSelect);
		}
		_race[i] = r;
	}
	wait 1;
}

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
spr_idle = sprTurtleIdle;
spr_walk = sprTurtleIdle;
spr_hurt = sprTurtleHurt;
spr_dead = sprTurtleDead;
spr_fire = sprTurtleFire;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndTurtleHurt;
snd_dead = choose(sndTurtleDead1, sndTurtleDead2, sndTurtleDead3, sndTurtleDead4);

// stats
maxspeed = 4.5;
team = 2;
maxhealth = 15;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
melee = 1;	// can melee or not
spin_time = 0;	// spin alarm
spin_angle = 0;	// delayed angle
spinning = false;
myWhirl = noone;
spinDuration = 0;

#define level_start
with(instances_matching(Player, "race", "turtle")){
	myWhirl = noone;
	spinDuration = 0;
}

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

u1 = ultra_get(player_get_race(index), 1);

// no weps
canswap = 0;
canpick = 0;
canwalk = 0;

footstep = 10;

if(wep != 0){
	wep = 0;
}

// sprite faces direction, as you have no weps
if(direction > 90 and direction <= 270){
	right = -1;
}
else{
	right = 1;
}

if(button_pressed(index,"fire")){
	spin_angle = gunangle;
}

spinning = button_check(index,"fire");

if(u1 = 1){ //ultra A
	if(instance_exists(myWhirl) == false){
		myWhirl = instance_create(x,y,CustomObject);
		with(myWhirl){
			name = "Whirlwind";
			creator = other;
			sprite_index = global.sprWhirlwind;
			image_speed = 0;
			scl = 0;
			flip = 1;
			flipTimer = 0;
			on_step = script_ref_create(whirlwind_step);
		}
	}
}

// spinning
if(spinning){
	move_bounce_solid(false);
	spinDuration += current_time_scale;
	// angle
	var _pd = gunangle;
	var _dd = angle_difference(spin_angle, _pd);
	spin_angle -= min(abs(_dd), 10) * sign(_dd) * current_time_scale;
	// movement
	move_bounce_solid(true);
	motion_add(spin_angle, maxspeed / 4);
	if(sprite_index != spr_hurt){
		sprite_index = spr_fire;
	}
}
else{
	spinDuration = lerp(spinDuration, 0, 0.01);
}

// outgoing contact damage
if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			my_health -= 2;
			sound_play_pitch(snd_hurt, random_range(0.9, 1.1));
			sound_play_pitch(sndTurtleMelee, random_range(0.9, 1.1));
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
}

#define whirlwind_step
if("creator" in self){
	if (instance_exists(creator)){
		flipTimer += current_time_scale;
		flipThreshold = scl * 10;
		if(flipTimer >= flipThreshold){			
			flip *= -1;
			flipTimer = 0;
		}
		x = creator.x;
		y = creator.y;
		scl = min(creator.spinDuration/150, 1.5); //between 0 and 1.5
		forceRadius = 100 * scl;
		force = scl/3;

		if(creator.spinDuration < 250){
			image_alpha = sin(creator.spinDuration/100) - 0.3;
		} else {
			image_alpha = 0.3;
		}

		image_xscale = scl * flip;
		image_yscale = scl;

		with(Corpse){
			if("factor_absolute" not in self){
				factor_absolute = random_range(0.4,1);
			}
			dist = point_distance(x,y,other.x,other.y);
			if(dist < other.forceRadius){
				factor_a = 1-(dist/other.forceRadius);
				factor_p = (dist/other.forceRadius) * 2;
				f = other.force;
				p = point_direction(x,y,other.x,other.y);
				a = p + 90;
				motion_add(p, f * factor_p * 2 * factor_absolute);
				motion_add(a, f * factor_a * factor_absolute);
			}
			speed = clamp(speed, 0, 15);
			if(speed > 12){
				with(instance_place(x,y,enemy)){
					if(sprite_index != spr_hurt){
						my_health -= floor(other.speed/10);
						sound_play_pitch(snd_hurt, random_range(0.9, 1.1));
						sprite_index = spr_hurt;
						direction = other.direction;
					}
				}
			}
			if(speed == 15){
				if(place_meeting(x + hspeed, y + vspeed, Wall)){
					_w = instance_nearest(x + hspeed, y + vspeed, Wall);
					with(_w){
						instance_create(x,y,FloorExplo);
						instance_destroy();
					}
				}
			}
		}
	} else {
		instance_destroy();
	}
}

#define race_name
// return race name for character select and various menus
return "TURTLE";


#define race_text
// return passive and active for character selection screen
return "CAN SPIN#CONTACT DAMAGE";


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
	case 1: return "@qV@qO@qR@qT@qE@qX";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "@qS@qU@qC@qC";
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
return choose("THE ORIGINAL MUTANT", "ADOLESCENCE", "SMELLS GOOD", "PIZZA TIME", "MARTIAL ARTS");