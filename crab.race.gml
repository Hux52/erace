#define init
global.sprMenuButton = sprite_add("sprites/selectIcon/sprCrabSelect.png", 1, 0, 0);
global.sprPortrait = sprite_add("sprites/portrait/sprPortraitHermitCrab.png",1 , 15, 205);
global.sprIcon = sprite_add("sprites/mapIcon/LoadOut_HermitCrab.png", 1, 10, 10);

global.sprChain = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAFCAYAAABM6GxJAAAAAXNSR0IArs4c6QAAAFdJREFUGJVjZGBg+M+AChjR+CjyDg2o8oyBWlr/GRgYGJ59/szAwMDAcPLxYxTdgVpaDPjkGdFtCNTSYpCXk2NgYGBgePjoEcP6a9cwDESWp74LGEgMAwBAiCoorgvr/gAAAABJRU5ErkJggg==",1, 0, 2);
global.sprMine = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABgAAAAVCAYAAABc6S4mAAAAAXNSR0IArs4c6QAAAitJREFUOI2dVTGLo0AU/gxWA1YKgYBjkS6B7US2swo2Flt4dX7Csb/AH3Bse/X+givShK3sQrATFK7YIgqBgYQrBNtckczs6IzJcV+jzpt57833vfc0ACBMoSBLceHvYQrjP+wAAFPn/J6zf0WYXoNM7m2a2zbmto2XxQKB6+J7FCFwXfx8fRW2RwmYY5nObRux7+NQ1ygYE+/PyyU+tlvx/XX2fLll3qPLlJ3zjADAIQSbPAcAxL6PXVlinST4XVXwKO3ZDnUNh5Cbn+YiBxEUhSmMz/O5d72n6VQcnFkWPrZbYYt9H7HvAwA8SjGzLOybRrmBooFDCBxCMLOsoQkepcraI5sIwCk6dZ2yaVeWWEVRj3MdXhYLRfBJpinTU9ehYEx8c2GHWW7yXGgxdgtTzh648s43b/JcaDDEJs+FwLuyFIlwf7dtxgToV88qikQmPJiOIjmRdZKI9cB1Ebhu7wbG5/ksgvBK8ShFwRgcQrQUFYzBo7R3AwDYN41KUZjCyNJrEM59wRieplMc21ZLUez7vV6QwUs1SwFDnkVcC7lMeYB1kmiFlnGoa/z5Vok+0M4inahjVTTEr6pS1pQAp67Dqeu01NzrgzGb0mgyCsZE4x3bFqsoEja5Bw51jWPbInBdpdEUDfi7PE0BiIoZPnlR8DkmzyJFZBnD5ju2LZ6XSzFVf7y/jzqWA5jDRRn8MH/yGt+/vfX26ZxzmFmq/yc/cvDoN8pn3F9wsyQSW+LhCAAAAABJRU5ErkJggg==", 1, 12, 10);
global.sprChainLink = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAFCAYAAABM6GxJAAAAAXNSR0IArs4c6QAAAFdJREFUGJVjZGBg+M+AChjR+CjyDg2o8oyBWlr/GRgYGJ59/szAwMDAcPLxYxTdgVpaDPjkGdFtCNTSYpCXk2NgYGBgePjoEcP6a9cwDESWp74LGEgMAwBAiCoorgvr/gAAAABJRU5ErkJggg==", 4, 0, 4);

if(sprite_exists(global.sprChain)){
	global.tex = sprite_get_texture(global.sprChain, 0);
}

// character select sounds
global.sndSelect = sndOasisDeath;
var _race = [];
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true){
	//character selection sound
	for(var i = 0; i < maxp; i++){
		var r = player_get_race(i);
		if(_race[i] != r && r = "crab"){
			sound_play_pitchvol(global.sndSelect,1.5,1);
		}
		_race[i] = r;
	}
	wait 1;
}

#define create
// player instance creation of this race
// https://bitbucket.org/YellowAfterlife/nuclearthronetogether/wiki/Scripting/Objects/Player

