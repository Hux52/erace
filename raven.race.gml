#define init
// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

// character select button
global.sprMenuButton = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAYCAIAAAB8wupbAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjEuNWRHWFIAAAC1SURBVDhPpZKxDcIwEEU9QxqmCDUU2QBRsEHYhYYB6MgUrJCegSj48KzjckSKYn+94u7ffcmynVC73YvcfHU49hTX2+DBXBNomo3QWFBDyKOiAIcJqzgs0VIXBfwqWAA4bXXgfjkbz/HhIV8R+F8yx4+qA69dMvpTJ2RSYP5UGPBwhlk0nQTCeJb1gcV3CJQGgEe12pv5iiRcP7Pam3lbwuVLUpsT2vxnfW9jnNBOAot8VqWU3n9mcdgsNO/xAAAAAElFTkSuQmCC", 1, 0, 0);


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
spr_idle = sprRavenIdle;
spr_walk = sprRavenWalk;
spr_hurt = sprRavenHurt;
spr_dead = sprRavenDead;
spr_sit1 = sprMutant15GoSit;
spr_sit2 = sprMutant15Sit;

// sounds
snd_hurt = sndRavenHit;
snd_dead = sndRavenDie;
snd_wrld = sndRavenScreech;

// stats
maxspeed = 4;
team = 2;
maxhealth = 10;
spr_shadow = shd24;
mask_index = mskPlayer;

// vars
fly_alarm = 0;	// digging
cooldown = 10;	// cooldown til you can fly again
coords = [0, 0];	// fly destination
fly_index = 0;	// image index for fly
spr_fly = sprRavenFly;	// current flight sprite
tempView = -4;	// temp view for player flying- avoid player interacting with pickups and lingering effects
tempView_array = -4;	// array that manages temp views
can_fly = 0;	// disallow flight
died = 0;	// disallow extra frames after death

#define level_start
// stop flying in between levels
with(instances_matching(Player, "race", "raven")){
	cooldown = 0;
	fly_alarm = 0;
	view_pan_factor = 4;
	// reset sprites
	spr_idle = sprRavenIdle;
	spr_walk = sprRavenWalk;
	spr_fly = sprRavenFly;
	mask_index = mskPlayer;	// can get hit again
	sound_play(sndRavenLand);
	canwalk = 1;	// walk again
	cooldown = 10;	// cooldown init
	wkick = 0;	// show weapon
	reload = 1; // can shoot
	// dust effect
	repeat(5){
		with(instance_create(x + irandom_range(-10, 10), y + irandom(4), Dust)){
			direction = random(360);
			speed = random_range(0.5, 1.5);
		}
	}
	if(instance_exists(tempView)){
		x = tempView.x;
		y = tempView.y;
		instance_delete(tempView);
	}
	view_object = self;
	canfly = 0;
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

// special - flight
if(button_pressed(index, "spec")){
	if(cooldown = 0 and canspec = 1){
		// if floor inside borders...
		if!(collision_point(mouse_x[index], mouse_y[index] - 8, Wall, false, true)){
			if(collision_point(mouse_x[index], mouse_y[index] - 8, Floor, false, true)){
				if!(instance_number(enemy) = 0 and instance_exists(Portal)){
					// log coordinates for later and check for wall
					canfly = 0;
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
						canfly = 1;
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
						canfly = 1;
					}
					// swap x and y
					if(place_meeting(coords[0], coords[1], Wall) and canfly = 0){
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
						canfly = 1;
					}
					
					if(canfly = 1){
						// start flying
						spr_idle = mskNone;	// no sprite
						spr_walk = mskNone;
						spr_fly = sprRavenLift;
						mask_index = mskNone;	// no hit
						fly_index = 0;	// set index for flight sprite
						sound_play(sndRavenLift);
						cooldown = -1;
						fly_alarm = 40;	// flight duration
						speed = 0;	// no sliding
						canwalk = 0;	// no walking
						reload = 999; // no shooting
						// dust effect
						repeat(5){
							with(instance_create(x + irandom_range(-10, 10), y + irandom(4), Dust)){
								direction = random(360);
								speed = random_range(0.5, 1.5);
							}
						}
						with(instance_create(x, y, Tangle)){
							creator = other;
							mask_index = mskNone;
							sprite_index = mskNone;
							spr_shadow = shd24;
							name = "ravenview";
						}
						tempView_array = instances_matching(Tangle, "creator", self);
						tempView = tempView_array[0];
						view_object = tempView;
						x = -9999;
						y = -9999;
					}
				}
			}
		}
	}
}

