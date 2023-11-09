// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cutscene_branch(global_value_name, options_array, outcomes_array){
	
	var options = array_length(options_array);
	var outcomes = array_length(outcomes_array);
	if (options != outcomes) {
		show_debug_message("\nTried to branch during cutscene but had options/outcomes mismatch.\nInjecting default 'cutscene_wait' action.\n");
	}
	if (!variable_global_exists(global_value_name)){
		show_message("\nTried to branch during cutscene but couldn't find global value with that name.\nInjecting default 'cutscene_wait' action.\n");
	}
	
	var injected_commands_array = [[cutscene_wait, 1]];		// default scene line is waiting
	var check_val = variable_global_get(global_value_name);
	var value_index = -1;
	for (var i = 0; i < options; i++) {
		if (options_array[i] == check_val) {
			value_index = i;
			break;
		}
	}
	if (value_index == -1) {
		show_debug_message("\nTried to branch during cutscene but had couldn't find option for value '" + 
									string(check_val) + "'.\nInjecting default 'cutscene_wait' action.\n");
	} else {
		// the value was found! Use its index in the outcomes array
		injected_commands_array = outcomes_array[value_index];
	}
	
	// inject the chosen scene into the cutscene's current spot
	// we don't care about preserving those scenes which already occured, so we make a new array from here
	var num_injected_commands = array_length(injected_commands_array);
	var num_old_commands = array_length(scene_info)
	
	//show_message("num_injected_commands"  + string(num_injected_commands));
	//show_message("scene_info"  + string(num_old_commands));
	//show_message("command_index" + string(command_index));
	
	var new_len = num_injected_commands + num_old_commands - (command_index + 1); // scene is the index of the current scene in scene_info
	var new_scene_info = array_create(new_len);
	
	// push in the new commands at the start of this new scene we've made space for
	array_copy(new_scene_info, 0, injected_commands_array, 0, num_injected_commands);
	
	// copy over everything that came AFTER the current scene
	array_copy(new_scene_info, num_injected_commands, scene_info, command_index + 1, new_len - num_injected_commands);
	//show_message(new_len);
	
	//move back one to play the injected command, now that it has taken the place of the branch command
	command_index = -1;
	// replace scene_info with the new one
	scene_info = new_scene_info;
	
	cutscene_end_action();
}