// sprites
spr_idle = sprCrabIdle;
spr_idle_normal = spr_idle;
spr_walk = sprCrabWalk;
spr_walk_normal = spr_walk;
spr_hurt = sprCrabHurt;
spr_dead = sprCrabDead;
spr_sit1 = sprCrabIdle;
spr_sit2 = sprCrabIdle;

spr_fire = sprCrabFire;

// sounds
snd_hurt = sndOasisHurt;
snd_dead = sndOasisDeath;
snd_melee = sndOasisMelee;
snd_fire = sndOasisCrabAttack;

// stats
maxspeed = 4.1;
erace_maxspeed_orig = maxspeed;
team = 2;
maxhealth = 12;
spr_shadow_y = 0;
mask_index = mskPlayer;

// vars
melee = 0;	// can melee or not

d = 0;

fire_cooldown = 0;
fire_cooldown_base = 30;

bulletCountBase = 8;
bulletCount = 8;

fireDelay = 1;
fireDelayBase = 1;

can_fire = true;
is_firing = false;

//ball and chain
pdir = 0;
pdist = 0;
x1 = x;
x2 = x;
y1 = y;
y2 = y;
ball_dir = 0;
// angle_increase = 0;

rotation_speed = 0;
rotation_direction = 0; // 1 (cw) or -1 (ccw)

extending = false;
curdist = 0;
maxdist = 65;
my_ball = noone;
nudge = false;
canwoosh = false;

ball = 0;
amt = 0;

#define game_start
// executed after picking race and starting for each player picking this race
// player-specific global variable init


#define step
// executed within each player instance of this race after step
// most actives and passives handled here

script_bind_draw("druh", depth); //for ball and chain

// no weps
canswap = 0;
canpick = 0;

footstep = 2;

// outgoing contact damage
if(collision_rectangle(x + 12, y + 10, x - 12, y - 10, enemy, 0, 1)){
	with(instance_nearest(x, y, enemy)){
		if(sprite_index != spr_hurt){
			projectile_hit_push(self, 3, 4);
			sound_play_pitchvol(other.snd_melee,random_range(0.9,1.1),1);
		}
	}
}

//firing

if(fire_cooldown > 0){
	can_fire = false;
} else {
	can_fire = true;
}

if(button_pressed(index,"fire")){
	if(can_fire){
		is_firing = true;
		fire_cooldown = fire_cooldown_base;
	}
}

if(is_firing){
	spr_walk = spr_fire;
	spr_idle = spr_fire;
	if(bulletCount > 0){
		if(fireDelay <= 0){
			sound_play_pitchvol(snd_fire, random_range(0.9,1.1), 1);
			for(i = -1; i < 2; i += 2){
				q = d + (i*20);
				with(instance_create(x,y,EnemyBullet2)){
					creator = other;
					damage = 2;
					speed = random_range(5,7);
					team = other.team;
					direction = other.q + random_range(-3,3);
					image_angle = direction;
				}
			}
			bulletCount -= 1;
			fireDelay = fireDelayBase;
		}
		fireDelay -= current_time_scale;
	} else {
		is_firing = false; //stop firing
	}
}else{
	//reset everything
	bulletCount = bulletCountBase;
	d = point_direction(x,y,mouse_x[index],mouse_y[index]);
	spr_idle = spr_idle_normal;
	spr_walk = spr_walk_normal;
}

fire_cooldown -= current_time_scale;


ball = button_check(index,"spec");

pdir = point_direction(x1,y1,mouse_x[index],mouse_y[index]);
x1 = x;
y1 = y;
x2 = x + lengthdir_x(curdist, ball_dir);
y2 = y + lengthdir_y(curdist, ball_dir);
//chain width
dx = lengthdir_x(4, point_direction(x1,y1,x2,y2) + 90);
dy = lengthdir_y(4, point_direction(x1,y1,x2,y2) + 90);

pdist = point_distance(x1,y1,x2,y2);

f = pdist/(sprite_get_width(global.sprChain));

