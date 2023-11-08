fx_perform_step();

//if !surface_exists(in_screen_draw_surface) {
//	var screen = instance_nearest(0, 0, o_screen);
//	in_screen_draw_surface = surface_create(screen.sprite_width, screen.sprite_height);
//}

if instance_exists(o_player) {
	if playing_normal_platforming_level() {
		if instance_exists(o_screen) {
			//var screen = instance_nearest(0, 0, o_screen);
			virtual_camera_corner = new Vector2(0, 0);
		}
	} else {
		virtual_camera_corner = get_pos(instance_nearest(x, y, o_player)).sub(new Vector2(CAM_W/2, CAM_H/2)).multiply(-1);
	}
}