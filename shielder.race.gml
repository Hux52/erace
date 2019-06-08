#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprShielderSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitIDPDShielder.png", 1, 0, 205);

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
spr_idle = sprShielderIdle;
spr_walk = sprShielderWalk;
spr_hurt = sprShielderHurt;
spr_dead = sprShielderDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds- pick from male or female
if(random(1) < 0.5){
	snd_hurt = sndShielderHurtM;
	snd_dead = sndShielderDeadM;
	snd_entr = sndShielderEnterM;
	snd_shld = sndShielderShieldM;
}
else{
	snd_hurt = sndShielderHurtF;
	snd_dead = sndShielderDeadF;
	snd_entr = sndShielderEnterF;
	snd_shld = sndShielderShieldF;
}

// stats
maxspeed = 4;
team = 2;
maxhealth = 45;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
melee = 0;	// can melee or not
shield_time = 0;
shield_cool = 0;
want_shield = false;
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

if(canspec){
	if!(instance_exists(GenCont)){
		if(shield_cool <= 0){
			if(button_pressed(index, "spec") and shield_time < 35 and reload <= 0){
				if(shield_cool <= 0){
					want_shield = true;
					shield_cool = 15;
					sound_play_pitch(snd_shld, random_range(0.9, 1.1));
					with(instance_create(x, y, CrystalShield)){
						creator = other;
						team = creator.team;
						time = creator.shield_time;
						spr_shadow = shd24;
					}
				}
			}
		}
		if(button_check(index, "spec")){
			if(want_shield = true){
				if(shield_time < 35){
					canwalk = 0;
					reload = max(2, reload);
					can_shoot = 0;
					bcan_shoot = 0;
					clicked = 0;
					if(array_length_1d(instances_matching(CrystalShield, "creator", self)) > 0){
						var _shield = instances_matching(CrystalShield, "creator", self)[0];
						with(_shield){
							time = creator.shield_time;
							spr_shadow = shd24;
						}
					}
					shield_time += current_time_scale + (current_time_scale * ultra_get(mod_current, 1));
					shield_cool = 15;
				}
				else{
					if(ultra_get(mod_current, 1)){
						if!(collision_point(mouse_x[index], mouse_y[index] - 8, Wall, false, true)){
							if(collision_point(mouse_x[index], mouse_y[index] - 8, Floor, false, true)){
								sound_play(sndEliteShielderTeleport);
								x = mouse_x[index];
								y = mouse_y[index] - 8;
							}
						}
					}
					shield_time = 0;
					want_shield = false;
				}
			}
		}
	}
	else{
		shield_time = 0;
		want_shield = false;
		shield_cool = 0;
	}
}

if(button_released(index, "spec")){
	want_shield = false;
}
if(want_shield = false){
	shield_time = 0;
}
if(shield_time = 0){
	canwalk = 1;
	if(shield_cool > 0){
		shield_cool-= current_time_scale;
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


#define race_name
// return race name for character select and various menus
return "I.D.P.D. SHIELDER";


#define race_text
// return passive and active for character selection screen
return "CAN SHIELD@b#FREEZE!";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return "shielder";


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
	case 1: return "HYPERSPACE INSTALLMENT";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "TELEPORT AFTER SHIELDING";
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