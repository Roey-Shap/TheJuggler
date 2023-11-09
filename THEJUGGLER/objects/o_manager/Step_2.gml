fx_perform_step();

if get_level_data().level_type == eLevelType.sidescrolling and watch_growth_transition_timer.is_done() {
	if !surface_exists(in_screen_draw_surface) {
		var screen = instance_nearest(0, 0, o_screen);
		in_screen_draw_surface = surface_create(screen.sprite_width, screen.sprite_height);
	}
}

if instance_exists(o_player) {
	if playing_normal_platforming_level() {
		virtual_camera_corner = new Vector2(0, 0);
	} else {
		var screen = instance_nearest(0, 0, o_screen);
		var w = screen.sprite_width;
		var h = screen.sprite_height;
		virtual_camera_corner = (get_pos(instance_nearest(x, y, o_player)).sub(new Vector2(w/2, h/2))).multiply(-1);
	}
} else {
	virtual_camera_corner = new Vector2(0, 0);
}