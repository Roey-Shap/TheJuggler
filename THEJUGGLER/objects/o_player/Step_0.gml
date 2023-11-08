
if platforming_active {
	var hinput = keyboard_check(key_right) - keyboard_check(key_left);
	var vinput = keyboard_check(key_down) - keyboard_check(key_up);
	jumped_this_frame = false;
	
	if hinput != 0 {
		//var _fast_falling_hspd_factor = fast_falling? fast_falling_hspd_factor : 1;
		hspd = hinput * movespd;
	} else {
		hspd = lerp(hspd, 0, fric);
	}
	
	if grounded {
		if keyboard_check_pressed(key_up) {
			perform_jump();
		}
	} else {
		if keyboard_check_pressed(key_down) {
			fast_falling = true;
		}
		
		if fast_falling {
			if round(current_time) % 1 == 0 {
				var fx = new FadeFX(x, y, sprite_index, 1, image_index, get_frames(0.25));
			}
			
			vspd = fast_fall_speed;
		} else {
			var adjusted_gravity_factor = !player_jump or (player_jump and vinput < 0)? 1 : 1.7;
			vspd += grav * adjusted_gravity_factor;
		}
	}
	
	manage_collision();
	manage_bullets();
	grounded_check();
	manage_checkpoint_collisions();
	if vspd >= 0.1 {
		player_jump = false;
	}
	
	if grounded {
		fast_falling = false;
		if !jumped_this_frame {
			player_jump = false;
		}
	}
	
	x += hspd;
	y += vspd;
	
	grounded_last = grounded;
	invulnerability_timer.tick();
}