if(button_pressed(index,"spec")){
	extending = true;
	ball_dir = pdir;
	dir_orig = round(pdir);
	nudge = false;
	rotation_direction = 0;
	rotation_speed = 0;
	reel_tick = 0;
	
	my_ball = instance_create(x,y,CustomObject);
	with(my_ball){
		creator = other;
		sprite_index = global.sprMine;
		depth = other.depth;
		on_step = script_ref_create(ball_step);
		on_destroy = script_ref_create(ball_destroy);
		on_draw = script_ref_create(ball_draw);
		armed = false;
		done = false;
		canthrow = false;
		timer = 30;
		flash = false;

		playerColor = player_get_color(creator.index);
	}
}

if(ball){
	canwalk = false;
	if(curdist < maxdist){
		if(extending == true){
			amt = (ball * current_time_scale) * (1+(curdist/4));
			curdist = max(curdist, min(curdist + amt, maxdist));
			reel_pitch = random_range(1.3,1.7) + curdist/maxdist;
			reel_tick += current_time_scale;
			if(reel_tick mod 2 == 0){
				sound_play_pitchvol(sndDiscBounce, reel_pitch, 0.15);
			}
			
			if(reel_tick mod 2 == 1){
				sound_play_pitchvol(sndChickenReturn, reel_pitch, 0.25);
			}
		}
	} else {
		if(nudge = false){
			nudge = true;
			ball_sound("armed", 1);
			motion_add(ball_dir, 3);
		}
		extending = false;
	}
	
	// rotation_speed += (button_check(index,"west") + (button_check(index,"east")*-1));
		
	if(abs(angle_difference(ball_dir,pdir)) > 15){
		rotation_speed += sign(angle_difference(pdir,ball_dir)) * current_time_scale * 2;
		// trace(sign(angle_difference(pdir,ball_dir)))
	}
	if(extending = false){
		ball_dir += rotation_speed * current_time_scale * 0.5;
	}

	// if(sign(angle_difference(pdir,rotation_speed)) != sign(rotation_speed)){
		rotation_speed = lerp(rotation_speed, 0, 0.045*current_time_scale);
	// }
	if(canwoosh){
		if(abs(angle_difference(ball_dir, dir_orig)) < 10 and abs(rotation_speed) > 10){
			speed_factor = abs(rotation_speed)/48;
			woosh_pitch = speed_factor * 1.2 + 0.05;
			woosh_vol = speed_factor * 0.35;
			sound_play_pitchvol(sndEnemySlash, woosh_pitch - 0.1, 0.65);
			sound_play_pitchvol(sndMeleeFlip, random_range(0.2,0.4), woosh_vol);
			canwoosh = false;
		}
	} 

	if(abs(angle_difference(ball_dir, dir_orig)) > 90){
		if(extending == false){
			canwoosh = true;
		}
	}

	rotation_speed = clamp(rotation_speed, -48, 48);
	
} else {
	canwalk = true;
}

if(button_released(index, "spec")){
	if(my_ball != noone){
		my_ball.speed = (abs(rotation_speed)/2) * (curdist/maxdist);
		my_ball.direction = ball_dir + (90 * sign(rotation_speed));
		my_ball.friction = 0.6;
		my_ball.done = true;
		if(my_ball.armed == true){
			ball_sound("release", 1);
			release_vol = abs(rotation_speed)/48;
			sound_play_pitchvol(sndMeleeFlip, random_range(0.9,1.1) * 0.35, release_vol);
		}
		my_ball = noone;

		chainsNum = round(curdist/7.5) * 2;

		for(i = 0; i < chainsNum; i++){
			with(instance_create(x + lengthdir_x(curdist/chainsNum * i, ball_dir), y + lengthdir_y(curdist/chainsNum * i, ball_dir), CustomObject)){
				sprite_index = global.sprChainLink;
				image_index = other.i mod 2 + 1//irandom(image_number)
				image_angle = other.ball_dir;
				image_speed = 0;

				direction = other.ball_dir + (90 * sign(other.rotation_speed)) + random_range(-10,10);
				speed = abs(other.rotation_speed)/4 * random_range(0.8,1.2);
				friction = 1.5 - (other.i/other.chainsNum);

				fade = 1.5;
				isfading = false;
				on_step = script_ref_create(chainLink_step);
				rot_amt = random_range(-90,90);
			}
		}

		rotation_speed = 0;
		curdist = 0;
	}
}

