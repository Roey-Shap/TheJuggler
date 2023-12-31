fx_perform_step();

//if get_level_data().level_type == eLevelType.sidescrolling {
//	if watch_growth_transition_timer.is_done() {
//		if !surface_exists(in_screen_draw_surface) {
//			var screen = instance_nearest(0, 0, o_screen);
//			in_screen_draw_surface = surface_create(screen.sprite_width, screen.sprite_height);
//		}
//	}
//} else {
//	if surface_exists(in_screen_draw_surface) {
//		surface_free(in_screen_draw_surface);
//	}
//}
if state_game == st_game_state.playing {
	var watch_growth_done = watch_growth_transition_timer.is_done() and watch_platforming_growth_perform_transition;
	if !surface_exists(in_screen_draw_surface) and (watch_growth_done) {
		var screen = instance_nearest(0, 0, o_screen);
		in_screen_draw_surface = surface_create(screen.sprite_width, screen.sprite_height);
	}

	var screen = instance_nearest(0, 0, o_screen);
	var w = screen.sprite_width;
	var h = screen.sprite_height;
	var playing_sidescrolling = o_manager.get_level_data().level_type == eLevelType.sidescrolling;
	if playing_sidescrolling {
		var offset_from_player = new Vector2(w/2, h*0.65); //?  : new Vector2(w/2, h/2);
		var target = (get_pos(instance_nearest(x, y, o_player)).sub(offset_from_player)).multiply(-1);
		var bounding_radius = w * 0.35;
		if virtual_camera_corner == -1 {
				virtual_camera_corner = target;
		}
		
		virtual_camera_corner.x = lerp(virtual_camera_corner.x, target.x, 0.3);	

		//if abs(virtual_camera_corner.x - target.x) >= bounding_radius {
		//}
		
		if o_player.grounded or (abs(virtual_camera_corner.y - target.y) >= h * 0.1) {
			virtual_camera_corner.y = lerp(virtual_camera_corner.y, target.y, 0.08);
		}
	} else {
		virtual_camera_corner = (get_pos(inst_anchor_screen_bottom_right).sub(new Vector2(w, h * 1))).multiply(-1);
	}
	
	if !shake_timer.is_done() {
		camera_offset = shake_intensity.multiply(choose(1, -1)).lerp_to(vector_zero(), shake_timer.get_percent_done());
		virtual_camera_corner.iadd(camera_offset);
	}

	symbol_draw_scale = get_level_data().level_type == eLevelType.platforming? symbol_draw_scale_platforming : symbol_draw_scale_default;
	
	
	
	
	
	level_setup_happened = true;
}
 
obscure_screen_alpha = lerp(obscure_screen_alpha, obscure_screen_alpha_target, 0.01);
score_scale = lerp(score_scale, 0.8, 0.05);

if current_score > score_previous {
	var delta_score = current_score - score_previous;
	score_scale *= map(1, 3, delta_score, 1.02, 1.04);
}

score_previous = current_score;

shake_timer.tick();
draw_flicker.tick();
fade_timer.tick();

if keyboard_check_pressed(ord("T")) {
	place_player_at_anchor(inst_anchor_platforming_debug, false);
}
//if instance_exists(o_player) {
//	if playing_normal_platforming_level() {
//		virtual_camera_corner = new Vector2(0, 0);
//	} else {
//		var screen = instance_nearest(0, 0, o_screen);
//		var w = screen.sprite_width;
//		var h = screen.sprite_height;
//		virtual_camera_corner = (get_pos(instance_nearest(x, y, o_player)).sub(new Vector2(w/2, h*0.65))).multiply(-1);
//	}
//} else {
//	virtual_camera_corner = new Vector2(0, 0);
//}

