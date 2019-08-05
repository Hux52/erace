#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABgSURBVDhPY1jfn/WfEjxqwPAwAAhABE6MTRMyBqrBrhGGsWlCxkA12DXCMDZNyJjhyv71/5HxjqlVKJiQYcPFAGQN6AYiY2yGDRIDShOc4RhdEzIepAYgC5KCB4sBWf8B/5uAJW+PFKIAAAAASUVORK5CYIIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==", 1, 0, 0);
global.sprPortrait = sprite_add("/sprites/portrait/sprPortraitMaggot.png", 1, 22, 200);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Maggot.png", 1, 10, 10);

// character select sounds
global.sndSelect = sound_add("sounds/sndMaggotSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "maggot"){
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
spr_idle = sprMaggotIdle;
spr_walk = sprMaggotIdle;
spr_hurt = sprMaggotHurt;
spr_dead = sprMaggotDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndHitFlesh;
snd_dead = sndEnemyDie;

// stats
maxspeed = 2.5;
erace_maxspeed_orig = maxspeed;
team = 2;
maxhealth = 2;
spr_shadow = shd16;
spr_shadow_y = 0;
mask_index = mskMaggot;
canwalk = 1;
died = false;

type = "normal"; //types: meat, rad, 
_to = noone;

// vars
melee = 1;	// can melee or not


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

switch(type){
		case "meat":
			image_blend = make_color_hsv(0,169,200);
		break;
		case "rad":
			image_blend = c_lime;
		break;
		case "lightning":
			image_blend = make_color_hsv(140,200,255);
		break;
		case "plasma":
			image_blend = c_lime;
		break;
		case "fire":
			image_blend = c_yellow;
		break;
		default:
			image_blend = c_white;
		break;
}

// no weps
canswap = 0;
canpick = 0;

//no foodstep
footstep = 10;

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
			sound_play_pitchvol(snd_hurt, random_range(0.9, 1.1), 0.6);
			sound_play(sndMaggotBite);
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
}

if(type = "lightning"){
	if("lightning_timer" not in self){lightning_timer = 0;}
	if(lightning_timer > 0){
		lightning_timer -= current_time_scale;
	} else {
		lightning_timer = irandom_range(5,25);
		// sound_play_pitchvol(sndLightningHit,random_range(0.6,0.8), 0.5);
		num_lightning = irandom_range(1,3);
		randangle = random(360);
		for (i = 0; i < num_lightning; i++){
			with(instance_create(x + hspeed*2,y + vspeed*2,Lightning)){
				creator = other;
				image_angle = (360/creator.num_lightning)*creator.i + other.randangle;
				team = creator.team;
				ammo = 3;
				alarm_set(0,1);
			}
		}
	}
}

if(type = "fire"){
	if("fire_timer" not in self){fire_timer = 0;}
	if(fire_timer > 0){
		fire_timer -= current_time_scale;
	} else {
		fire_timer = irandom_range(5,25);
		// sound_play_pitchvol(sndLightningHit,random_range(0.6,0.8), 0.5);
		num_fire = irandom_range(2, 4);
		randangle = random(360);
		for (i = 0; i < num_fire; i++){
			with(instance_create(x,y,TrapFire)){
				creator = other;
				team = creator.team;
				direction = (360/creator.num_fire)*creator.i + creator.randangle;
				image_angle = direction;
				speed = 6;
				friction = 0.8;
				sprite_index = sprSalamanderBullet;
				damage = 2;
			}
		}
	}
}

if(my_health = 0){
	if(died = false){
	//create explosion
	switch(type){
		case "meat":
			repeat(3) {
				instance_create(x,y,MeatExplosion);
				with(instance_create(x,y,BloodStreak)){
					image_angle = random(360);
					speed = 8;
				}
			}
		break;
		case "rad":
			repeat(4){
				with(instance_create(x, y, HorrorBullet)){
					team = 2;
					damage = 2;
					direction = random(360);
					image_angle = direction;
					speed = random_range(6,8);
				}
			}
			instance_create(x,y,GammaBlast);
			//green shit
			instance_create(x,y,FishA);
			instance_create(x,y,LaserBrain);
		break;

		case "plasma":
			with(instance_create(x,y,PlasmaBall)){
				team = other.team;
				instance_destroy();
			}
		break;

		case "fire":
			repeat(irandom_range(6,8)) {
				with(instance_create(x,y,TrapFire)){
					creator = other;
					team = creator.team;
					direction = random(360);
					image_angle = direction;
					speed = 6;
					friction = 0.8;
					sprite_index = sprSalamanderBullet;
					damage = 2;
				}		
			}
		break;
	}
}

died = true;

	_to = mod_script_call("mod","erace","respawn_as", true, "maggot", "Maggot"); //reincarnation in tarnation
	if(instance_exists(_to)){
		type = _to.type;
		instance_delete(_to);
	}
} else {died = false;}

#define race_name
// return race name for character select and various menus
return "MAGGOT";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#CAN'T STAND STILL";


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
return 0;


#define race_skin_avail
// return if skin is unlocked
return 0;

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
return choose("HUNGRY", "WRIGGLE", "FAMILY", "PLEASE DON'T CALL ME THAT");