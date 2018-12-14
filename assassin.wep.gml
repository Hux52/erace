#define init

#define game_start

#define step

#define weapon_name
return "PIPE";

#define weapon_sprt
return sprPipe;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 20;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapHammer;

#define weapon_melee
return true;

#define weapon_laser_sight
return false;

#define weapon_text
return "YOU ARE ALREADY DEAD";

#define weapon_fire
// no moving
speed = 0;
canwalk = 0;
// effect
instance_create(x, y - 8, AssassinNotice);
// delay til swing
wait(5);
// can walk again
canwalk = 1;
// swing
weapon_post(3, 20, 5);	// weapon kick and screen shake
sound_play(sndAssassinAttack);
with(instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), Slash)){
	creator = other;
	team = creator.team;
	direction = creator.gunangle;
	image_angle = direction;
	friction = 0;
	damage = 5;
}
if(wepangle = 120){
	wepangle = 235;
}
else{
	wepangle = 120;
}