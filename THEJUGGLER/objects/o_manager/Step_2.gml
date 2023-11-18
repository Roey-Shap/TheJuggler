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
		virtual_camera_corner = (get_pos(instance_nearest(x, y, o_player)).sub(offset_from_player)).multiply(-1);
	} else {
		virtual_camera_corner = (get_pos(inst_anchor_screen_bottom_right).sub(new Vector2(w, h * 1))).multiply(-1);
	}
	
	if !shake_timer.is_done() {
		camera_offset = shake_intensity.multiply(choose(1, -1)).lerp_to(vector_zero(), shake_timer.get_percent_done());
		virtual_camera_corner.iadd(camera_offset);
	}

	symbol_draw_scale = get_level_data().level_type == eLevelType.platforming? symbol_draw_scale_platforming : symbol_draw_scale_default;
}

obscure_screen_alpha = lerp(obscure_screen_alpha, obscure_screen_alpha_target, 0.01);

shake_timer.tick();
draw_flicker.tick();
fade_timer.tick();

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

