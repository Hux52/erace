#define init
global.sprMenuButton = sprite_add("sprites/sprInspectorSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/sprPortraitIDPDInspector.png",1 , 15, 200);

// character select sounds
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprInspectorIdle;
spr_walk = sprInspectorWalk;
spr_hurt = sprInspectorHurt;
spr_dead = sprInspectorDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds- pick from male or female
if(random(1) < 0.5){
	snd_hurt = sndInspectorHurtM;
	snd_dead = sndInspectorDeadM;
	snd_wrld = sndInspectorEnterM;
	snd_strt = sndInspectorStartM;
	snd_stop = sndInspectorEndM;
}
else{
	snd_hurt = sndInspectorHurtF;
	snd_dead = sndInspectorDeadF;
	snd_wrld = sndInspectorEnterF;
	snd_strt = sndInspectorStartF;
	snd_stop = sndInspectorEndF;
}

// stats
maxspeed = 4;
team = 2;
maxhealth = 10;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
melee = 0;	// can melee or not
startsound = -4;
stopsound = -4;
_to = noone;



#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

// no weps
canswap = 0;
canpick = 0;

pullStrength = 0.75 * current_time_scale + ultra_get(mod_current, 1);	// telekinesis strength

// telekinesis
if(canspec){
	if(button_pressed(index, "spec")){
		startsound = sound_play_pitch(snd_strt, random_range(0.9, 1.1));
		if(stopsound != -4){
			sound_stop(stopsound);
		}
	}
	if(button_check(index, "spec")){
		toDrawOn = self;
		script_bind_draw(draw_tele, depth, toDrawOn);
		with(enemy){
			var _p = other;
			if(distance_to_object(_p) < 100){
				var pdir = point_direction(x, y, _p.x, _p.y);
				x += lengthdir_x(other.pullStrength, pdir); // hey pdir
				y += lengthdir_y(other.pullStrength, pdir);
			}
		}
		with(projectile){
			var _p = other;
			if(team != _p.team){
				if(distance_to_object(_p)){
					var pdir = point_direction(x, y, _p.x, _p.y) + 180;
					x += lengthdir_x(other.pullStrength, pdir);
					y += lengthdir_y(other.pullStrength, pdir);
				}
			}
		}
		with(Pickup){
			var _p = other;
			if(distance_to_object(_p) < 100){
				var pdir = point_direction(x, y, _p.x, _p.y);
				x += lengthdir_x(other.pullStrength, pdir);
				y += lengthdir_y(other.pullStrength, pdir);
			}
		}
		with(chestprop){
			var _p = other;
			if(distance_to_object(_p) < 100){
				var pdir = point_direction(x, y, _p.x, _p.y);
				x += lengthdir_x(other.pullStrength, pdir);
				y += lengthdir_y(other.pullStrength, pdir);
			}
		}
		with(RadChest){
			var _p = other;
			if(distance_to_object(_p) < 100){
				var pdir = point_direction(x, y, _p.x, _p.y);
				x += lengthdir_x(other.pullStrength, pdir);
				y += lengthdir_y(other.pullStrength, pdir);
			}
		}
	}
	else if(button_released(index, "spec")){
		stopsound = sound_play_pitch(snd_stop, random_range(0.9, 1.1));
		if(startsound != -4){
			sound_stop(startsound);
		}
	}
}

if(my_health <= 0){
	if(instance_exists(CustomHitme)){
		sq = instances_matching(CustomHitme, "name", "squad");
		if(array_length(sq) > 0){
			_to = sq[0];
		}
	}
	if(instance_exists(_to)){
		mod_script_call("mod","erace","respawn_as", true, _to.class, "squad");
	}
}

#define draw_tele(toDrawOn)
if(instance_exists(toDrawOn)){
	with(toDrawOn){
		draw_sprite_ext(sprMindPower, -1, x, y, image_xscale * right, image_yscale, image_angle, c_white, 1);
	}
}
instance_destroy();

#define race_name
// return race name for character select and various menus
return "I.D.P.D. INSPECTOR";


#define race_text
// return passive and active for character selection screen
return "@sHAS @wTELEKINESIS#@sTHROW @bGRENADES@b#FREEZE!";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return "inspector";


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
	case 1: return "BRAIN TRAINING";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "STRONGER TELEKINESIS";
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
return choose("FREEZE!", "HANDS IN THE AIR", "BATON SWINGIN', JUSTICE BRINGIN'", "WEE WOO", "ON PATROL");