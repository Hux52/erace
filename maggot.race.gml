#define init
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAYAAADzoH0MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABgSURBVDhPY1jfn/WfEjxqwPAwAAhABE6MTRMyBqrBrhGGsWlCxkA12DXCMDZNyJjhyv71/5HxjqlVKJiQYcPFAGQN6AYiY2yGDRIDShOc4RhdEzIepAYgC5KCB4sBWf8B/5uAJW+PFKIAAAAASUVORK5CYIIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==", 1, 0, 0);
global.sprPortrait = sprite_add("/sprites/sprPortraitMaggot.png", 1, 22, 200);

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
			sound_play(snd_hurt);
			sound_play(sndMaggotBite);
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
}

//respawn as other maggot
_maggots = instances_matching(CustomHitme, "name", "Maggot");
	if(my_health = 0){ //reincarnation in tarnation
if(array_length(_maggots) > 0){
	choice = irandom(array_length(_maggots) - 1);
	_b = _maggots[choice];
		with(instance_create(x,y,Corpse)){
			sprite_index = other.spr_dead;
			size = 1;
			direction = other.direction;
			speed = other.speed;
			friction = 0.4;
		}
		x = _b.x;
		y = _b.y;
		my_health = ceil(_b.my_health);
		canspirit = true;
		sound_play_pitchvol(sndStrongSpiritGain,0.8 + random_range(-0.1,0.1),0.2);
		sound_play_pitchvol(sndStrongSpiritLost,0.6 + random_range(-0.1,0.1),0.2);
		sound_play_pitchvol(sndBigMaggotUnburrow,0.7 + random_range(-0.1,0.1),0.9);

		instance_create(x,y,MeatExplosion);

		t = choose("BORN ANEW!", "RETURN TO LIFE!", "ONCE MORE!", "EXTRA LIFE!", "I'M BACK!");
		with(instance_create(x,y,PopupText)){
			xstart = x;
			ystart = y;
			text = other.t;
			mytext = other.t;
			time = 10;
			target = 0;
		}
		instance_delete(_b);
	}
}

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
return choose("HUNGRY", "WRIGGLE", "FAMILY", "PLEASE DON'T CALL ME THAT");