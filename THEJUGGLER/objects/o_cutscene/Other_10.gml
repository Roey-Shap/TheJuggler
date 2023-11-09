/// @description Get next scene info


if !have_started {
	var l = array_length(scene_info);
	command_index = 0;
}

have_started = true;


current_command = scene_info[command_index];


var len = array_length(current_command)-1;
current_command_array = array_create(len, 0);

array_copy(current_command_array, 0, current_command, 1, len);

