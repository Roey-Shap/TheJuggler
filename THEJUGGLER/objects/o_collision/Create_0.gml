draw_custom = function(offset_pos) {
	draw_sprite_ext(sprite_index, image_index, x + offset_pos.x, y + offset_pos.y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}