#define ball_step
if(instance_exists(creator)){
	if(done = false){
		x = creator.x2;
		y = creator.y2;
		image_angle = creator.ball_dir;

		hitwall = instance_place(x,y,Wall);

		if(creator.extending){
			if(place_meeting(x,y,Wall)){
				creator.extending = false;
			}

			with(instance_place(x,y,enemy)){
				ball_sound("hit", 0.5);
				projectile_hit(self, (other.creator.curdist/other.creator.maxdist) * 10, other.creator.amt, other.creator.ball_dir);
			}

			with(instance_place(x,y,prop)){
				ball_sound("hit", 0.5);
				projectile_hit(self, (other.creator.curdist/other.creator.maxdist) * 10, 0, 0);
			}
		} else {
			if(instance_exists(hitwall)){
				if(abs(creator.rotation_speed) > 20){
					with(hitwall){
						ball_sound("wall", 0.35);
						instance_create(x,y,FloorExplo);
						instance_destroy();
					}			
					// creator.rotation_speed = creator.rotation_speed * -0.5;
				} else {
					// creator.rotation_speed = 10;
				}
			}

			if(abs(creator.rotation_speed) > 20){
				with(instance_place(x,y,prop)){
					ball_sound("hit", 1);
					projectile_hit(self, 5, 10);
				}

				with(instance_place(x,y,enemy)){
					ball_sound("hit", 1);
					projectile_hit(self, 10, 5,other.creator.ball_dir + (90 * sign(other.creator.rotation_speed)));
				}

				armed = true;
			} else {
				armed = false;
			}

		}
	} else {
		hitwall = instance_place(x + hspeed/2, y,Wall);
		if(instance_exists(hitwall)){
			if(speed) > 12 {
				with(hitwall){
					instance_create(x,y,FloorExplo);
					instance_destroy();
				}
			}
			direction = -direction + 180;
			if(speed > 1 and armed) {
				ball_sound("wall", speed/16);
				repeat(4){
					with(instance_create(x,y,Debris)){
					speed = random_range(2,4);
					direction = other.direction + random_range(-45,45) - 180;
					}
				}
			}
			speed *= 0.75;
		}
		hitwall = instance_place(x, y + vspeed/2,Wall);
		if(instance_exists(hitwall)){
			if(speed) > 12 {
				with(hitwall){
					instance_create(x,y,FloorExplo);
					instance_destroy();
				}
			}
			direction = -direction;
			if(speed > 1 and armed) {
				ball_sound("wall", speed/16);
				repeat(4){
					with(instance_create(x,y,Debris)){
					speed = random_range(2,4);
					direction = other.direction + random_range(-45,45) - 180;
					}
				}
			}
			speed *= 0.75;
		}
	
		if(armed == true){
			if(speed > 8){
				with(instance_place(x,y,prop)){
				ball_sound("hit", 1);
					projectile_hit(self, 10, 0, 0);
				}
				with(instance_place(x,y,enemy)){
				ball_sound("hit", 1);
					projectile_hit(self, 10, 10, other.direction);
				}
			}
			if(speed <= 1){
				timer -= current_time_scale;
			}
			if(timer < 20){
				if(timer mod 2 == 0) {
					flash = !flash
					sound_play_pitchvol(sndDiscBounce, 2.5 * flash + 2, 0.25);
					};
			}
			if(timer <= 0){
				instance_destroy();
			}
		} else {
			instance_destroy();
			exit;
		}
	}

} else {
	instance_destroy();
}

#define ball_destroy
if(armed){
	instance_create(x,y,Explosion);
	sound_play_pitchvol(sndOasisExplosion, random_range(0.9,1.1), 0.45);
	sound_play_pitchvol(sndExplosion, random_range(0.9,1.1), 0.25);
} else {
	ball_sound("pop", 1);
	repeat(10){
		instance_create(x + random_range(-12,12), y + random_range(-12,12), Bubble);
	}
	instance_create(x,y,BubblePop);
}

