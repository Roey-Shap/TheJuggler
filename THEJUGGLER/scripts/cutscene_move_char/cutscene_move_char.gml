// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cutscene_move_char(object, offset, times, frames_between_movement){
	
	timer += 1; 

	if timer >= frames_between_movement {
		timer = 0;
		
		with (object) {
			battle_remove_from_pos();
			battle_x += offset.x;
			battle_y += offset.y;
			battle_add_to_pos();
		}
		
		times_moved_char += 1;
		if times_moved_char == times {
			times_moved_char = 0;
			cutscene_end_action();
		}
	}
}

function cutscene_move_char_overworld(object, offset, times, frames_between_movement) {
	if is_string(object) {
		object = cs_get_speaker_helper(object);
	}
	
	timer += 1; 

	if timer >= frames_between_movement {
		timer = 0;
		
		with (object) {
			overworld_x += offset.x * TILE_SIZE_WORLD;
			overworld_y += offset.y * TILE_SIZE_WORLD;
		}
		
		times_moved_char += 1;
		if times_moved_char == times {
			times_moved_char = 0;
			cutscene_end_action();
		}
	}
	
}