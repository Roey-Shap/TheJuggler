


//if DEVELOPER_MODE {
//	if keyboard_check_pressed(ord("0")) {
//		watch_platforming_growth_perform_transition = true;
//		watch_growth_transition_timer.start();
//	}
//}

if watch_platforming_growth_perform_transition {
	watch_growth_transition_timer.tick();
	if !watch_growth_transition_timer.is_done() {
		obscure_screen_alpha_target = 1;
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
		if room == rm_game {
			if !has_done_intro {
				has_done_intro = true;
				cs_get_watch_from_seller.play();
			}
		}
		//else if mouse_check_button_pressed(key_accept) {
		//	if room == rm_main_menu {
		//		room = rm_game;
		//	}
		//}
	break;
	
	case st_game_state.playing:
		if game_is_frozen() {
			break;
		}
		
		level_title_timer.tick();
		
		if level_title_timer.is_done() {
			//consecutive_hit_timer.tick();
			consecutive_hit_sound_factor -= 0.75 * (1 / 60) * DELTATIME;
			consecutive_hit_sound_factor = max(consecutive_hit_sound_factor, 1);
		}
		
		var level_normal = get_level_data().level_type == eLevelType.normal;
		var level_platforming = get_level_data().level_type == eLevelType.platforming;
		if level_normal or (!get_level_data().charging_level and level_platforming) {
			if watch_growth_transition_timer.is_done() and between_symbols_error_timer.is_done() {
				between_symbols_timer.tick();
			}
			
			if between_symbols_timer.is_done() {
				between_symbols_timer.start();
			
				//if num_enemies_created_this_wave < current_wave_size {
				
				//}
				create_symbol();
				if get_num_symbols() >= symbol_penalty_threshold {
					between_symbols_error_timer.set_and_start(between_symbols_timer.countdown_duration);
					var removed_symbol = symbol_manager.pop_symbol(0);
					if get_level_data().killed_symbols_become_bullets {	// if your killed symbols become bullets, then neglected ones should just hit
						var bombs = drop_bombs(irandom_range(3, 5));
					} else {
						if get_level_data().level_type == eLevelType.normal {
							hit_player();
						} else {
							var spawn_pos = bbox_center(removed_symbol).iadd(new Vector2(0, removed_symbol.sprite_height/2));
							var bombs = drop_bombs(2);
						}
						//spawn_bullet_towards_player(spawn_pos);
					}
					
					removed_symbol.destroy_alt_anim_setup();
					instance_destroy(removed_symbol);
				}
			}
		
			var devskip = DEVELOPER_MODE and keyboard_check_pressed(ord("V"));
			if num_enemies_defeated_this_wave >= current_wave_size or devskip {
				start_next_wave();
			}
		} else if get_level_data().charging_level {
			var player = instance_nearest(x, y, o_player);
			if player.y >= -virtual_camera_corner.y + o_screen.sprite_height + player.sprite_height/2 {
				player.y = -virtual_camera_corner.y - player.sprite_height/2;
			}
			
			if watch_growth_transition_timer.is_done() {
				between_symbols_timer.tick();
			}
			
			var no_symbol_off_screen = true;
			var left_bound = -virtual_camera_corner.x;
			for (var i = 0; i < get_num_symbols(); i++) {
				var symbol = symbol_manager.active_symbols[i];
				if symbol.bbox_left <= left_bound {
					no_symbol_off_screen = false;
					break;
				}
			}
			
			var can_add_symbol = between_symbols_timer.is_done() and no_symbol_off_screen and get_num_symbols() < symbol_penalty_threshold;
			if can_add_symbol {
				between_symbols_timer.start();
			
				create_symbol();
				if get_num_symbols() >= symbol_penalty_threshold {
					var removed_symbol = symbol_manager.pop_symbol(0);
					//if get_level_data().killed_symbols_become_bullets {	// if your killed symbols become bullets, then neglected ones should just hit
					//	var bombs = drop_bombs(irandom_range(3, 5));
					//} else {
					//	if get_level_data().level_type == eLevelType.normal {
					//		hit_player();
					//	} else {
					//		var spawn_pos = bbox_center(removed_symbol).iadd(new Vector2(0, removed_symbol.sprite_height/2));
					//		var bombs = drop_bombs(2);
					//	}
					//	//spawn_bullet_towards_player(spawn_pos);
					//}
					
					removed_symbol.destroy_alt_anim_setup();
					instance_destroy(removed_symbol);
				}
			}
		}
	break;
}


between_symbols_error_timer.tick();


