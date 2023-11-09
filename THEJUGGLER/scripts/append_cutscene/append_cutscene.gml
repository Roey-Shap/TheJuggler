// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function append_cutscene(injected_commands_array, _parent, freeze_battle, end_action=true){
	
	with (o_cutscene) {
		array_push(next_data, [_parent, freeze_battle]);
	
		// add a trigger to change the cutscene's parent and freeze status
		array_insert(injected_commands_array, 0, [cutscene_custom_action, function() {
			var data = array_pop(next_data);
			parent = data[0];
			freeze_battle = data[1];
		}]);
	
		// inject the chosen scene into the cutscene's current spot
		// we don't care about preserving those scenes which already occured, so we make a new array from here
		var num_injected_commands = array_length(injected_commands_array);
		var num_old_commands = array_length(scene_info);
	
		//show_message("num_injected_commands"  + string(num_injected_commands));
		//show_message("scene_info"  + string(num_old_commands));
		//show_message("command_index" + string(command_index));
		
		var new_len = num_injected_commands + num_old_commands - (command_index + 1);
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
		
		if end_action {
			cutscene_end_action();
		}
	}
}