#define init
global.sprSniper = sprSniperGun;
global.sprSniperBullet = sprHeavyBullet;
global.mskSniperBullet = mskHeavyBullet;

#define game_start

#define step

#define weapon_name
return "SUPER SNIPER CANNON";

#define weapon_sprt
return global.sprSniper;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 120;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_melee
return false;

#define weapon_laser_sight
return true;

#define weapon_text
return "HEADSHOT";

#define weapon_fire
weapon_post(5, 30, 10);
sound_play(sndSniperFire);


with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), CustomHitme)){
	creator = other;
	team = creator.team;
	name = "SniperBoy";
	spr_idle = sprSniperIdle;
	spr_dead = sprSniperDead;
	direction = creator.gunangle;
	sprite_index = spr_idle;
	mask_index = mskBandit;
	speed = 12;
	friction = 0.6;
	spr_shadow_y = 6;
	image_speed = 0.2;
	sizeb = 1.5;
	image_yscale = 1.5;
	spr_shadow = shd32;
	alarm = [-1, -1];
	offset = random(360);
	on_step = script_ref_create(boy_step);
	on_destroy = script_ref_create(boy_die);
}

#define boy_step
move_bounce_solid(true);
if (((direction+270) mod 360)>180) right = 1 else right = -1;
if(right = 1){
	image_xscale = sizeb * 1;
}
else{
	image_xscale = sizeb * -1;
}

if(speed = 0 and alarm[0] = -1){
	alarm[0] = irandom_range(18, 22);
}
if(alarm[0] = 0){
	script_bind_draw(draw_lines, depth, offset, x, y);
}
else if(alarm[0] = 1){
	sound_play_pitchvol(sndSniperTarget, 0.8, 1);
	alarm[1] = irandom_range(38, 42);
}

for(i = 0; i < array_length_1d(alarm); i++){
	if(alarm[i] > 0){
		alarm[i]--;
	}
}

if(alarm[1] = 0){
	sound_play(sndSniperFire);
	for(i = 0; i < 8; i++){
		var dir = 0 + offset + (45 * i);
		with(instance_create(x + lengthdir_x(8, dir), y + lengthdir_y(8, dir), CustomHitme)){
			creator = other;
			team = creator.team;
			name = "SniperBoy";
			spr_idle = sprSniperIdle;
			spr_dead = sprSniperDead;
			direction = 0 + other.offset + (45 * other.i);
			sprite_index = spr_idle;
			mask_index = mskBandit;
			speed = 12;
			friction = 0.6;
			spr_shadow_y = 5;
			image_speed = 0.4;
			sizeb = 1;
			alarm = [-1, -1];
			offset = random(360);
			on_step = script_ref_create(boy_step2);
			on_destroy = script_ref_create(boy_die);
		}
	}
	repeat(3){
		instance_create(x, y, Explosion);
	}
	instance_destroy();
}


#define boy_die
with(instance_create(x, y, Corpse)){
	sprite_index = other.spr_dead;
}


#define boy_step2
move_bounce_solid(true);
if (((direction+270) mod 360)>180) right = 1 else right = -1;
if(right = 1){
	image_xscale = 1;
}
else{
	image_xscale = -1;
}

if(speed = 0 and alarm[0] = -1){
	alarm[0] = irandom_range(18, 22);
}
if(alarm[0] = 0){
	script_bind_draw(draw_lines, depth, offset, x, y);
}
else if(alarm[0] = 1){
	sound_play(sndSniperTarget);
	alarm[1] = irandom_range(38, 42);
}

for(i = 0; i < array_length_1d(alarm); i++){
	if(alarm[i] > 0){
		alarm[i]--;
	}
}

if(alarm[1] = 0){
	sound_play(sndSniperFire);
	for(i = 0; i < 8; i++){
		var dir = 0 + offset + (45 * i);
		with instance_create(x + lengthdir_x(8, dir), y + lengthdir_y(8, dir), CustomProjectile){
			creator = other;
			team = creator.team;
			name = "SniperBullet";
			spr_idle = global.sprSniperBullet;
			spr_dead = sprHeavyBulletHit;
			sprite_index = spr_idle;
			direction = dir;
			image_angle = dir;
			image_speed = 1;
			mask_index = mskBullet1;
			friction = 0;
			speed = 24;
			force = 7;
			damage = 28;
			on_step = script_ref_create(sniper_step);
			on_hit = script_ref_create(sniper_hit);
			on_destroy = script_ref_create(sniper_die);
		}
	}
	instance_create(x, y, Explosion);
	instance_destroy();
}

#define draw_lines
var lines;
var _x = argument1;
var _y = argument2;
var _off = argument0;
for(i = 0; i < 8; i++){
	var _dir = 0 + _off + (45 * i);
	lines[i] = collision_line_first(_x, _y, _x + lengthdir_x(900, _dir), _y + lengthdir_y(900, _dir), Wall, false, true);
	var _w = lines[i];
	draw_line_color(_x, _y, _w.x, _w.y, c_red, c_red);
}
instance_destroy();


#define sniper_step
if(image_index = 1){
	image_speed = 0;
	if(damage <= 0){
		instance_destroy();
	}
}

#define sniper_hit
var _e = other
var _b = self;
with(_e){
	if(sprite_index != spr_hurt){
		var takeAway = my_health;
		my_health -= _b.damage;
		_b.damage -= takeAway;
		//trace(_b.damage);
		sound_play(snd_hurt);
		sprite_index = spr_hurt;
	}
}




#define sniper_die
with(instance_create(x, y, CustomHitme)){
	spr_shadow = mskNone;
	mask_index = mskNone;
	team = other.team;
	sprite_index = sprHeavyBulletHit;
	wait(image_number - 1);
	instance_destroy();
}


#define collision_line_first
/// collision_line_first(x1,y1,x2,y2,object,prec,notme)
//
//  Returns the instance id of an object colliding with a given line and
//  closest to the first point, or noone if no instance found.
//  The solution is found in log2(range) collision checks.
//
//      x1,y2       first point on collision line, real
//      x2,y2       second point on collision line, real
//      object      which objects to look for (or all), real
//      prec        if true, use precise collision checking, bool
//      notme       if true, ignore the calling instance, bool
//
/// GMLscripts.com/license
{
    var ox,oy,dx,dy,object,prec,notme,sx,sy,inst,i;
    ox = argument0;
    oy = argument1;
    dx = argument2;
    dy = argument3;
    object = argument4;
    prec = argument5;
    notme = argument6;
    sx = dx - ox;
    sy = dy - oy;
    inst = collision_line(ox,oy,dx,dy,object,prec,notme);
    if (inst != noone) {
        while ((abs(sx) >= 1) || (abs(sy) >= 1)) {
            sx /= 2;
            sy /= 2;
            i = collision_line(ox,oy,dx,dy,object,prec,notme);
            if (i) {
                dx -= sx;
                dy -= sy;
                inst = i;
            }else{
                dx += sx;
                dy += sy;
            }
        }
    }
    return inst;
}