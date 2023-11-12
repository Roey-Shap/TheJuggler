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

if !surface_exists(in_screen_draw_surface) and watch_growth_transition_timer.is_done() and watch_platforming_growth_perform_transition {
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

