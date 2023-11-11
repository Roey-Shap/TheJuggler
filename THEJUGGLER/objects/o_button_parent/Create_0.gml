image_speed = 0;
button_value = image_index;
pressed = false;

store_init_watch_params();

function set_pressed(press) {
	pressed = press;
}

function draw() {
	var col = isIn(id, o_manager.current_buttons_in_shape)? c_lime : image_blend;
	draw_sprite_ext(sprite_index, image_index, x, y, 
					image_xscale * scale_factor, image_yscale * scale_factor,
					image_angle, col, image_alpha);
}