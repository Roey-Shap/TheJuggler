
//if !surface_bug_flag {
//	surface_bug_flag = true;
//	surface_reset_target();
//}

switch (state_game) {
	case st_game_state.main_menu:
		with (o_button_parent) {
			draw_self();
		}
	break;
	
	case st_game_state.playing:
		//if get_level_data().is_scrolling_level() {
		//	instance_deactivate_layer("Enemy Layer");
		//}
		
		var shape = get_current_shape_value();
		if shape != symbol_type.LAST and shape != symbol_type.partially_formed {
			var ordered_pressed_buttons = concat_arrays([], current_buttons_in_shape);
			array_sort(ordered_pressed_buttons, function(e1, e2) {
				var i1 = array_find(o_manager.correctly_ordered_buttons, e1.button_value); 
				var i2 = array_find(o_manager.correctly_ordered_buttons, e2.button_value); 
				return sign(i2 - i1);
			});
			
			draw_set_color(c_lime);
			var b1 = get_pos(ordered_pressed_buttons[0]);
			var b2 = get_pos(ordered_pressed_buttons[1]);
			var num_buttons = array_length(ordered_pressed_buttons);
			for (var i = 0; i < num_buttons; i++) {
				draw_line_width(b1.x, b1.y, b2.x, b2.y, 3);
				b1 = b2;
				b2 = get_pos(ordered_pressed_buttons[(i+2) % num_buttons]);
			}
		}
		
		with (o_button_parent) {
			draw_self();
		}
		
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
			
			draw_from_list(global.sprite_FX_list_over);
			draw_from_list(global.TextFX_list_over);

			surface_reset_target();
		}
		
		with (o_player) {
			if o_manager.get_level_data().level_type == eLevelType.platforming {
				draw_custom(new Vector2(0, 0));
			}
		}
	break;
}

draw_from_list(global.sprite_FX_list_over, true);
draw_from_list(global.TextFX_list_over, true);