#define init
// character select button
global.sprMenuButton = sprite_add("sprites/selectIcon/sprTurretSelect.png", 1, 0,0);
// character select portrait
global.sprPortrait = sprite_add("/sprites/portrait/sprPortraitTurret.png", 1, 30, 197);

global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Turret.png", 1, 10, 10);

global.sprDisappear = sprite_add("/sprites/sprTurretDisappear.png", 11, 12, 12);

// level start init- MUST GO AT END OF INIT
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;
global.sndSelect = sndTurretSpawn;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "turret"){
			sound_play(global.sndSelect);
		}
		_race[i] = r;
	}
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

#define level_start
with(instances_matching(Player, "race", mod_current)){
	want_show = false;	// if appear event should proc
	want_stop = false;	// if stop event should proc
	show_anim = 0;	// appear handler
	hide_anim = 0;	// disappear handler
	cooldown = 30;	// cooldown between teleport
	can_tele = false;	// teleport destination coordinate validity
	cooldown = 30;
	want_show = false;	// disable this from happening again right now
	want_stop = true;	// init stop event handler
	// force show sprite
	spr_idle = spr_show;
	spr_walk = spr_show;
	sprite_index = spr_show;
	image_index = 0;
	mask_index = mskNone;	// do not allow damage right now, please
	show_anim = 22;	// init show anim alarm
	// make wall to hide player
	with(instance_create(x, y, Wall)){
		creator = other;
		mask_index = mskNone;
		sprite_index = mskNone;
		spr_shadow = shd24;
		topspr = mskNone;
		outspr = mskNone;
		name = "turret_view";
	}
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprTurretIdle;
spr_walk = sprTurretIdle; // lol
spr_show = sprTurretAppear;
spr_hide = global.sprDisappear;
spr_hurt = sprTurretHurt;
spr_dead = sprTurretDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndTurretHurt;
snd_dead = sndTurretDead;

// stats
maxspeed = 0;
team = 2;
maxhealth = 40;
melee = 0;	// can melee or not
want_show = false;	// if appear event should proc
want_stop = false;	// if stop event should proc
show_anim = 0;	// appear handler
hide_anim = 0;	// disappear handler
cooldown = 30;	// cooldown between teleport
can_tele = false;	// teleport destination coordinate validity

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init

#define step
// executed within each player instance of this race after step
// most actives and passives handled here
canswap = 0;
canpick = 0;
canwalk = 0;
friction = 69;
image_speed = 0.5;

if(wep != "turret"){
	wep = "turret";
}

if(button_pressed(index, "spec")){
	if(canspec = 1 and want_show = 0 and want_stop = 0 and show_anim <= 0 and hide_anim <= 0 and cooldown <= 0){	// basically, if not teleporting and cooldown allows
		if!(collision_point(mouse_x[index], mouse_y[index] - 8, Wall, false, true)){	// if mouse IS NOT touching wall
			if(collision_point(mouse_x[index], mouse_y[index] - 8, Floor, false, true)){	// if mouse IS touching floor
				can_tele = false;
				// log coordinates for later and check for wall
				coords[0] = mouse_x[index];
				coords[1] = mouse_y[index] - 8;
				coords[0] = round(coords[0]);
				coords[1] = round(coords[1]);
				var _x1 = coords[0];
				var _x2 = coords[0];
				var _y1 = coords[1];
				var _y2 = coords[1];
				
				// nearest 8 x
				while(_x1 % 8 != 0){
					_x1--;
				}
				while(_x2 % 8 != 0){
					_x2++;
				}
				if(_x1 < _x2){
					coords[0] = _x1;
				}
				else if(_x2 < _x1){
					coords[0] = _x2;
				}
				else{
					coords[0] = _x1;
				}
				
				// nearest 8 y
				while(_y1 % 8 != 0){
					_y1--;
				}
				while(_y2 % 8 != 0){
					_y2++;
				}
				if(_y1 < _y2){
					coords[1] = _y1;
				}
				else if(_y2 < _y1){
					coords[1] = _y2;
				}
				else{
					coords[1] = _y1;
				}
				
				// wall checks
				// just swap x
				if(place_meeting(coords[0], coords[1], Wall)){
					if(coords[0] = _x1){
						coords[0] = _x2;
					}
					else{
						coords[0] = _x1;
					}
				}
				else{
					can_tele = 1;
				}
				
				// just swap y (swap x back)
				if(place_meeting(coords[0], coords[1], Wall)){
					if(coords[0] = _x1){
						coords[0] = _x2;
					}
					else{
						coords[0] = _x1;
					}
					if(coords[1] = _y1){
						coords[1] = _y2;
					}
					else{
						coords[1] = _y1;
					}
				}
				else{
					can_tele = 1;
				}
				
				// swap x and y
				if(place_meeting(coords[0], coords[1], Wall) and can_tele = 0){
					if(coords[1] = _y1){
						coords[1] = _y2;
					}
					else{
						coords[1] = _y1;
					}
					if(coords[1] = _y1){
						coords[1] = _y2;
					}
					else{
						coords[1] = _y1;
					}
				}
				else{
					can_tele = 1;
				}
				
				if(can_tele = 1){	// if destination coordinates are valid
					hide_anim = 22;	// hide anim alarm init
					cooldown = 30;
					sound_play_pitch(sndTurretSpawn, random_range(0.9, 1.1));
				}
			}
		}
	}
}

// hide anim just started
if(hide_anim = 22){
	mask_index = mskNone;
	// force hide sprite
	spr_idle = spr_hide;
	spr_walk = spr_hide;
	if(sprite_index != spr_hurt){
		sprite_index = spr_hide;
	}
	want_show = true;	// show me appear anim when the time comes (handles NOT showing me, as well)
	// make wall to hide player
	with(instance_create(x, y, Wall)){
		creator = other;
		mask_index = mskNone;
		sprite_index = mskNone;
		spr_shadow = shd24;
		topspr = mskNone;
		outspr = mskNone;
		name = "turret_view";
	}
}

// hide anim alarm handler
if(hide_anim >= 0){
	hide_anim -= current_time_scale;
}

// show anim proc
if(hide_anim <= 0 and want_show = 1){	// if hide_anim just hit bottom, essentially
	x = coords[0];
	y = coords[1];
	sound_play_pitch(sndTurretSpawn, random_range(0.9, 1.1));
	want_show = false;	// disable this from happening again right now
	want_stop = true;	// init stop event handler
	// force show sprite
	spr_idle = spr_show;
	spr_walk = spr_show;
	sprite_index = spr_show;
	mask_index = mskNone;	// do not allow damage right now, please
	show_anim = 22;	// init show anim alarm
	// destroy any old walls hiding player
	with(instances_matching(Wall, "creator", self)){
		instance_delete(self);
	}
	// make wall to hide player
	with(instance_create(x, y, Wall)){
		creator = other;
		mask_index = mskNone;
		sprite_index = mskNone;
		spr_shadow = shd24;
		topspr = mskNone;
		outspr = mskNone;
		name = "turret_view";
	}
}

// show anim alarm handler
if(show_anim >= 0){
	show_anim -= current_time_scale;
}

if(show_anim <= 0){	// if show_anim at bottom
	if(want_stop){	// to prevent stop event from occuring multiple times
		// force sprites back to normal
		spr_idle = sprTurretIdle;
		spr_walk = sprTurretIdle;
		if(sprite_index != spr_hurt){
			sprite_index = spr_idle;
		}
		mask_index = mskPlayer;
		canshoot = 1;
		reload = 0;	// allow firing
		want_stop = false;	// prevent this event from happening again for now
	}
}

// destroy my fake-ass walls when not teleporting
if(show_anim <= 0 and hide_anim <= 0){
	with(instances_matching(Wall, "creator", self)){
		instance_delete(self);
	}
}

// don't shoot when teleporting and manage pickups
if(show_anim >= 0 or hide_anim >= 0){
	canshoot = 0;
	repeat(30){
		with(instance_nearest(x, y, Pickup)){
			if(distance_to_object(other) < 10){
				switch(object_index){
					case Rad:
						GameCont.rad++;
						sound_play(sndRadPickup);
					break;
					case BigRad:
						GameCont.rad += 20;
						sound_play(sndRadPickup);
					break;
					case HPPickup:
						with(other){
							my_health += min(maxhealth - my_health, 2)
						}
						sound_play(sndHPPickup);
					break;
					case AmmoPickup:
						with(other){
							var _mywep = choose(wep, bwep);	// choose either primary or secondary to work with
							var _typ = weapon_get_type(_mywep)	//	chosen weapon type
							want_type = 0;	// setting this up prematurely because I'm paranoid
							if(_typ != 0){	// if chosen weapon type not melee
								if(ammo[_typ] >= typ_amax[_typ]){	// if ammo for that type is max
									want_type = irandom(4) + 1;	// choose random type
									ammo[_typ] += typ_ammo[want_type];	// add ammo
								}
								else{
									want_type = _typ;	// use chosen weapon ammo type
									ammo[_typ] += typ_ammo[want_type];	// add ammo
								}
							}
							else{
								// do the same for melee as if chosen weapon ammo type was full
								want_type = irandom(4) + 1;
								ammo[_typ] += typ_ammo[want_type];
							}
							
							// determine string for popup text by gained ammo type
							switch(want_type){
								case 1:
									wepstring = "BULLETS";
								break;
								case 2:
									wepstring = "SHELLS";
								break;
								case 3:
									wepstring = "BOLTS";
								break;
								case 4:
									wepstring = "EXPLOSIVES";
								break;
								case 5:
									wepstring = "ENERGY";
								break;
							}
							
							// create popup text
							if(ammo[want_type] >= typ_amax[want_type]){	// max ammo
								with(instance_create(x, y, PopupText)){
									target = other;
									text = "MAX " + other.wepstring;
									mytext = text;
									time = 30;
								}
							}
							else{
								with(instance_create(x, y, PopupText)){	// plus ammo
									target = other;
									text = "+" + string(other.typ_ammo[other.want_type]) + other.wepstring;
									mytext = text;
									time = 30;
								}
							}
							
							// balance ammo
							for(i = 1; i < 6; i++){
								ammo[i] = min(ammo[i], typ_amax[i]);
							}
						}
						sound_play(AmmoPickup);
					break;
				}
				instance_destroy();
			}
		}
	}
}

if(cooldown >= 0){
	cooldown -= current_time_scale;
}



#define race_name
// return race name for character select and various menus
return "TURRET";


#define race_text
// return passive and active for character selection screen
return "CAN BURROW";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


#define race_swep
// return ID for race starting weapon
return "turret";


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
return choose("61 63 74 69 76 61 74 65 20 77 69 6e 64 6f 77 73 ", "64 65 73 74 72 6f 79", "72 65 63 61 6c 69 62 72 61 74 69 6e 67 20 64 65 66 65 6e 73 65 20 73 79 73 74 65 6d 73", "BEEP BOOP", "64 65 73 74 72 6f 79");