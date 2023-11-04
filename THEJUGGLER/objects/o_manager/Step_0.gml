
switch (state_game) {
	case st_game_state.main_menu:
		if mouse_check_button_pressed(key_accept) {
			state_game = st_game_state.playing;
			start_next_level();
		}
	break;
	
	case st_game_state.playing:
		between_symbols_timer.tick();
		if between_symbols_timer.is_done() {
			between_symbols_timer.start();
			
			if num_enemies_created_this_wave < current_wave_size {
				create_symbol();
				if get_num_symbols() >= symbol_penalty_threshold {
					hit_player();
				}
			}
		}
		
		if get_num_symbols() == 0 and num_enemies_created_this_wave >= current_wave_size {
			start_next_wave();
		}
	break;
}