#define ball_draw
draw_self();
if(flash){
	d3d_set_fog(1,c_white,0,0);
	draw_self();
	d3d_set_fog(false,c_white,0,0);
}

#define ball_sound(snd, vol)
switch(snd){
	case "wall":
		sound_play_pitchvol(sndGrenadeHitWall, random_range(0.9,1.1) * 0.5, 0.65 * vol);
		sound_play_pitchvol(sndCrystalJuggernaut, random_range(0.9,1.1) * 2, 0.65 * vol);
		sound_play_pitchvol(sndHitRock, random_range(0.9,1.1) * 1, 0.65 * vol);
		sound_play_pitchvol(sndHitMetal, random_range(0.9,1.1) * 1, 0.65 * vol);
		sound_play_pitchvol(sndWolfHurt, random_range(0.9,1.1) * 2, 0.35 * vol);
	break;

	case "release":
		sound_play_pitchvol(sndAssassinPretend, random_range(0.9,1.1) * 2, 0.65 * vol);
		sound_play_pitchvol(sndAssassinAttack, random_range(0.9,1.1) * 2.5, 0.65 * vol);
		// sound_play_pitchvol(sndSnowBotSlideStart, random_range(0.9,1.1) * 2, 0.65 * vol);
	break;

	case "pop":
		sound_play_pitchvol(sndOasisExplosionSmall, random_range(0.9,1.1) * 2.5, 0.25 * vol);
		sound_play_pitchvol(sndOasisDeath, random_range(0.9,1.1) * 2.5, 0.35 * vol);
		sound_play_pitchvol(sndOasisCrabAttack, random_range(0.9,1.1) * 2.5, 0.65 * vol);
		sound_play_pitchvol(sndRadPickup, random_range(0.9,1.1) * 0.2, 0.35 * vol);
	break;

	case "armed":
		sound_play_pitchvol(sndCrossReload, random_range(0.9,1.1) * 2, 0.45 * vol);
		sound_play_pitchvol(sndChickenReturn, random_range(0.9,1.1) * 0.6, 0.35 * vol);
		sound_play_pitchvol(sndCrystalShield, random_range(0.9,1.1) * 2, 0.65 * vol);
	break;
	
	case "hit":
		sound_play_pitchvol(sndHitFlesh, random_range(0.9,1.1) * 1, 0.45 * vol);
		// sound_play_pitchvol(sndPlantSnare, random_range(0.9,1.1) * 0.5, 0.65 * vol);
		// sound_play_pitchvol(sndPlantFire, random_range(0.9,1.1) * 0.5, 0.65 * vol);
		sound_play_pitchvol(sndHitMetal, random_range(0.9,1.1) * 0.3, 0.75 * vol);
	break;
}

#define chainLink_step
if(speed <= 1){isfading = true};
if(isfading) fade -= 1/room_speed;
image_alpha = fade;
image_angle += (rot_amt)/2;
rot_amt /= 2;
if(fade <= 0){
	instance_destroy();
}

#define druh
with(Player){
	if (ball){
		texture_set_repeat(true);
		draw_primitive_begin_texture(pr_trianglestrip, global.tex);
		draw_vertex_texture_color(x1 + dx, y1 + dy, 0, 0, make_color_hsv(0, 0, 120), 1);
		draw_vertex_texture_color(x1 - dx, y1 - dy, 0, 1, make_color_hsv(0, 0, 120), 1);
		draw_vertex_texture_color(x2 + dx, y2 + dy, f, 0, make_color_hsv(0, 0, 255), 1);
		draw_vertex_texture_color(x2 - dx, y2 - dy, f, 1, make_color_hsv(0, 0, 255), 1);
		draw_primitive_end();
	}
}
instance_destroy();

#define race_name
// return race name for character select and various menus
return "CRAB";


#define race_text
// return passive and active for character selection screen
return "CONTACT DAMAGE";


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
return true;


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
return choose("SNIP SNIP", "AIN'T EASY BEING GREEN");