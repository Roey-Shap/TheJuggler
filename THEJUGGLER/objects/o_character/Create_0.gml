
draw_scale = new Vector2(1, 1);
platforming_active = false;

draw_custom = function(offset_pos, draw_shadow=false) {
	//var d = false;
	//with (o_player) {
	//	d = been_take_from_GUI;
	//}
	
	//if !d {
	//	return;
	//}
	
	if draw_shadow {
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x + LCD_SHADE_OFFSET.x, y + offset_pos.y + LCD_SHADE_OFFSET.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, global.c_lcd_shade, global.lcd_alpha_large * image_alpha);
	} else {
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x, y + offset_pos.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, image_blend, image_alpha);
	}
}