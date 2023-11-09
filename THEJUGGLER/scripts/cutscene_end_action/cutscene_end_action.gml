function cutscene_end_action() {
	
	command_index++
	reset_flags();
	if command_index > array_length(scene_info)-1 {
		instance_destroy(id);
		exit;
	}

	// if the scene isn't done and the cutscene object hasn't
	// been destroyed, it runs the next scene it has
	event_perform(ev_other, ev_user0);
}
