
#define init
healthChance = 30; //percent chance of transforming an ammo pickup into a health pickup
trace ("Welcome to Hell.");
trace ("Type '/ehelp list' for a list of commands.");

for(i = 1; i < 16; i++){
	race_set_active(i, 0);
}

#define step
// replace big chests with health chests
with(WeaponChest){
	instance_create(x, y, HealthChest);
	instance_destroy();
}
with(AmmoChest){
	instance_create(x, y, HealthChest);
	instance_destroy();
}

// chance for ammo pickups to become hp- delete otherwise
with(AmmoPickup){
	if(random(100) > 100 - healthChance){
		instance_create(x, y, HPPickup);
	}
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
				trace("/ehelp - only use this in case of severe confusion");
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
			healthChance = 30;
			trace("Health pickup transform reverted to normal. (" + string(healthChance) + "%)");
		break;
		
		case "":
			trace("You forgot to type in a number.");
		break;
		
		default:
			healthChance = real(parameter);
			trace("Chance to transform into a health pickup now " + string(healthChance) + "%");
		}
	return true;
	break;
	}
