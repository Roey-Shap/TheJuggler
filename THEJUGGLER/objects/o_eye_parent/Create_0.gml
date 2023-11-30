
store_init_watch_params();

array_push(o_manager.eyes, id);

open_speed = random_range(0.7, 1);

image_index = 0;
image_speed = 0;

sprite_eyeball = spr_eye_1_center;
open = false;

start_opening = function() {
	open = true;
	image_speed = open_speed;
}

draw_custom = function() {
	draw_sprite_ext(sprite_index, image_index,
					x, y, image_xscale, image_yscale, 
					image_angle, image_blend, image_alpha);
	
	var screen = instance_nearest(x, y, o_screen);
	var player = instance_nearest(x, y, o_player);
	var up_left = new Vector2(screen.bbox_left, screen.bbox_top);
	var player_offset_from_camera_top_left = get_pos(player).sub(o_manager.virtual_camera_corner.multiply(-1));
	var on_screen_player_coords = up_left.add(player_offset_from_camera_top_left);
	
	if image_index >= image_number-1.5 {
		var dir_to_player = point_direction(x, y, on_screen_player_coords.x, on_screen_player_coords.y);
		var trig = sin((current_time + x + y) / 200);
		dir_to_player += 5 * map(-1, 1, trig, -1, 1);
		var l = 15 * abs(image_xscale);
		var n = max(2, 3 * abs(image_xscale));
		var xbob = (l / 3) * map(-1, 1, trig, -1, 1);
		var ybob = (l / 3) * map(-1, 1, trig, 1, -1);
		var offx = lengthdir_x(l, dir_to_player) + irandom_range(-n, n) + xbob;
		var offy = lengthdir_y(l, dir_to_player) + irandom_range(-n, n) + ybob;
		var s = max(abs(image_xscale), abs(image_yscale));
		draw_sprite_ext(sprite_eyeball, 0,
					x + round(offx), y + round(offy), s, s, 
					dir_to_player + (xbob), image_blend, image_alpha);
		
	}
}