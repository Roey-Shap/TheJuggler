


if DEVELOPER_MODE {
	if keyboard_check_pressed(ord("0")) {
		watch_platforming_growth_perform_transition = true;
		watch_growth_transition_timer.start();
	}
}

if watch_platforming_growth_perform_transition {
	watch_growth_transition_timer.tick();
	if !watch_growth_transition_timer.is_done() {
		var curve_amount = sample_curve(cv_watch_growth_rate, watch_growth_transition_timer.get_percent_done());
		var final_scale = watch_growth_final_scale;
		var objs = [o_screen, o_watch_screen_shade, o_watch_base, o_watch_wriststrap, o_button_parent];
		var num_objs = array_length(objs);
		for (var i = 0; i < num_objs; i++) {
			with (objs[i]) {
				image_xscale = lerp(xscale_base, xscale_base * final_scale, curve_amount);
				image_yscale = lerp(yscale_base, yscale_base * final_scale, curve_amount);
				x = x_init + (watch_center_original_delta.x * final_scale * curve_amount) - watch_center_original_delta.x * curve_amount;
				y = y_init + (watch_center_original_delta.y * final_scale * curve_amount) - watch_center_original_delta.y * curve_amount;
			}
		}
	}
}

switch (state_game) {
	case st_game_state.main_menu:
		if mouse_check_button_pressed(key_accept) {
			state_game = st_game_state.playing;
			start_next_level();
		}
	break;
	
	case st_game_state.playing:
		if game_is_frozen() {
			break;
		}
		
		level_title_timer.tick();
		
		if level_title_timer.is_done() {
			//consecutive_hit_timer.tick();
			consecutive_hit_sound_factor -= 0.65 * (1 / 60) * DELTATIME;
			consecutive_hit_sound_factor = max(consecutive_hit_sound_factor, 1);
		}
		
		if get_level_data().level_type != eLevelType.sidescrolling {
			if watch_growth_transition_timer.is_done() {
				between_symbols_timer.tick();
			}
		
			if between_symbols_timer.is_done() {
				between_symbols_timer.start();
			
				//if num_enemies_created_this_wave < current_wave_size {
				
				//}
				create_symbol();
				if get_num_symbols() >= symbol_penalty_threshold {
					hit_player();
					symbol_manager.pop_symbol(0);
				}
			}
		
			if num_enemies_defeated_this_wave >= current_wave_size or keyboard_check_pressed(ord("V")){
				start_next_wave();
			}
		}
	break;
}