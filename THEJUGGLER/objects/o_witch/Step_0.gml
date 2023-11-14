
platforming_active = o_manager.get_level_data().witch_active and !o_manager.game_is_frozen();

if platforming_active {
	action_timer.tick();
	var percent_done = 0;
	var pos, spd, dir, bullet;
	switch (state_current) {
		case e_witch_state.none:
			performed_shot = false;
			performed_shot_sound = false;
			//if hit_roll(0.005) {
			//	hspd = random_range(-2, 2);
			//	vspd = random_range(-2, 2);
			//}
			
			if action_timer.is_done() {
				hspd = 0;
				vspd = 0;
				begin_random_action();
			}
		break;
		
		case e_witch_state.flying_to_side:
			percent_done = action_timer.get_percent_done();
			x = sample_curve(cv_witch_flying_away_pos, percent_done, stored_position.x, target_position.x);
			y = target_position.y + sample_curve(cv_witch_flying_away_pos, percent_done) * 100;
			if action_timer.is_done() {
				store_position();
				
				state_current = e_witch_state.flying_back_across;
				action_timer.set_and_start(get_frames(2.25));
				turn_to(-target_side_for_flyby);
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
			
			shot_timer.tick();
			
			if shot_timer.is_done() {
				if shots_left > 0 {
					shots_left -= 1;
					play_sound(sound_shot_release);
					switch(flyby_type_current) {
						case e_witch_flying_across_type.at_player:
							spd = 4;
							pos = new Vector2(x, y - sprite_height * 0.75);
							dir = point_direction(pos.x, pos.y, o_player.x, o_player.y);
							bullet = fire_bullet(pos, spd, dir);
							bullet.image_blend = array_pick_random(global.c_magic_colors);
							shot_timer.set_and_start(get_frames(0.9));
						break;
				
						//case e_witch_flying_across_type.at_player_difficult:
						//	spd = 5;
						//	dir = point_direction(x, y, o_player.x, o_player.y);
						//	bullet = fire_bullet(get_pos(id), spd, dir);
						//	var _scale = 1.2;
						//	bullet.image_xscale = _scale;
						//	bullet.image_yscale = _scale;
						//	bullet.image_blend = array_pick_random(global.c_magic_colors);
						//	shot_timer.set_and_start(get_frames(0.9));
						//break;
				
						case e_witch_flying_across_type.radial:
							var num_angles = 8;
							for (var i = 0; i < num_angles; i++) {
								spd = 6;
								dir = 360 * (i / num_angles);
								bullet = fire_bullet(get_pos(id), spd, dir);
								var _scale = 0.65;
								bullet.image_xscale = _scale;
								bullet.image_yscale = _scale;	
								bullet.image_blend = array_pick_random(global.c_magic_colors);
							}
						break;
					}					
				}
			} else {
				if hit_roll(0.02) {
					var particle_noise = 5;
					var ran_x = x + irandom_range(-particle_noise, particle_noise);
					var ran_y = y + irandom_range(-particle_noise, particle_noise);
					var ran_spr = choose(spr_fx_sparkle_1, spr_fx_dust_1, spr_fx_dust_3);
					var fx = new SpriteFX(ran_x, ran_y, ran_spr, 1);
					fx_setup_screen_layer(fx);
					var s = irandom_range(0.9, 1.1);
					fx.hspd = target_side_for_flyby * random_range(-0.1, 2);	// current going opposite to target_side_for_flyby
					fx.vspd = random_range(-0.3, 2);
					fx.image_xscale = s;
					fx.image_yscale = s;
					fx.image_angle = irandom_range(-10, 10);
					fx.image_blend = array_pick_random(concat_arrays([c_white], global.c_magic_colors)); //merge_color(c_white, global.c_magic, random_range(0, 0.1));
				}
				
				if shot_timer.get_count_seconds() <= audio_sound_length(sound_shot_charge) and !performed_shot_sound {
					performed_shot_sound = true;
					play_sound(sound_shot_charge);
				}
				
				image_blend = merge_color(c_white, shot_color, shot_timer.get_percent_done());
			}
			
			if action_timer.is_done() {
				begin_return_to_neutral();
			}
		break;
		
		case e_witch_state.return_to_neutral:
			percent_done = action_timer.get_percent_done();
			x = lerp(stored_position.x, default_position.x, percent_done);
			y = lerp(stored_position.y, default_position.y, percent_done);
			
			if action_timer.is_done() {
				return_to_waiting();
			} else {
				image_blend = merge_color(shot_color, c_white, action_timer.get_percent_done());
			}
		break;
		
		case e_witch_state.dropping_bombs_fly_up:
			percent_done = action_timer.get_percent_done();
			x = stored_position.x + sample_curve(cv_witch_flying_up_pos, percent_done, stored_position.x, target_position.x) * 100;
			y = stored_position.y - sample_curve(cv_witch_flying_up_pos, percent_done) * 500;
			
			if action_timer.is_done() {
				drop_bombs();
				begin_return_to_neutral(7);
			}
		break;
	}
		
}



x += hspd;
y += vspd;

