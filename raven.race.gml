#define init
// for level start
global.newLevel = instance_exists(GenCont);
global.hasGenCont = false;

// character select button
global.sprMenuButton = sprite_add("sprites/selectIcon/sprRavenSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("/sprites/portrait/sprPortraitRaven.png", 1, 0, 190); 
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_Raven.png", 1, 10, 10);

// level start init- MUST GO AT END OF INIT
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	// first chunk here happens at the start of the level, second happens in portal
	if(instance_exists(GenCont)) global.newLevel = 1;
	else if(global.newLevel){
		global.newLevel = 0;
		level_start();
	}
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "raven"){
			sound_play(sndRavenScreech);
		}
		_race[i] = r;
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
spr_sit1 = spr_idle;
spr_sit2 = spr_idle;

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
melee = 0;	// can melee or not
charge_cool = 0;	// charge cooldown
charged = 0;

#define level_start
// stop flying in between levels
with(instances_matching(Player, "race", "raven")){
	cooldown = 0;
	fly_alarm = 0;
	view_pan_factor[index] = 4;
	// reset sprites
	spr_idle = sprRavenIdle;
	spr_walk = sprRavenWalk;
	spr_fly = sprRavenFly;
	mask_index = mskPlayer;	// can get hit again
	sound_play_pitchvol(sndRavenLand, random_range(0.9,1.1), 0.65);
	canwalk = 1;	// walk again
	cooldown = 10;	// cooldown init
	wkick = 0;	// show weapon
	can_shoot = 1; // can shoot
	reload = 1;	// fix for stacking shots
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
	view_object[index] = self;
	canfly = 0;
}


#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

u1 = ultra_get(player_get_race(index), 1);
u2 = ultra_get(player_get_race(index), 2);

// no weps
canswap = 0;
canpick = 0;
if(wep != "raven"){
	wep = "raven";
}

// special - flight
if(button_pressed(index, "spec")){
	if(ultra_get("raven", 2) = 0){
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
							with(instance_create(x, y, Wall)){
								creator = other;
								mask_index = mskNone;
								sprite_index = mskNone;
								spr_shadow = shd24;
								topspr = mskNone;
								outspr = mskNone;
								name = "ravenview";
							}
							tempView_array = instances_matching(Wall, "creator", self);
							// if I can't make a wall
							if(array_length(tempView_array) = 0){
								with(instance_create(x, y, CustomObject)){
									creator = other;
									mask_index = mskNone;
									sprite_index = mskNone;
									spr_shadow = shd24;
									name = "ravenview";
								}
								tempView_array = instances_matching(CustomObject, "creator", self);
							}
							tempView = tempView_array[0];
							view_object[index] = tempView;
							spr_idle = mskNone;	// no sprite
							spr_walk = mskNone;
							spr_fly = sprRavenLift;
							mask_index = mskNone;	// no hit
							fly_index = 0;	// set index for flight sprite
							sound_play_pitchvol(sndRavenLift, random_range(0.9,1.1), 0.65);
							cooldown = -1;
							fly_alarm = 40;	// flight duration
							speed = 0;	// no sliding
							canwalk = 0;	// no walking
							can_shoot = 0; // no shooting
							// dust effect
							repeat(5){
								with(instance_create(x + irandom_range(-10, 10), y + irandom(4), Dust)){
									direction = random(360);
									speed = random_range(0.5, 1.5);
								}
							}
						}
					}
				}
			}
		}
	}
}

if(instance_number(enemy) = 0 and instance_exists(Portal) and fly_alarm > 0){
	fly_alarm = 0;
	view_pan_factor[index] = 4;
	// reset sprites
	spr_idle = sprRavenIdle;
	spr_walk = sprRavenWalk;
	spr_fly = sprRavenFly;
	mask_index = mskPlayer;	// can get hit again
	sound_play_pitchvol(sndRavenLand, random_range(0.9,1.1), 0.65);
	canwalk = 1;	// walk again
	cooldown = 60;	// cooldown init
	wkick = 0;	// show weapon
	can_shoot = 1; // can shoot
	reload = 1;	// fix for stacking shots
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
	view_object[index] = self;
	canfly = 0;
}

