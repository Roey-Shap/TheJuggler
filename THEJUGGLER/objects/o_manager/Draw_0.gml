

switch (state_game) {
	case st_game_state.main_menu:
		
	break;
	
	case st_game_state.playing:
		//if get_level_data().is_scrolling_level() {
		//	instance_deactivate_layer("Enemy Layer");
		//}

		//surface_set_target(in_screen_draw_surface);
		//with_each([o_collision, o_player, o_billboard], function() {
		//	draw_custom(o_manager.virtual_camera_corner);
		//})

		//surface_reset_target();
		
		with (o_player) {
			if platforming_active {
				draw_custom(new Vector2(0, 0));
			}
		}
		
		//var screen = instance_nearest(0, 0, o_screen);
		//draw_rectangle(screen.bbox_left, screen.bbox_top, screen.bbox_right, screen.bbox_bottom, false);
	break;
}

draw_from_list(global.sprite_FX_list_over);
draw_from_list(global.TextFX_list_over);