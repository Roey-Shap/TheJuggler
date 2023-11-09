function pathfinding_setup(top_left, dims_overworld, exempt_objects=[]) {
	var grid_width = dims_overworld.x div TILE_SIZE_WORLD;
	var grid_height = dims_overworld.y div TILE_SIZE_WORLD;
	global.current_pathfinding_grid = mp_grid_create(top_left.x, top_left.y, 
													 grid_width, grid_height, 
													 TILE_SIZE_WORLD, TILE_SIZE_WORLD);
	with (o_cellobj_character_parent) {
		var overworld_cell_coords = get_overworld_tile(overworld_x, overworld_y, true);
		var top_left_overworld_cell = get_overworld_tile(top_left.x, top_left.y, true);
		var grid_cell_coords = overworld_cell_coords.sub(top_left_overworld_cell);
		var in_check_range = in_rectangle(grid_cell_coords.x, grid_cell_coords.y, 0, 0, grid_width-1, grid_height-1);
		var has_mask = mask_index != spr_no_collision;
		if in_check_range and has_mask and !isIn(id, exempt_objects)
		{
			mp_grid_add_cell(global.current_pathfinding_grid, grid_cell_coords.x, grid_cell_coords.y);				
		}	
	}
}

function pathfinding_setup_for_obj(obj, pos) {
	var success = false;
	with (obj)
	{
		if path_overworld_cutscene == -1 {
			path_overworld_cutscene = path_add();
			success = mp_grid_path(global.current_pathfinding_grid, path_overworld_cutscene, overworld_x, overworld_y, pos.x, pos.y, false);
			if !success {
				if DEBUG {
					debug_spark(overworld_x, overworld_y, c_red);
				}
				path_overworld_cutscene = -1;
			}
			cur_path_point_index = 0;
		}
		
		if path_overworld_cutscene != -1 {
			success = true;
		}
	}
	
	return success;
}

function cutscene_pathfind(obj, pos, frames_between_movement, func=-1) {
	if is_string(obj) {
		obj = cs_get_speaker_helper(obj);
	}
	
	o_manager.cutscene_pathfind_obj = obj; 
	
	var clamped_x = clamp(pos.x, 0, room_width - TILE_SIZE_WORLD);
	var clamped_y = clamp(pos.y, 0, room_height - TILE_SIZE_WORLD);
	pos = new Vector2(floor_to(clamped_x, TILE_SIZE_WORLD), floor_to(clamped_y, TILE_SIZE_WORLD));
	
	if global.current_pathfinding_grid == -1 {
		if DEBUG debug_spark(obj.overworld_x + 5, obj.overworld_y, c_green);
		var top_left = new Vector2(0, 0);
		var dims_overworld = new Vector2(floor_to(room_width, TILE_SIZE_WORLD), floor_to(room_height, TILE_SIZE_WORLD));
		pathfinding_setup(top_left, dims_overworld, [obj, PLAYER]);
	}
	var is_path = pathfinding_setup_for_obj(obj, pos);
	if !is_path {
		if DEBUG debug_spark(obj.overworld_x, obj.overworld_y, c_purple);
		return;
	}
	
	var finish_command = false;
	
	timer += 1; 

	if timer >= frames_between_movement {
		if func != -1 {
			with (obj) {
				func();
			}
			
		}
		
		timer = 0;
		if DEBUG debug_spark(obj.overworld_x, obj.overworld_y);
		
		with (obj) {
			cur_path_point_index++;
			if cur_path_point_index >= path_get_number(obj.path_overworld_cutscene)-1 {
				finish_command = true;
			} else {
				if DEBUG debug_spark(obj.overworld_x, obj.overworld_y, c_teal);
				overworld_x = path_get_point_x(path_overworld_cutscene, cur_path_point_index) + sprite_xoffset - TILE_SIZE_WORLD/2;
				overworld_y = path_get_point_y(path_overworld_cutscene, cur_path_point_index) + sprite_yoffset - TILE_SIZE_WORLD/2;
				x = overworld_x;
				y = overworld_y;
			}
			//db_show([get_overworld_coords(id), pos, cur_path_point_index, path_get_number(path_overworld_cutscene)])
		}
		
		if finish_command {
			path_overworld_cutscene = -1;
			o_manager.cutscene_pathfind_obj = noone;
			cutscene_end_action();
		}
	}
}
