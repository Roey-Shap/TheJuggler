function cutscene_drop_item(pos, item, function_to_run_with_item=-1) {
	
	var obj_item = create_fresh_item(item);
	with (obj_item) {
		overworld_x = pos.x;
		overworld_y = pos.y;
		x = overworld_x;
		y = overworld_y;
		//dropped = true;
		
		if function_to_run_with_item != -1 {
			function_to_run_with_item(id);
		}
	}
	
	
	cutscene_end_action();
}