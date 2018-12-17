
#define init
global.healthChance = 30; //percent chance of transforming an ammo pickup into a health pickup

for(i = 1; i < 16; i++){
	race_set_active(i, 0);
}

skill_set_active(mut_throne_butt, 0);
skill_set_active(mut_bolt_marrow, 0);
skill_set_active(mut_recycle_gland, 0);
skill_set_active(mut_laser_brain, 0);
skill_set_active(mut_shotgun_shoulders, 0);
skill_set_active(mut_lucky_shot, 0);
skill_set_active(mut_back_muscle, 0);

trace ("Welcome to Hell.");
trace ("Type '/ehelp list' for a list of commands.");

#define step

//if (Player.reload>0)trace(Player.reload) //for testing reloads
// replace big chests with health chests
if (instance_exists(GenCont) == false){
with(AmmoChest){
		instance_create(x, y, HealthChest);
		instance_create(x, y, HealFX);
		instance_create(x, y, BloodLust);
		instance_destroy();
	}
	
	with(WeaponChest){
		instance_create(x, y, HealthChest);
		instance_create(x, y, HealFX);
		instance_create(x, y, BloodLust);
		instance_destroy();
	}
	
}
// chance for ammo pickups to become hp- delete otherwise
with(AmmoPickup){
	if(random(100) > 100 - global.healthChance){
		instance_create(x, y, HPPickup);
		instance_create(x, y, HealFX);
		instance_create(x, y, BloodLust)
	}
	instance_destroy();
}

// weapons become hp, guaranteed
with(WepPickup){
	instance_create(x, y, HPPickup);
	instance_create(x, y, HealFX);
	instance_create(x, y, BloodLust);
	instance_create(x, y, StrongSpirit);
	sound_play_pitchvol(sndSwapGold,0.8,1);
	sound_play_pitchvol(sndSwapCursed,0.8,2);
	
	instance_destroy();
}

#define chat_command
// chat commands
var command = string_upper(argument0);
var parameter = string_upper(argument1);
switch(command){
	case "EHELP":
		//help command for BABIES. go read a book
		switch (parameter){
			case "":
				trace("No one can save you now.");
				trace("Type '/ehelp list' to see a list of commands.");
			break;
			
			case "LIST":
				//list commands
				trace("List of ERACE commands:");
				trace("/ehelp [command] - only use this in case of severe confusion");
				trace("/echance - chance for small ammo pickups to become health pickups");
			break;
			
			case "EHELP":
				trace("If you need help with getting help, I'm not sure what to tell you.");
				//I mean, you can't argue there
			break;
			
			case "ECHANCE":
				trace("Sets the chance, in percent, to transform an ammo pickup into a health pickup.");
				trace("/echance default to return to the industry standard of 30.78916478246%.")
			break;
			
			default:
				trace(choose("Wrong.", "Incorrect.", "Are you sure about that?", "Think again.") + " Command not found.");
			break;
		}
	return true;
	break;
	
	case "ECHANCE":
		switch(parameter){
		case "DEFAULT":
			global.healthChance = 30;
			trace("Health pickup transform reverted to normal. (" + string(global.healthChance) + "%)");
		break;
		
		case "":
			trace("You forgot to type in a number.");
		break;
		
		default:
			global.healthChance = real(parameter);
			trace("Chance to transform into a health pickup now " + string(global.healthChance) + "%");
		}
	return true;
	break;
	}
