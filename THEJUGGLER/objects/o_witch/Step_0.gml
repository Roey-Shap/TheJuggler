
platforming_active = o_manager.get_level_data().level_type != eLevelType.normal;

if platforming_active {
	action_timer.tick();
	var percent_done = 0;
	var spd, dir, bullet;
	switch (state_current) {
		case e_witch_state.none:
			if action_timer.is_done() {
				begin_random_action();
			}
		break;
		
		case e_witch_state.flying_to_side:
			percent_done = action_timer.get_percent_done();
			x = sample_curve(cv_witch_flying_away_pos, percent_done, stored_position.x, target_position.x);
			y = sample_curve(cv_witch_flying_away_pos, percent_done, stored_position.y, target_position.y);
			if action_timer.is_done() {
				store_position();
				
				state_current = e_witch_state.flying_back_across;
				if target_side_for_flyby == 1 {
					target_position = flyby_position_left;
				} else {
					target_position = flyby_position_right;
				}
			}
		break;
		
		case e_witch_state.flying_back_across:
			percent_done = action_timer.get_percent_done();
			x = lerp(stored_position.x, target_position.x, percent_done);
			y = lerp(stored_position.y, target_position.y, percent_done);
			
			switch(flyby_type_current) {
				case e_witch_flying_across_type.at_player:
					if round(action_timer.get_count_seconds() * 100) % 75 == 0 {
						spd = 5;
						dir = point_direction(x, y, o_player.x, o_player.y);
						bullet = fire_bullet(get_pos(id), spd, dir);
					}
				break;
				
				case e_witch_flying_across_type.at_player_difficult:
					if round(action_timer.get_count_seconds() * 100) % 75 == 0 {
						spd = 5;
						dir = point_direction(x, y, o_player.x, o_player.y);
						bullet = fire_bullet(get_pos(id), spd, dir);
						var _scale = 1.2;
						bullet.image_xscale = _scale;
						bullet.image_yscale = _scale;
					}
				break;
				
				case e_witch_flying_across_type.radial:
					if round(action_timer.get_count_seconds() * 100) % 80 == 0 {
						var num_angles = 6;
						for (var i = 0; i < num_angles; i++) {
							spd = 6;
							dir = 360 * (i / num_angles);
							bullet = fire_bullet(get_pos(id), spd, dir);
							var _scale = 0.9;
							bullet.image_xscale = _scale;
							bullet.image_yscale = _scale;	
						}
					}
				break;
			}
			
			if action_timer.is_done() {
				state_current = e_witch_state.return_to_neutral;
				action_timer.set_duration(get_frames(2));
			}
		break;
	}
		
}



x += hspd;
y += vspd;

