
platforming_active = o_manager.get_level_data().level_type != eLevelType.normal;

if platforming_active {
	var hinput = keyboard_check(key_right) - keyboard_check(key_left);
	var vinput = keyboard_check(key_down) - keyboard_check(key_up);
	var jinput = keyboard_check_pressed(key_up);
	
	var _game_is_frozen = o_manager.game_is_frozen();
	hinput *= !_game_is_frozen;
	vinput *= !_game_is_frozen;
	jinput *= !_game_is_frozen;
	
	jumped_this_frame = false;
	
	if hinput != 0 {
		//var _fast_falling_hspd_factor = fast_falling? fast_falling_hspd_factor : 1;
		hspd = hinput * movespd;
	} else {
		hspd = lerp(hspd, 0, fric);
	}
	
	if jinput {
		buffer_jump_timer.start();
	}
	
	if !coyote_time_timer.is_done() {
		if !buffer_jump_timer.is_done() {
			perform_jump();
		}
	}
	
	if grounded {
		
	} else {
		if keyboard_check_pressed(key_down) {
			initiate_fast_fall();
		}
		
		if fast_falling {
			if round(current_time) % 2 == 0 {
				var fx = new FadeFX(x, y, sprite_index, 1, image_index, get_frames(0.25));
				fx_setup_screen_layer(fx);
			}
		} else {
			var adjusted_gravity_factor = !player_jump or (player_jump and vinput < 0)? 1 : 1.7;
			vspd += grav * adjusted_gravity_factor;
		}
	}
	
	manage_cutscene_triggers();
	manage_collision();
	manage_bullets();
	grounded_check();
	manage_sprite();
	manage_checkpoint_collisions();
	if vspd >= 0.1 {
		player_jump = false;
	}
	
	coyote_time_timer.tick();
	if grounded {
		if !grounded_last {
			perform_landing();
		}
		
		fast_falling = false;
		if !jumped_this_frame {
			player_jump = false;
			coyote_time_timer.start();
		}
	}
	
	x += hspd;
	y += vspd;
	
	grounded_last = grounded;
	invulnerability_timer.tick();
	buffer_jump_timer.tick();
}

var invuln_flash_frequency = round_to((map(0, invulnerability_timer.countdown_duration, invulnerability_timer.current_count, 3, 20)), 4);
if !invulnerability_timer.is_done() {
	if round(invulnerability_timer.current_count) % invuln_flash_frequency == 0 {
		image_alpha = 0.2;
	} else {
		image_alpha = 1;
	}
}
