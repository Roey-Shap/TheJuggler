/// @description 

//with (o_player) {
//	reset_action();
//}

//if instance_exists(parent) {
//	parent.on_touch = true;
//	if variable_instance_exists(parent, "destroy_trigger_after_cutscene"){
//		if parent.destroy_trigger_after_cutscene {
//			instance_destroy(parent);
//		}
//	}
//}

//var character_names = variable_struct_get_names(speaker_object_map);
//var num_character_names = array_length(character_names);
//for (var i = 0; i < num_character_names; i++) {
//	var cur_name = character_names[i];
//	var cur_character = variable_struct_get(speaker_object_map, cur_name);
//	if instance_exists(cur_character) {
//		handle_speaking_stop(cur_character);
//	}
//}

//global.current_pathfinding_grid = -1;

//array_remove(o_manager.cutscene_objects_ordered, id);