// flying!
if(fly_alarm > 0){
	view_pan_factor[index] = 22;	// limit mouse pan
	script_bind_draw(draw_flight, -999, id, fly_alarm, fly_index);
	wkick = 99999;	// hide weapon
	fly_alarm-= current_time_scale;	// alarm management
	can_shoot = 0;
	
	// sprite management
	if(fly_alarm = 25){
		spr_fly = sprRavenFly;
	}
	else if(fly_alarm = 20){
		if(u1 == 1){
		// lamp oil? ropes? bombs? you want it? it's yours my friend
			pdist = point_distance(x,y, coords[0], coords[1]);
			pdir = point_direction(x,y, coords[0], coords[1]);
			for(i = 0; i < 5; i++){
				with (instance_create(x + lengthdir_x((pdist/5) * i, pdir), y + lengthdir_y((pdist/5) * i, pdir), CustomObject)){
					creator = other;
					name = "RavenBomb";
					timer = other.i*2;
					if(other.i = 4){
						exploType = "big";
					} else {
						exploType = "small";
					}
					on_step = script_ref_create(bomb_step);
				}
			}
		}
		// move view
		with(tempView){
			x = creator.coords[0];
			y = creator.coords[1];
			// move player
			creator.x = creator.coords[0];
			creator.y = creator.coords[1];
		}
	}
	else if(fly_alarm = 15){
		spr_fly = sprRavenLand;
	}
	
	if(fly_alarm = 0){
		view_pan_factor[index] = 4;
		// reset sprites
		spr_idle = sprRavenIdle;
		spr_walk = sprRavenWalk;
		spr_fly = sprRavenFly;
		mask_index = mskPlayer;	// can get hit again
		sound_play_pitchvol(sndRavenLand, random_range(0.9,1.1), 0.65);
		canwalk = 1;	// walk again
		cooldown = 60;	// cooldown init
		wkick = 0;	// show weapon
		can_shoot = 1; // can shoot
		reload = 1;	// fix for stacking shots
		// dust effect
		repeat(5){
			with(instance_create(tempView.x + irandom_range(-10, 10), tempView.y + irandom(4), Dust)){
				direction = random(360);
				speed = random_range(0.5, 1.5);
			}
		}
		view_object[index] = self;
		instance_delete(tempView);
		canfly = 0;
	}
}

// cooldown management
if(cooldown > 0){
	if(cooldown = 1){
		sound_play_pitchvol(sndRavenScreech, random_range(0.9,1.1), 0.65);
	}
	cooldown-= current_time_scale;
}

// index management
if(fly_index < sprite_get_number(spr_fly)){
	fly_index +=  current_time_scale * image_speed;
}
else{
	fly_index = 0;
}




// ULTRA B

if(ultra_get("raven", 2)){
	if(button_pressed(index, "spec") and charge_cool = 0){
		if(!collision_rectangle(x + 10, y + 8, x - 10, y - 8, Wall, 0, 1)){
			sound_play_pitchvol(sndChickenThrow, random_range(0.9, 1.1), 2);
			sound_play_pitchvol(sndRavenLift, random_range(1.2, 1.4), 0.5);
			charge_cool = 20;
			direction = gunangle;
			with(instance_create(x, y, CustomSlash)){
				name = "RavenSlash";
				creator = other;
				team = creator.team;
				sprite_index = mskNone;
				mask_index = mskPlayer;
				index = creator.index;
				can_deflect = 1;
				image_speed = 0;
				on_step = script_ref_create(ravenslash_step);
				on_wall = script_ref_create(ravenslash_wall);
				on_hit = script_ref_create(ravenslash_hit);
			}
		}
	}
}

// if charging
if(charge_cool > 0){
	melee = 1;	// can melee or not
	canwalk = 0;	// lose control
	charge_cool -= current_time_scale;
	spr_walk = sprRavenFly;
	spr_idle = sprRavenFly;
	direction -= angle_difference(direction, gunangle)/12;
	move_towards_point(x + lengthdir_x((maxspeed + 6) * current_time_scale, direction), y + lengthdir_y((maxspeed + 6) * current_time_scale, direction), (maxspeed + 6) * current_time_scale);
	sprite_angle = direction;
	image_xscale = right;
	image_yscale = right;
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, Wall, 0, 1)){
		charge_cool = 0;
	}
	if(collision_rectangle(x + 10, y + 8, x - 10, y - 8, enemy, 0, 1)){
		with(instance_nearest(x, y, enemy)){
			if(sprite_index != spr_hurt){
				projectile_hit_push(self, 20, 2);
				sound_play_pitch(sndBlackSword, random_range(0.9, 1.1));
				sound_play_pitch(sndScrewdriver, random_range(1.5, 2));
				with(instance_create(x + random_range(-5, 5), y + random_range(-5, 5), ThrowHit)){
				depth = -100;
				}
				with(instance_create(x + random_range(-5, 5), y + random_range(-5, 5), ImpactWrists)){
					depth = -100;
				}
			}
		}
	}
}

