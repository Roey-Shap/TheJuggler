
//if !surface_bug_flag {
//	surface_bug_flag = true;
//	surface_reset_target();
//}

switch (state_game) {
	case st_game_state.main_menu:
		
	break;
	
	case st_game_state.playing:
		//if get_level_data().is_scrolling_level() {
		//	instance_deactivate_layer("Enemy Layer");
		//}

		//surface_reset_target();
		if surface_exists(in_screen_draw_surface) {
			var s = surface_set_target(in_screen_draw_surface);		
			draw_clear_alpha(c_black, 0);
			var custom_draw_targets = [o_collision, o_player, o_billboard];
			for (var i = 0; i < array_length(custom_draw_targets); i++) {
				with (custom_draw_targets[i]) {
					draw_custom(o_manager.virtual_camera_corner);
				}
			}
			
			draw_from_list(global.sprite_FX_list_over, true);
			draw_from_list(global.TextFX_list_over, true);

			surface_reset_target();
		}
		
		with (o_player) {
			if o_manager.get_level_data().level_type == eLevelType.platforming {
				draw_custom(new Vector2(0, 0));
			}
		}
	break;
}

draw_from_list(global.sprite_FX_list_over);
draw_from_list(global.TextFX_list_over);