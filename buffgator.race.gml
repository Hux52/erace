#define init
// character select button

global.sprMenuButton = sprite_add("sprites/selectIcon/sprGatorSelect.png", 1, 0,0);
global.sprBuffGatorSmoke = sprite_add("sprites/sprBuffGatorSmoke.png", 8, 16, 16);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitBuffGator.png", 1, 15, 200);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Crocodile.png", 1, 10, 10);
#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player


// sprites
spr_idle = sprBuffGatorIdle;
spr_walk = sprBuffGatorWalk;
spr_hurt = sprBuffGatorHurt;
spr_dead = sprBuffGatorDead;
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

// sounds
snd_hurt = sndBuffGatorHit;
snd_dead = sndBuffGatorDie;

// stats
maxspeed = 3;
team = 2;
maxhealth = 30;
melee = 0;	// can melee or not
weapon_custom_delay = -1; //for shotgun delay
spr_smoke_current = global.sprBuffGatorSmoke;
spr_idle_current = sprBuffGatorIdle;

//active ability stuff
smoke_buff = 0; 
smoke_buff_bullets = 0;
smoke_buff_max_bullets = 3;
smoke_buff_threshold = 45;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;

// ULTRA A: EVOLUTION - BUFF GATOR
if(wep != "gator_flakcannon"){
	wep = "gator_flakcannon";
}

if(button_check(index, "spec")){
	canwalk = false;
	spr_idle = spr_smoke_current;
	if(smoke_buff_bullets < smoke_buff_max_bullets && speed < 1){
		smoke_buff += (smoke_buff_bullets + 1) * current_time_scale;
		if (smoke_buff >= smoke_buff_threshold){	
			smoke_buff = 0;
			smoke_buff_bullets += 1;
			sound_play_pitchvol(sndSlider, 0.9 + (smoke_buff_bullets*0.1), 1)
			sound_play_pitchvol(sndSliderLetGo, 0.9 + (smoke_buff_bullets*0.1), 1)
		}
	}
} else {
	canwalk = true;
	spr_idle = spr_idle_current;
		if(smoke_buff > 0){
		smoke_buff -= 0.5 * current_time_scale * (smoke_buff_bullets + 1);
		}
	}

if(reload > weapon_get_load(wep)-2){
	if(smoke_buff_bullets > 0){
		reload = reload / 3;
		smoke_buff_bullets -= 1;
	}
}

if(reload <= 1) reload = 0;
	
#define draw
origalpha = draw_get_alpha();
smoke_buff_offsetx = 11;
smoke_buff_offsety = 20;
draw_set_color(c_red);
draw_set_alpha(0.4);
if(smoke_buff_bullets = 0 && smoke_buff > 0){
	draw_rectangle(x - smoke_buff_offsetx, y - smoke_buff_offsety, x - smoke_buff_offsetx + 4, y - smoke_buff_offsety - ((smoke_buff/smoke_buff_threshold)*8), false);
	}
if(smoke_buff_bullets = 1 && smoke_buff > 0){
	draw_rectangle(x - smoke_buff_offsetx + 8, y - smoke_buff_offsety, x - smoke_buff_offsetx +  8 + 4, y - smoke_buff_offsety - ((smoke_buff/smoke_buff_threshold)*8), false);
	}
if(smoke_buff_bullets = 2 && smoke_buff > 0){
	draw_rectangle(x - smoke_buff_offsetx + 16, y - smoke_buff_offsety, x - smoke_buff_offsetx +  16 + 4, y - smoke_buff_offsety - ((smoke_buff/smoke_buff_threshold)*8), false);
	}

draw_set_alpha(1);
for (i = 0; i < smoke_buff_bullets; i++){
	if (i < 3){
	draw_set_color(c_red);
	draw_rectangle(x - smoke_buff_offsetx + 8*i, y - smoke_buff_offsety, x - smoke_buff_offsetx + 8*i + 4, y - 28, false);

	draw_set_color(c_yellow);
	draw_rectangle(x - smoke_buff_offsetx + 8*i, y - smoke_buff_offsety, x - smoke_buff_offsetx + 8*i + 4, y - 22, false);
	}
}

draw_set_alpha(origalpha);

#define race_name
// return race name for character select and various menus
return "Buff Gator";


#define race_text
// return passive and active for character selection screen
return "@sCAN @ySMOKE";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return "gator_flakcannon";


#define race_avail
// return if race is unlocked
return false;


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
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	default: return "";
}


#define race_ultra_button
// called by ultra mutation button on creation
// recieves ultra mutation index
switch(argument0){
	case 1: return mskNone;
	case 2: return mskNone;
}


#define race_ultra_take
// recieves ultra mutation index
// called when ultra for race is picked
// player of race may not be alive at the time


#define race_ttip
// return character-specific tooltips
return choose("Chomp", "Smells like home", "Tail whip", "Watch the tail");