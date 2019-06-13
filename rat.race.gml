#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprRatSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitRat.png",1 , 15, 185);
global.sprCheese = sprite_add("sprites/sprCheese.png", 7, 5, 5);

// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

// character select sounds
global.sndSelect = sound_add("sounds/sndRatSelect.ogg");
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "rat"){
			sound_play(global.sndSelect);
		}
		_race[i] = r;
	}

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
spr_idle = sprRatIdle;
spr_walk = sprRatWalk;
spr_hurt = sprRatHurt;
spr_dead = sprRatDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndRatHit;
snd_dead = sndRatDie;

// stats
damage_base = 2;
damage_buff = 4;
maxhealth_base = 7;
maxhealth_buff = 12;
maxspeed = 4;
maxhealth = 7;
damage = 2;
team = 2;
spr_shadow_y = 0;
mask_index = mskPlayer;
previousHealth = maxhealth;

// vars
melee = 1;	// can melee or not

#define level_start
with(instances_matching(Player, "race", "rat")){
	if(u1 == 1){
		repeat(5 + max(0, floor((GameCont.hard - 10)/4))){
			SpawnRat();
		}
	}
}

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

u1 = ultra_get(player_get_race(index), 1);
u2 = ultra_get(player_get_race(index), 2);

// sprite faces direction, as you have no weps
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
			my_health -= other.damage;
			sound_play_pitchvol(snd_hurt, random_range(0.9, 1.1), 0.65);
			sound_play_pitchvol(sndRatMelee,random_range(0.9,1.1), 0.65);
			sprite_index = spr_hurt;
			direction = other.direction;
		}
	}
}

//chese
with(enemy){
	if(my_health == 0){
		cheese = random(100);
		if(cheese < 25){
			with(instance_create(x,y,HPPickup)){
				sprite_index = global.sprCheese;
				num = 1 + skill_get(mut_second_stomach);
				if(crown_current == 4){
					num += 1;
				}
				cheese = true;
			}
		}
	}
}

if(u2 == 1){
	maxhealth = maxhealth_buff + (4 * skill_get(mut_rhino_skin));
	damage = damage_buff;
}

if(u1 == 1){
	if(my_health > previousHealth){
		diff = my_health - previousHealth;
		with(instances_matching(CustomHitme, "creator", self)){
			diff = other.diff;
			heal = min(diff, maxhealth - my_health);
			my_health = min(my_health + diff, maxhealth);
			if(heal == 0){
				t = "MAX HP!";
			} else {
				t = "+" + string(other.diff) + " HP";
			}
			instance_create(x,y,HealFX);

			with(instance_create(x,y,PopupText)){
				xstart = x;
				ystart = y;
				text = other.t;
				mytext = text;
				time = 10;
				target = 0;
			}
		}
		previousHealth = my_health;
	}
	if(my_health < previousHealth){
		previousHealth = my_health;
	}
}

#define SpawnRat
with(instance_create(x, y, CustomHitme)){
	name = "Rat_Friendly";
	creator = other;
	team = creator.team;
	spr_idle = sprRatIdle;
	spr_walk = sprRatWalk;
	spr_hurt = sprRatHurt;
	spr_dead = sprRatDead;
	snd_hurt = sndRatHit;
	snd_dead = sndRatDie;
	sprite_index = spr_idle;
	my_health = 7;
	maxspeed = 4;
	mask_index = mskMaggot;
	size = 1;
	image_speed = 0.3;
	spr_shadow = shd24;
	direction = random(360);
	move_bounce_solid(true);
	my_damage = 2;
	right = choose(-1, 1);
	alarm = [0];	// movement
	on_step = script_ref_create(rat_step);
	on_hurt = script_ref_create(rat_hurt);
	on_destroy = script_ref_create(rat_destroy);
	// friendly outline
	playerColor = player_get_color(creator.index);
	with(script_bind_draw(0, 0)){
		script = script_ref_create_ext("mod", "erace", "draw_outline", other.playerColor, other);
	}

	target = noone;
}