// charge end
if(charge_cool = 0 and charged != 0){
	melee = 0;	// can melee or not
	charge_cool = 0;
	canwalk = 1;
	spr_walk = sprRavenWalk;
	spr_idle = sprRavenIdle;
	sound_play_pitchvol(sndFootOrgSand2, random_range(1, 1.1), 2);
	sound_play_pitchvol(sndFootOrgSand3, random_range(1.6, 2), 2);
	sprite_angle = 0;
	image_yscale = 1;
}

charged = charge_cool;

// ULTRA B END

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


#define ravenslash_step
if(instance_exists(creator)){
	x = creator.x + lengthdir_x(creator.speed + 2, creator.direction);
	y = creator.y + lengthdir_y(creator.speed + 2, creator.direction);
	if(creator.charge_cool = 0){
		trace(1);
		instance_destroy();
	}
}

#define ravenslash_wall

#define ravenslash_hit

#define draw_flight(id, fly_alarm)
with(id){
	if(instance_exists(tempView)){
		if(fly_alarm >= 20){
			d3d_set_fog(1,player_get_color(index),0,0);
			draw_sprite_ext(spr_fly, fly_index, tempView.x - 1, tempView.y - (180 - ((fly_alarm - 20) * 8)), image_xscale * right, image_yscale, sprite_angle, player_get_color(index), 1);
			draw_sprite_ext(spr_fly, fly_index, tempView.x + 1, tempView.y - (180 - ((fly_alarm - 20) * 8)), image_xscale * right, image_yscale, sprite_angle, player_get_color(index), 1);
			draw_sprite_ext(spr_fly, fly_index, tempView.x, tempView.y - 1 - (180 - ((fly_alarm - 20) * 8)), image_xscale * right, image_yscale, sprite_angle, player_get_color(index), 1);
			draw_sprite_ext(spr_fly, fly_index, tempView.x, tempView.y + 1 - (180 - ((fly_alarm - 20) * 8)), image_xscale * right, image_yscale, sprite_angle, player_get_color(index), 1);
			d3d_set_fog(0,c_lime,0,0);
			draw_sprite_ext(spr_fly, fly_index, tempView.x, tempView.y - (180 - ((fly_alarm - 20) * 8)), image_xscale * right, image_yscale, sprite_angle, c_white, 1);
		}
		else{
		d3d_set_fog(1,player_get_color(index),0,0);
			draw_sprite_ext(spr_fly, fly_index, tempView.x - 1, tempView.y - (fly_alarm * 8), image_xscale * right, image_yscale, sprite_angle, player_get_color(index), 1);
			draw_sprite_ext(spr_fly, fly_index, tempView.x + 1, tempView.y - (fly_alarm * 8), image_xscale * right, image_yscale, sprite_angle, player_get_color(index), 1);
			draw_sprite_ext(spr_fly, fly_index, tempView.x, tempView.y - 1 - (fly_alarm * 8), image_xscale * right, image_yscale, sprite_angle, player_get_color(index), 1);
			draw_sprite_ext(spr_fly, fly_index, tempView.x, tempView.y + 1 - (fly_alarm * 8), image_xscale * right, image_yscale, sprite_angle, player_get_color(index), 1);
			d3d_set_fog(0,c_lime,0,0);
			draw_sprite_ext(spr_fly, fly_index, tempView.x, tempView.y - (fly_alarm * 8), image_xscale * right, image_yscale, sprite_angle, c_white, 1);
		}
		
	}
}
instance_destroy();

#define bomb_step
timer -= current_time_scale;
if(timer <= 0){
	if(exploType == "big"){
		instance_create(x,y,Explosion);
		sound_play_pitchvol(sndExplosion, random_range(0.6,0.9), 0.45);
	} else {
		instance_create(x,y,SmallExplosion);
		sound_play_pitchvol(sndExplosionS, random_range(1.5,2), 0.45);
	}
	instance_destroy();
}

#define race_name
// return race name for character select and various menus
return "RAVEN";


#define race_text
// return passive and active for character selection screen
return "TOMMY GUN#@sCAN @wFLY";


#define race_portrait
// return portrait for character selection screen and pause menu
return global.sprPortrait;


#define race_mapicon
// return sprite for loading/pause menu map
return global.sprIcon;


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
	case 1: return "CARPET BOMBS";
	case 2: return "BIRD OF PREY";
	default: return "";
}


#define race_ultra_text
// recieves ultra mutation index and returns description
switch(argument0){
	case 1: return "@sRAIN @yDEATH @sFROM @wABOVE";
	case 2: return "NYOOM WITH TALONS";
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