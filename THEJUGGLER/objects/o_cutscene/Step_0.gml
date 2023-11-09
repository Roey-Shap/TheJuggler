/// @description Execute and track scripts

// use index 0 of current_command because that's the script index
// i.e. that's the script which the argument current_command_array holds are
// fed into
cutscene_execute_alt(current_command[0], current_command_array);