#define rat_step
if(my_health > 0){
	// speed management
	if(speed > maxspeed){
		speed = maxspeed;
	}

	// collision
	move_bounce_solid(true);
	
	// sprite facing based on direction
	if(speed > 0 and sprite_index != spr_hurt){
		sprite_index = spr_walk;
	}
	else if(sprite_index != spr_hurt){
		sprite_index = spr_idle;
	}
	
	if(direction > 90 and direction <= 270){
		right = -1;
	}
	else{
		right = 1;
	}
	// face right or left
	if(right = 1){
		image_xscale = 1;
	}
	else{
		image_xscale = -1;
	}
	
	// targeting
	var _p = creator;
	var _e = instance_nearest(x, y, enemy);
	if(instance_exists(_e) and distance_to_object(_e) < 100 and !collision_line(x, y, _e.x, _e.y, Wall, true, true)){
		if(target == _p or target == noone){instance_create(x,y-8,AssassinNotice)}
		target = _e;
	} else if(instance_exists(_p) and player_get_race(_p.index) == "rat" and distance_to_object(_p) < 100 and !collision_line(x, y, _p.x, _p.y, Wall, true, true)){
		target = _p;
	} else {
		target = noone;
	}
	
	// movement
		if(target = noone){	// no target, random movement
			if(alarm[0] <= 0){
				if(random(100) < 75){
					friction = 0.1;
					direction = random(360);
					move_bounce_solid(true);
					motion_set(direction, maxspeed);
				}

				alarm[0] = irandom_range(25, 35);
			}
		}
		else{
			if(alarm[0] <= 0){	// target, pursue
				direction = point_direction(x, y, target.x, target.y) + random_range(-15, 15);
				move_bounce_solid(true);
				motion_set(direction, maxspeed);
				friction = 0.15;
				alarm[0] = irandom_range(10, 15);
			}
		}
	

	
	_wStuck = instance_place(x,y,Wall);
	if(instance_exists(_wStuck)){
		if(place_meeting(x,y,_wStuck)){
			wall_stuck += 1;
			if(wall_stuck >= 15){
				with(_wStuck){
					instance_create(x,y,FloorExplo);
					instance_destroy();
				}
			}
		}
	} else {
		wall_stuck = 0;
	}

	// stop hurt sprite
	if(sprite_index = spr_hurt and image_index >= 2){
		sprite_index = spr_idle;
	}
	
	// alarm management
	for(i = 0; i < array_length_1d(alarm); i++){
		if(alarm[i] > 0){
			alarm[i]-= current_time_scale;
		}
	}
	
	// incoming/outgoing contact damage
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		with(instance_nearest(x, y, enemy)){
			if(sprite_index != spr_hurt){
				my_health -= 2;
				sound_play_pitchvol(snd_hurt, random_range(0.9, 1.1), 0.65);
				sound_play_pitchvol(sndRatMelee, random_range(0.9, 1.1), 0.65);
				sprite_index = spr_hurt;
			}
		}
	}
}
else{
	instance_destroy();
}

#define rat_destroy
	sound_play_pitchvol(snd_dead, random_range(0.9, 1.1), 0.65);

// corpse
with(instance_create(x, y, Corpse)){
	sprite_index = sprRatDead;
	size = 1;
}

#define rat_hurt(damage, kb_vel, kb_dir)
// incoming damage
if(sprite_index != spr_hurt){
	sound_play_pitchvol(snd_hurt, random_range(0.9,1.1), 0.65);
	my_health -= argument0;
	motion_add(argument2, argument1);
	nexthurt = 3;
	sprite_index = spr_hurt;
}

#define race_name
// return race name for character select and various menus
return "RAT";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE#@sENEMIES DROP @yCHEESE";


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
	case 1: return "RATALLION";
	case 2: return "WELL FED";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "@wSTART EACH LEVEL WITH A PACK OF @yRATS#@sHEALING ALSO AFFECTS FRIENDLY RATS";
	case 2: return "@sINCREASED @rHEALTH @sAND @yDAMAGE";
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
return choose("WHISKERS", "RABID", "ITCHY", "RODENT");