if(instance_number(enemy) = 0 and instance_exists(Portal) and fly_alarm > 0){
	fly_alarm = 0;
	view_pan_factor = 4;
	// reset sprites
	spr_idle = sprRavenIdle;
	spr_walk = sprRavenWalk;
	spr_fly = sprRavenFly;
	mask_index = mskPlayer;	// can get hit again
	sound_play(sndRavenLand);
	canwalk = 1;	// walk again
	cooldown = 60;	// cooldown init
	wkick = 0;	// show weapon
	reload = 1; // can shoot
	// dust effect
	repeat(5){
		with(instance_create(tempView.x + irandom_range(-10, 10), tempView.y + irandom(4), Dust)){
			direction = random(360);
			speed = random_range(0.5, 1.5);
		}
	}
	if(instance_exists(tempView)){
		x = tempView.x;
		y = tempView.y;
		instance_delete(tempView);
	}
	view_object = self;
	canfly = 0;
}

// flying!
if(fly_alarm > 0){
	view_pan_factor = 22;	// limit mouse pan
	script_bind_draw(draw_flight, -999, id, fly_alarm, fly_index);
	wkick = 99999;	// hide weapon
	fly_alarm--;	// alarm management
	
	// sprite management
	if(fly_alarm = 25){
		spr_fly = sprRavenFly;
		spr_fly = sprRavenFly;
	}
	else if(fly_alarm = 20){
		// move view
		with(tempView){
			x = creator.coords[0];
			y = creator.coords[1];
		}
	}
	else if(fly_alarm = 15){
		spr_fly = sprRavenLand;
		spr_fly = sprRavenLand;
	}
	
	if(fly_alarm = 0){
		// move player
		x = coords[0];
		y = coords[1];
		view_pan_factor = 4;
		// reset sprites
		spr_idle = sprRavenIdle;
		spr_walk = sprRavenWalk;
		spr_fly = sprRavenFly;
		mask_index = mskPlayer;	// can get hit again
		sound_play(sndRavenLand);
		canwalk = 1;	// walk again
		cooldown = 60;	// cooldown init
		wkick = 0;	// show weapon
		reload = 1; // can shoot
		// dust effect
		repeat(5){
			with(instance_create(tempView.x + irandom_range(-10, 10), tempView.y + irandom(4), Dust)){
				direction = random(360);
				speed = random_range(0.5, 1.5);
			}
		}
		view_object = self;
		instance_delete(tempView);
		canfly = 0;
	}
}

// cooldown management
if(cooldown > 0){
	if(cooldown = 1){
		sound_play(sndRavenScreech);	// cooldown screech
	}
	cooldown--;
}

// index management
if(fly_index < sprite_get_number(spr_fly)){
	fly_index += 1 * image_speed;
}
else{
	fly_index = 0;
}

// on death
if(my_health = 0 and died = 0){
	// effects
	for(i = 0; i < 360; i += 120){
		with(instance_create(x, y, Feather)){
			speed = 8;
			direction = other.i + random_range(-30, 30);
		}
	}
	died = 1;
}


#define draw_flight(id, fly_alarm)
with(id){
	if(instance_exists(tempView)){
		if(fly_alarm >= 20){
			draw_sprite_ext(spr_fly, fly_index, tempView.x, tempView.y - (180 - ((fly_alarm - 20) * 8)), image_xscale * right, image_yscale, sprite_angle, c_white, 1);
		}
		else{
			draw_sprite_ext(spr_fly, fly_index, tempView.x, tempView.y - (fly_alarm * 8), image_xscale * right, image_yscale, sprite_angle, c_white, 1);
		}
	}
}
instance_destroy();

#define race_name
// return race name for character select and various menus
return "RAVEN";


#define race_text
// return passive and active for character selection screen
return "TOMMY GUN#CAN FLY";


#define race_portrait
// return portrait for character selection screen and pause menu
return sprBigPortraitChickenHeadless;


#define race_mapicon
// return sprite for loading/pause menu map
return sprMapIconChickenHeadless;


#define race_swep
// return ID for race starting weapon
return "raven";


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
return choose("SOARING...", "INCOMING", "Z AXIS", "TOP OF THE PECKING ORDER", "NEVERMORE");

#define draw_outline(playerColor, toDraw)
d3d_set_fog(1,playerColor,0,0);
if(instance_exists(toDraw)){
    with(toDraw){
        draw_sprite_ext(sprite_index, -1, x - 1, y, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x + 1, y, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y - 1, 1 * right, 1, 0, playerColor, 1);
        draw_sprite_ext(sprite_index, -1, x, y + 1, 1 * right, 1, 0, playerColor, 1);
    }
}
d3d_set_fog(0,c_lime,0,0);